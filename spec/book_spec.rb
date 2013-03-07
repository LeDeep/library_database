require 'spec_helper'

describe Book do 
  context '#initialize' do 
    it 'creates an instance of Book and initializes title, author, copy number' do
      book = Book.new({'title' => 'To Kill a Mockingbird', 'author_first_name' => 'Harper', 'author_last_name' => 'Lee', 'copy_number' => '1'})
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
    it 'saves the book to the database' do
      book = Book.new({'title' => 'To Kill a Mockingbird', 'author_first_name' => 'Harper', 'author_last_name' => 'Lee', 'copy_number' => '1'})
      book.save
      book.id.should_not be_nil
    end
  end

    context '#search_by_title' do
    it 'searches for book title that matches argument' do
      book = Book.new({'title' => 'Catcher in the Rye'})
      book.save
      Book.search_by_title('Catcher in the Rye')[0].title.title.should eq book.title.title
    end
  end

   context '#==' do 
    it 'should say the two objects are equal if their title and copy_number are equal' do 
      book1 = Book.new({'title' => 'Catcher in the Rye', 'copy_number' => '2'})
      book2 = Book.new({'title' => 'Catcher in the Rye', 'copy_number' => '2'})
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

    context '#set_author_id' do 
      it 'sets the author id to match the book id' do 
        book = Book.new({'title' => 'Catcher in the Rye'})
        p book.save
        author = Author.new('first_name' => 'Ken', 'last_name' => 'Follett')
        p author.save
        Book.set_author_id(author.id, book.id).first.author_id.should eq author.id
      end

    end

end