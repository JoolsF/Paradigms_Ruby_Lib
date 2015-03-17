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
	Calender - track time as an int not using Time class
	Books  - contains book info and due date
	Member - is a customer of the library
			 must have lib card to check out books
			 max 3 books
	Library - Master class
			  These methods (other than constructor) will be typed in by librarian therefore params must be strings not numbers. 
			  Should all return result (to reassure librarian that actions working)
			  
			  
			  Collection of books from collection.txt stored as Tuples (title,author)
			  Calender obj
			  Empty dictionary of members (key -> val) -= (membername -> Member)
			  Lib open closed boolean flag
			  Current member (one being served)
=end

require 'set'


#CALENDER CLASS
class Calender
	
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
	#@id converted to string has String can't be coerced to Fixnum
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
	
	def getName()
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

end
