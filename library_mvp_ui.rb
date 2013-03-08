require 'pg'
require './lib/book'
require './lib/author'
require './lib/title'

DB = PG.connect(:dbname => 'catalog', :host => 'localhost')

# def clear
#     DB.exec("DELETE FROM books *;")
#     DB.exec("DELETE FROM authors *;")
  
# end

def welcome
  #clear
  puts "Welcome to the Public Library."
  main_menu
end

def main_menu
  choice = nil
  until choice == 'x'
    puts "Press 'x' to exit catalog."
    puts "Press 'a' to add a new item. to the catalog."
    puts "Press 's' to search for existing items(s) to view/edit/delete."
    choice = gets.chomp
    case choice
      when 'a'
        add_item
      when 's'
        books = search
        if books != [] && books.first != []
          action_menu(books) 
        else
          puts "No records with that criteria; try again!"
        end
      when 'x'
        exit
      else
        puts "Invalid choice; try again!"
      end
  end
end

def add_item
  print "Enter the title of the new item:  "
  book_title = gets.chomp
  book_title_caps = book_title.split.map {|word| word.capitalize}.join(" ")
  books = Book.search_by_title(book_title_caps)
  if books.count != 0
    puts "Here is a list of books with that title: " 
    books = Book.search_by_title(book_title_caps)
    books.each {|book| puts "#{book.title.title}, copy #{book.copy_number}"} 
    print "Do you want to create a new entry for this title (y/n)?  "
    if gets.chomp  == 'n' then return end
  end

  print "Enter the copy number of the new item:  "
  copy_number = gets.chomp  
  book = Book.new({'title' => book_title, 'copy_number' => copy_number})
# deconfliction needed
  book.save
  puts "'#{book.title.title}', copy: #{book.copy_number} has been added to your catalog."
  print "Add more info (y/n):  "
  if gets.chomp == 'y'
    add_item_menu(book.id)
  end
end

def add_author(book_id)
  print "Enter the first name of the author of the item:  "
  first_name = gets.chomp
  print "Enter the last name of the author of the item:  "
  last_name = gets.chomp
  author = Author.new({'first_name' => first_name, 'last_name' => last_name})
# deconfliction needed
  author.save
  Book.set_author_id(author.id, book_id)
  puts "'#{author.first_name} #{author.last_name}', has been added to your catalog."
end

def add_item_menu(book_id)
  choice = nil
  until choice == 'b'
    puts "Press 'b' to go back to the main menu."
    puts "Press 'a' to add the author."
    puts "Press 'v' to view a book and its information."
    choice = gets.chomp
    case choice
       when 'a'
        add_author(book_id)
       when 'v'
        view_item(book_id)
       when 'b'
        return
       else
        puts "Invalid option, try again!"
      end
  end
end

def search
  puts "Enter the key for the search option you wish to use:"
  puts "KEY     OPTION"
  puts " f      author first name"
  puts " l      author last name"
  puts " t      book title"
  option = gets.chomp
  books = []
  case option
    when 'f'
      puts "Enter the first name:"
      first_name = gets.chomp
      first_name_caps = first_name.split.map {|first| first.capitalize}.join(" ")
      authors = Author.search_by_first(first_name_caps)
      authors.each do |author| 
        book_list = Book.search_by_author(author.id)
        books += book_list
      end
      books
    when 'l'
      puts "Enter the last name:"
      last_name = gets.chomp
      last_name_caps = last_name.split.map {|last| last.capitalize}.join(" ")
      authors = Author.search_by_last(last_name_caps)
      authors.each do |author| 
        book_list = Book.search_by_author(author.id)
        books += book_list
      end      
      books
    when 't'
      puts "Enter the book title:"
      book_title = gets.chomp
      book_title_caps = book_title.split.map {|word| word.capitalize}.join(" ")
      Book.search_by_title(book_title_caps)
    else
      puts "Invalid option, try again!"
    end
end

def view_item(book_id)
  books = Book.search_by_id(book_id)
  if books.count == 0
    puts "There are no books matching that ID. Please try again."
  else
    puts "Here the information for that item: " 
    books.each do |book| 
      puts "Title: #{book.title.title}"
      puts "Copy: #{book.copy_number}"
      puts "ID: #{book.id}"
      if book.author_id != nil
        puts "Author: #{Author.search_by_id(book.author_id.to_i).first.author_full_name}"
      else
        puts "Author: no information found"
      end
    end
  end
end

def delete_item(book_id)
  books = Book.delete_by_id(book_id)
end


def edit_title(book_id)
  print "Change the title to:  "
  book_title = gets.chomp  
  book_title_caps = book_title.split.map {|word| word.capitalize}.join(" ")
  Book.edit_title(book_id, book_title_caps)
  books = Book.search_by_id(book_id)
  print "Your changed record:  "
  books.each { |book| puts "#{book.title.title} copy #{book.copy_number}" }
end


def edit_author(book_id)
  book = Book.search_by_id(book_id)
  author_id = book[0].author_id
  puts "Author's name: #{Author.search_by_id(author_id.to_i).first.author_full_name}"
  books = Book.search_by_author(author_id)
  puts "Here is a list of books that will be affected by this change: " 
  books.each { |book| puts "#{book.id}  #{book.title.title} copy #{book.copy_number}"}
  puts "Do you want to change them all (y/n)?"
  if gets.chomp == 'y'
    print "Change first name to:  "
    first_name = gets.chomp
    print "Change last name to:  "
    last_name = gets.chomp
    Author.edit_author(author_id, first_name, last_name)
  else
    add_author(book_id)
  end
    puts "Changes made!"
end



def action_menu(books)
  p books
  puts "Here is a list of books with that criteria: " 
  puts "Book ID\tAuthor Name\t\tBook Title\t\t\tCopy Number"
  books.each do |book| 
    if book.author_id != nil
      puts "  #{book.id}\t#{Author.search_by_id(book.author_id.to_i).first.author_full_name}\t\t\t#{book.title.title}\t\t\t\t\t#{book.copy_number}" 
    else
      puts "#{book.title.title} copy #{book.copy_number}"
    end
  end
  choice = nil
  until choice == 'b'
    print "Use ID to select which item to work with:  "
    book_id = gets.chomp.to_i
    puts "Press 'b' to go back to the main menu."
    puts "Press 'd' to delete the item and its info."
    puts "Press 'v' to view the item and its info."
    puts "Press 't' to edit the item's title."
    puts "Press 'a' to edit the item's author."
    #puts "Press 'e' to add the item's genre."
    choice = gets.chomp
    case choice
      when 'd'
        delete_item(book_id)
      when 't'
        edit_title(book_id)
      when 'a'
        edit_author(book_id)
      when 'v'
        view_item(book_id)
      when 'b'
        return
      else
        invalid
      end
    return
  end
end


welcome
