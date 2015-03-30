=begin
TO DO - Reduce code repetition for exception handling in particular
=end

require 'set'
require 'singleton'
require 'stringio'
require 'strscan'

#method for working with relative filepaths came from 


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
	# TO DO This shouldnt return anything, is this possible in ruby?
		@due_date = due_date
	end
	
	def check_in()
	#TO DO Ditto check_out comment
		@due_date = nil
	end
	
	#to_s override
	def to_s()
	#TO DO Since this is overriding to_s do I need equiv of Java annotations?
		@id.to_s + ": " + @title + " by "  + @author
	end
	
	def to_s_no_id()
		@title + " " + @author
	end
	
end





#Member class
class Member
	
	#TO DO - do we want to raise type errors or will we have to do for everything?
	def initialize(name, library)
		#raise TypeError unless library.is_a? Library
		@name = name
		@library = library
		@books_on_loan = Set.new # http://ruby-doc.org/stdlib-2.2.1/libdoc/set/rdoc/Set.html
	end
	
	def get_name()
	 @name
	end
	
	def check_out(book)
		#raise TypeError unless book.is_a? Book
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
	
	#return true if book with id present else returns nil
	def get_book(id)
		for book in @books_on_loan
			if(book.get_id == id)
				return book
			end
		end
		nil
	end
	
	
	#TO IMPLEMENT
	# Tells this member that he/she has overdue books. (What the method actually does is just print out this member's name along with the notice.)
	#send_overdue_notice(notice)
	
end


class Library
	include Singleton
	
	
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
	
	
	
	
	
	def open()
		if(@libraryopen)
			#TO DO Handle this exception http://rubylearning.com/satishtalim/ruby_exceptions.html
			raise Exception.new("The library is already open!"	)
		else
			@libraryopen = true
			@calendar.advance()
			"Today is day " + @calendar.get_date().to_s
		end
	end
	
	
	
	
	def find_all_overdue_books()
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
		#TO DO throw library is not open exception if not open	
		if(@members[name_of_member] == nil)
			@members[name_of_member] = Member.new(name_of_member, self)
			"Library card issued to " + name_of_member
		else
			name_of_member + " already has a library card"
		end	
	end
	
	
	
	
	def serve(name_of_member)
		#T0 DO library not open exception
		#TO DO quite serving other member if any
		
		if(@members[name_of_member] == nil)
			name_of_member + " does not have a library card."
		else
			@member_being_served = @members[name_of_member]
			"Now serving " + name_of_member
		end	
	
	end
	
	
	
	
	
	def find_overdue_books()
		overdue_books = StringIO.new
		
		@member_being_served.get_books.each do |book|
			if(@calendar.get_date > book.get_due_date)
				overdue_books << book.to_s
			end
		end
		overdue_sbooks.size == 0 ? "None" : overdue_books.string
	
	end
	
	
	
	def check_in(*book_numbers)  
	#TO DO throw exceptions..
		# lib not open
		# no member currently being served
		for number in book_numbers
			book = @member_being_served.get_book(number)
			if (book == nil)
				raise 'member doesnt have book id: ' + number.to_s
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
		#TO DO throw exceptions..
		# lib not open
		# no member currently being served
		# library doesn't have book id
		
		for id in book_ids
			book = @book_collection[id]
			#TO DOcheck if exists
			
			book.check_out(@calendar.get_date() + 7)
			@member_being_served.check_out(book)
			@book_collection.delete(id)
		end
		
		book_ids.size.to_s + " books have been successfully checked out to " + @member_being_served.get_name()
	end
	
	

	def renew(*book_ids)	
		#TO DO throw exceptions..
		# lib not open
		# no member currently being served
		for id in book_ids
			book = @member_being_served.get_book(id)
			if (book == nil)
				raise 'member doesnt have book id: ' + id.to_s
			else	
				book.check_out(book.get_due_date() + 7)
			end	
		end
		book_ids.size.to_s + " books have been renewed for " + @member_being_served.get_name()
	end		
	
	def close()
		# TO DO add exceptions
		@libraryopen = false
		"Good Night"
	end
	
	#def quit()
	
	
	
 end	