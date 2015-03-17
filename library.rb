=begin
Library software for librarian
	issue library cards
	check books out to members
	check books back in
	send overdue notices
	open / close library

Rules
	must have lib card to check out books
	max 3 books at a time
	books due 7 days after
	
Classes
	Calendar - track time as an int not using Time class
	Books  - contains book info and due date
	Member - is a customer of the library
			 must have lib card to check out books
			 max 3 books
	Library - Master class
			  These methods (other than constructor) will be typed in by librarian therefore params must be strings not numbers. 
			  Should all return result (to reassure librarian that actions working)
			  
			  
			  Collection of books from collection.txt stored as Tuples (title,author)
			  Calendar obj
			  Empty dictionary of members (key -> val) -= (membername -> Member)
			  Lib open closed boolean flag
			  Current member (one being served)
=end

require 'set'
require 'singleton'

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
		@title = title 
		@author = author
		@due_date = nil
	end

	def get_id()
		@id
	end
	
	def get_title()
		@title
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
		@id.to_s + ": " + @title + " by " + @author
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
		@book_set.delete(book)
	end
	
	def return(book)
		give_back(book)
	end
	
	def get_books()
		@books_on_loan
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
	
	
	# def find_all_overdue_books()
	
	
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
	
	#find_overdue_books()
	
	#check_in(*book_numbers)  # * = 1..n of book numbers
	
	#search(string)
	
	def check_out(*book_ids)
		#TO DO throw exceptions..
		# lib not open
		# no member currently being served
		# library doesn't have book id
		
		for id in book_ids
			book = @book_collection[id]
			if (book == nil) 
				puts "EH?"
			end
			book.check_out(@calendar.get_date() + 7)
			@member_being_served.check_out(book)
			@book_collection.delete(id)
		end
		
		book_ids.size.to_s + " books have been successfully checked out to " + @member_being_served.get_name()
	end
	

 
 end	