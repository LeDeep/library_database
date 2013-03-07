require 'pg'
require './lib/book'
require './lib/author'
require './lib/title'

DB = PG.connect(:dbname => 'catalog', :host => 'localhost')

def welcome
  puts "Welcome to the Public Library."
  main_menu
end

def main_menu
  choice = nil
  until choice == 'x'
    puts "Press 'x' to exit catalog."
    puts "Press 'a' to add a new item. to the catalog."
    # puts "Press 'l' to list the names of all contacts in your address book."
    puts "Press 's' to search for existing items(s) to view/edit/delete."
    choice = gets.chomp
    case choice
      when 'a'
        add_item
      # when 'l'
      #   list_all_contact_names
      when 's'
        search
        action_menu
      when 'x'
        exit
      else
        puts "Invalid choice; try again!"
      end
  end
end

def add_item
  print "Enter the title of the new item:  "
  title = gets.chomp
  print "Here is a list of books with that title: " 
  p Book.search_by_title(title)
  print "Do you want to create a new item (y/n)?  "
  if gets.chomp  == 'y'
    print "Enter the copy number of the new item:  "
    copy_number = gets.chomp  
    book = Book.new({'title' => title, 'copy_number' => copy_number})
  # deconfliction needed
    book.save
    puts "'#{book.title.title}', copy: #{book.copy_number} has been added to your catalog."
    print "Add more info (y/n):  "
    if gets.chomp == 'y'
      add_item_menu(book.id)
    end
  end
end

def add_author(book_id)
  print "Enter the first name of the author of the new item:  "
  first_name = gets.chomp
  print "Enter the last name of the author of the new item:  "
  last_name = gets.chomp
  author = Author.new({'first_name' => first_name, 'last_name' => last_name})
# deconfliction needed
  author.save
  Book.set_author_id(author.id, book_id)
  puts "'#{author.first_name} #{author.last_name}', has been added to your book."
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
  case option
    when 'f'
      puts "Enter the first name:"
      first_name = gets.chomp
      Author.search_by_first(first_name)
    when 'l'
      puts "Enter the last name:"
      last_name = gets.chomp
      Author.search_by_last(last_name)
    when 't'
      puts "Enter the book title:"
      book_title = gets.chomp
      Title.search_by_title(book_title)
    else
      puts "Invalid option, try again!"
    end
end

def action_menu
  choice = nil
  until choice == 'b'
    puts "Press 'b' to go back to the main menu."
    print "Use ID to select which item to work with:  "
    contact_id = gets.chomp.to_i
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
  end
end


welcome
