require_relative 'library.rb'
require 'test/unit'
class Test_Library < Test::Unit::TestCase

	def setup
		@library = Library.instance
	end

	def teardown
		Library.reset
		Calendar.reset
	end
	
	
	def test_intialize
		#13 books loaded from data file so next id should be 14
		assert @library.nextid == 14
		#date starts at 0
		assert @library.calendar.get_date() == 0
	end
	
	
	def test_open
		assert @library.libraryopen == false
		
		@library.open()
		assert @library.libraryopen == true
		assert @library.calendar.get_date() == 1

		exception = assert_raise(Exception) {
			@library.open()
		}	
		assert exception.message == "The library is already open!"
	end	
	
	def test_find_all_overdue_books
		@library.issue_card("Jools")
		@library.serve("Jools")
		@library.check_out(1)
		(0..7).each do |i|
			@library.open()
			@library.close()
		end
		
		str = @library.find_all_overdue_books()
		# To do, need to check str output
		#assert str == ??
		assert 1 == 1
	end
	
	def test_issue_card
		@library.issue_card("Jools")
		str = @library.issue_card("Jools")
		assert str == "Jools already has a library card"
	end

	def test_serve
		str1 =  @library.serve("Jools")
		assert str1 == "Jools does not have a library card."
		
		@library.issue_card("Jools")
		str2 = @library.serve("Jools")
		assert str2 == "Now serving Jools"
		
		@library.issue_card("Linda")
		str3 = @library.serve("Linda")
		assert str3 == "Now serving Linda"
	end
	
	def test_find_overdue_books
		exception = assert_raise(Exception) {
			@library.find_overdue_books
		}	
		assert exception.message == "No member is currently being served."
	end
	
	def test_check_in
		@library.issue_card("Jools")
		@library.serve("Jools")
		
		exception = assert_raise(Exception) {
			@library.check_in(1)
		}
		assert exception.message ==  "member doesnt have book id:1"
		
		@library.check_out(1,2,3,4)
		str = @library.check_in(1,2,3,4)
		assert str == "Jools has returned 4 books"
	end
	
	def test_search
		str = @library.search('Kill')
		assert str == "11: To Kill a Mockingbird by Harper Lee"
		
		str = @library.search('A')
		assert str == "Search string must contain at least four characters."
		
		str = @library.search('XXXX')
		assert str == "No books found."
	end
	
	def test_check_out
		@library.issue_card("Jools")
		@library.serve("Jools")
		
		str = @library.check_out(1,2,3,4)
		assert str == "4 books have been successfully checked out to Jools"
		
		exception = assert_raise(Exception) {
			@library.check_out(9999)
		}
		
		assert exception.message ==  "The library does not have book 9999"
	end
	
	def test_renew
		@library.issue_card("Jools")
		@library.serve("Jools")
		exception = assert_raise(Exception) {
			@library.renew(1)
		}		
		
		assert exception.message == "The member doesnt have book id: 1"
		
		@library.check_out(1,2,3)
		str = @library.renew(1,2)
		
		assert str == "2 books have been renewed for Jools"
		
	end
	
	def test_close
		@library.open()
		str = @library.close()
		assert str == "Good Night"
		exception = assert_raise(Exception) {
			@library.close()
		}
		
		assert exception.message == "The library is not open!"
	end
	
end