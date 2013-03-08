require 'spec_helper'

describe Book do 
  context '#initialize' do 
    it 'creates an instance of Book and initializes title, author, copy number' do
      title = Title.new({'title' => 'To Kill A Mockingbird'})
      book = Book.new({'title' => title, 'author_first_name' => 'Harper', 'author_last_name' => 'Lee', 'copy_number' => '1'})
      book.should be_an_instance_of Book
    end
  end



  context '#copy_number' do 
    it 'returns the copy_number of the book' do
      book = Book.new({'copy_number' => '1'})
      book.copy_number.should eq 1
    end
  end


  context '#save' do
    it 'saves the book and sets the book id to the database id' do
      title = Title.new({'title' => 'To Kill A Mockingbird'})
      book = Book.new({'title' => title, 'author_first_name' => 'Harper', 'author_last_name' => 'Lee', 'copy_number' => '1'})
      book.save
      book.id.should_not be_nil
    end
  end

  context '#search_by_title' do
    it 'searches for book title that matches argument' do
      title = Title.new({'title' => 'Catcher In The rye'})
      book = Book.new({'title' => title})
      book.save
      Book.search_by_title('Catcher In The Rye')[0].title.title.should eq 'Catcher In The Rye'

      book_title = 'Catcher in the Rye'
      book_title_caps = book_title.split.map {|word| word.capitalize}.join(" ")
      Book.search_by_title(book_title_caps)[0].title.title.should eq 'Catcher In The Rye'

      book_title = 'catcher'
      book_title_caps = book_title.split.map {|word| word.capitalize}.join(" ")
      Book.search_by_title(book_title_caps)[0].title.title.should eq 'Catcher In The Rye'

    end

    it 'changes the title to title case'

    it 'searches for a partial title'
  end

  context '#search_by_author' do
    it 'searches for books that match argument' do
      title = Title.new({'title' => 'Catcher In The rye'})
      book = Book.new({'title' => title})
      book.save
      author = Author.new('first_name' => 'Ken', 'last_name' => 'Follett')
      author.save
      book.update_author_id(author.id)
      Book.search_by_author(author.id)[0].title.title.should eq 'Catcher In The Rye'
    end
  end



   context '#==' do 
    it 'should say the two objects are equal if their title and copy_number are equal' do 
      title = Title.new({'title' => 'Catcher In The rye'})
      book1 = Book.new({'title' => title, 'copy_number' => '2'})
      book2 = Book.new({'title' => title, 'copy_number' => '2'})
      book1.should eq book2
    end
  end

  # context '#to_s' do 
  #   it 'should print the results of a search by title' do 
  #     book = Book.new({'title' => 'Tropic of Cancer', 'author_first_name' => 'Henry', 'author_last_name' => 'Miller', 'copy_number' => '1'})
  #     book.save
  #     Book.search_by_title('Tropic of Cancer').first.to_s.should eq "Tropic of Cancer Copy number is: 1"
  #   end
  # end

    context'#update_author_id' do 
      it 'sets the author id in the book record' do 
      title = Title.new({'title' => 'Catcher In The rye'})
        book = Book.new({'title' => title})
        book.save
        author = Author.new('first_name' => 'Ken', 'last_name' => 'Follett')
        author.save
        book.update_author_id(author.id)
        # Book.set_author_id(author.id, book.id).first.should eq({'author_id' => "#{author.id}"})
      end
    end
  
  context '#search_by_id' do
    it 'searches for books that match argument' do
      title = Title.new({'title' => 'Catcher in the rye'})
      book = Book.new({'title' => title})
      book.save
      Book.search_by_id(book.id)[0].title.should eq title
    end
  end

  context '#delete_by_id' do
    it 'searches for books that match argument' do
      title = Title.new({'title' => 'Catcher In The rye'})
      book = Book.new({'title' => title})
      book.save
      expect {book.delete}.to change {Book.all.length}.by 1
      # Book.delete_by_id(book.id).count.should eq 0
    end
  end

  context '#edit_title' do 
    it 'edits the title of the book' do 
      title = Title.new({'title' => 'Catcher In The rye'})
      book = Book.new({'title' => title, 'copy_number' => '1'})
      book.save
      book.edit_title('Catcher')
      Book.search_by_id(book.id)[0].title.title.should eq 'Catcher'
    end
  end


end









