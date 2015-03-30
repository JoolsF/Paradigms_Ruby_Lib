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
puts lib.issue_card("Linda Florence")

puts lib.serve("Julian Fenner")
puts lib.check_out(1,2,3)

puts lib.check_in(1,2)

puts lib.serve("Linda Florence")
puts lib.check_out(1,2)

puts lib.search('kill')

x = "jools"
y = "linda"
z = "jools"

a = [x,y]

puts a.include? (z)


#(0..7).each do |i|
#	lib.open
#	lib.close
#end

#puts lib.find_all_overdue_books

#puts lib.find_overdue_books

#puts lib.get_member("Julian Fenner")

#puts l.open()