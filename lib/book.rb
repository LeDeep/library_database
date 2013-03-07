class Book

  attr_reader :title, :id, :copy_number, :author_id

  def initialize(attributes)
    @author = Author.new(attributes)
    @title = Title.new(attributes)
    @copy_number = attributes['copy_number'].to_i
    @id = attributes['id'].to_i
    @author_id = attributes['author_id']
  end

  def save
    @id = (DB.exec("INSERT INTO books (title, copy_number) 
      VALUES ('#{@title.title}', '#{@copy_number}')RETURNING id;").map {|result| result['id']}).first
  end 

  def self.set_author_id(author_id, book_id)
    @author_id = DB.exec("UPDATE books SET author_id = #{author_id} WHERE id = #{book_id} RETURNING author_id;")
    #results.inject([]) {|books, book_hash| books << Book.new(book_hash)}
  end


  def self.search_by_title(title)
    results = DB.exec("SELECT * FROM books WHERE title = '#{title}'")
    results.inject([]) {|books, book_hash| books << Book.new(book_hash)}
  end

  def ==(other)
    if other.class != self.class
      false
    else
      self.id == other.id && self.title.title == other.title.title && self.copy_number == other.copy_number
    end
  end

  def to_s
    "#{@title.title} " + "Copy number is: " + "#{@copy_number}"
  end

end
