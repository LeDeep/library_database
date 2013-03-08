require 'spec_helper'

describe Author do 
  context '#initialize' do 
    it 'creates an instance of Author and initializes authors first and last name' do 
      author = Author.new({'first_name' => 'Franz', 'last_name' => 'Kafka'})
      author.should be_an_instance_of Author
    end
  end


  context '#author_full_name' do 
    it 'returns the full name of the author' do
      author = Author.new({'first_name' => 'Harper', 'last_name' => 'Lee'})
      author.author_full_name.should eq "Harper Lee"
    end
  end

  context '#id' do
    it 'returns the author id' do
      author = Author.new({'first_name' => 'Harper', 'last_name' => 'Lee'})
      author.id.should_not be_nil
    end
  end

  context '#save' do
    it 'saves the author to the database' do
      author = Author.new({'first_name' => 'Harper', 'last_name' => 'Lee'})
      author.save
      author.id.should_not be_nil
    end
  end

  context '#search_by_first' do
    it 'searches for authors with first_name that matches argument' do
      author = Author.new({'first_name' => 'Johnny', 'last_name' => 'Lee'})
      author.save
      Author.search_by_first('Johnny')[0].should eq author
    end
  end

  context '#search_by_last' do
    it 'searches for authors with last_name that matches argument' do
      author = Author.new({'first_name' => 'Steve', 'last_name' => 'Smith'})
      author.save
      Author.search_by_last('Smith')[0].should eq author
    end
  end

   context '#==' do 
    it 'should say the two objects are equal if their contact_id and email are equal' do 
      author1 = Author.new({'first_name' => 'Harper', 'last_name' => 'Lee'})
      author2 = Author.new({'first_name' => 'Harper', 'last_name' => 'Lee'})
      author1.should eq author2
    end
  end

  context'#search_by_id' do 
    it 'gets the author for a specific book' do 
      book = Book.new({'title' => 'Scarlett Letter'})
      book.save
      author = Author.new('first_name' => 'Nathanial', 'last_name' => 'Hawthorne')
      author.save
      book.update_author_id(author.id)
      Author.search_by_id(author.id).first.first_name.should eq author.first_name
    end
  end

    context '#edit_author' do 
    it 'edits the author of the book' do 
      author = Author.new('first_name' => 'Nathanial', 'last_name' => 'Hawthorne')
      author.save
      Author.edit_author(author.id, 'Nathaniel', 'Hawthorne')
      Author.search_by_id(author.id).first.first_name.should eq 'Nathaniel'
    end
  end

end