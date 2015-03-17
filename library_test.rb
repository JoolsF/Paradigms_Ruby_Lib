require_relative 'library.rb'


#puts Calendar.instance
#puts Calendar.instance.get_date()




b = Book.new(123, "The Road", "Cormac McCarthy")
#b.check_out(5)
#puts b.get_due_date()
#b.check_in
#puts b.get_due_date()



#m = Member.new(1,2)
#puts m.get_books.length
#m.check_out(b)
#puts m.get_books.length


#puts Library.instance

puts lib = Library.instance
	
puts lib.issue_card("Julian Fenner")
puts lib.issue_card("Julian Fenner")
puts lib.serve("Julian Fenner")

#puts lib.get_member("Julian Fenner")

#puts l.open()