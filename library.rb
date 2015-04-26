require 'set'
require 'singleton'
require 'stringio'
require 'strscan'



#CALENDAR CLASS
class Calendar
	include Singleton
	
	def initialize()
		@date = 0
	end
	
	def get_date()
		@date
	end
	
	def advance()
		@date += 1	
	end
	
	def self.reset
		@singleton__instance__ = nil
	end
	
end




#BOOK CLASS
class Book
	
	def initialize(id, title, author)
		@id = id
		@title = title.strip
		@author = author.strip
		@due_date = nil
	end

	def get_id()
		@id
	end
	
	def get_title()
		@title
	end
	
	def get_author()
		@author
	end
	
	def get_due_date()
		@due_date
	end

	def check_out(due_date) 
		@due_date = due_date
	end
	
	def check_in()
	
		@due_date = nil
	end
	
	#to_s override
	def to_s()
		@id.to_s + ": " + @title + " by "  + @author
	end
	
	def to_s_no_id()
		@title + " " + @author
	end
	
end





#Member class
class Member
	
	def initialize(name, library)
		@name = name
		@library = library
		@books_on_loan = Set.new # http://ruby-doc.org/stdlib-2.2.1/libdoc/set/rdoc/Set.html
	end
	
	def get_name()
	 @name
	end
	
	def check_out(book)
		@books_on_loan.add(book)
		
	end
	
	def give_back(book)
		@books_on_loan.delete(book)
	end
	
	def return(book)
		give_back(book)
	end
	
	def get_books()
		@books_on_loan
	end
	
	def get_book(id)
		for book in @books_on_loan
			if(book.get_id == id)
				return book
			end
		end
		nil
	end
	
	
end


class Library
	include Singleton
	attr_reader :nextid, :calendar, :libraryopen
	
	def initialize()
	  @nextid = 1
	  @calendar = Calendar.instance
	  @members = Hash.new # The keys will be the names of members and the values will be the corresponding Member objects.
	  @libraryopen = false
	  @member_being_served = nil
	  
	  #Initialises the libraries collection from collection.txt
	  @book_collection = Hash.new
	  File.foreach("collection.txt") do |line|
		values = line.split(",")
		@book_collection[@nextid] = Book.new(@nextid, values[0], values[1])
		@nextid += 1
		end
		"Library system online"
	end
	
	
	def self.reset
		@singleton__instance__ = nil
	end
	
	
	#EXCEPTIONS
	def check_if_lib_open()
		if(@libraryopen)
			raise Exception.new("The library is already open!"	)
		end
	end
	
	def check_if_noone_being_served()
		if(@member_being_served == nil)
			raise Exception.new("No member is currently being served.")
		end
	end
	
	def open()
		check_if_lib_open()
			@libraryopen = true
			@calendar.advance()
			"Today is day " + @calendar.get_date().to_s
	end
	
	def find_all_overdue_books()
		check_if_lib_open()
		check_if_noone_being_served()
		
		s = StringIO.new

		@members.each do |name, member|
			overdue_books = StringIO.new
			s << member.get_name + "\n"
			
			member.get_books.each do |book|
				if(@calendar.get_date > book.get_due_date)
					overdue_books << "Overdue book " + book.to_s
				end
			end
				
			overdue_books.size == 0 ? s << "No books are overdue" + "\n" + "\n"	 : s << overdue_books.string + "\n" +"\n"
		end
		
		s.string
		
	end
	
	
	
	
	def issue_card(name_of_member)
		check_if_lib_open()	
		if(@members[name_of_member] == nil)
			@members[name_of_member] = Member.new(name_of_member, self)
			"Library card issued to " + name_of_member
		else
			name_of_member + " already has a library card"
		end	
	end
	
	
	
	
	def serve(name_of_member)
		check_if_lib_open()	
		
		if(@members[name_of_member] == nil)
			name_of_member + " does not have a library card."
		else
			@member_being_served = @members[name_of_member]
			"Now serving " + name_of_member
		end	
	
	end
	
	
	
	
	
	def find_overdue_books()
		check_if_lib_open()
		check_if_noone_being_served()
		
		overdue_books = StringIO.new
		
		@member_being_served.get_books.each do |book|
			if(@calendar.get_date > book.get_due_date)
				overdue_books << book.to_s
			end
		end
		overdue_sbooks.size == 0 ? "None" : overdue_books.string
	
	end
	
	
	
	def check_in(*book_numbers)  
		check_if_lib_open()
		check_if_noone_being_served()
		
		for number in book_numbers
			book = @member_being_served.get_book(number)
			if (book == nil)
				raise Exception.new ("member doesnt have book id:" + number.to_s)
			else	
				book.check_in
				@member_being_served.return(book)
				@book_collection[number] = book	
			end	
		end
		@member_being_served.get_name + " has returned " + book_numbers.size.to_s	 + " books" 
	end
	

	
	def search(string)	
		if (string.length < 4)
			return "Search string must contain at least four characters."
		end
		string = string.downcase
		found_books = StringIO.new
		found_books_set = Set.new
		
		@book_collection.each do |id, book|
			if (book.get_title.downcase.include? string or book.get_author.downcase.include? string)
				if !(found_books_set.member?(book.to_s_no_id)) 
					found_books << book.to_s
					found_books_set.add(book.to_s_no_id)
				end
			end
		end
		
		puts found_books_set.size
		found_books.size == 0 ? "No books found." : found_books.string
	end
	
	
	
	def check_out(*book_ids)
		check_if_lib_open()
		check_if_noone_being_served()
		
		for id in book_ids
			book = @book_collection[id]
			puts book
			if (book == nil)
				raise Exception.new("The library does not have book " + id.to_s)
			end
			
			book.check_out(@calendar.get_date() + 7)
			@member_being_served.check_out(book)
			@book_collection.delete(id)
		end
		
		book_ids.size.to_s + " books have been successfully checked out to " + @member_being_served.get_name()
	end
	
	

	def renew(*book_ids)	
		check_if_lib_open()
		check_if_noone_being_served()
		
		for id in book_ids
			book = @member_being_served.get_book(id)
			if (book == nil)
				raise Exception.new("The member doesnt have book id: " + id.to_s)
			else	
				book.check_out(book.get_due_date() + 7)
			end	
		end
		book_ids.size.to_s + " books have been renewed for " + @member_being_served.get_name()
	end		
	
	def close()
		if !(@libraryopen)
			raise Exception.new("The library is not open!"	)
		end
		@libraryopen = false
		"Good Night"
	end
	
	def quit()
		"The library is now closed for renovations"
	end
	
	
	
 end	