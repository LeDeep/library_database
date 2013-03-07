require 'spec_helper'

describe Title do 
  context '#initialize' do 
    it 'creates an instance of Title and initializes the title of the book' do 
      title = Title.new({'title' => 'Metamorphasis'})
      title.should be_an_instance_of Title
    end
  end

   context '#title' do 
    it 'returns the title of the book' do
      title = Title.new({'title' => 'To Kill a Mockingbird'})
      title.title.should eq "To Kill a Mockingbird"
    end
  end

end