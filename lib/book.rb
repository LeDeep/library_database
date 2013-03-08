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

  def update_author_id(author_id)
    @author_id = DB.exec("UPDATE books SET author_id = #{author_id} WHERE id = #{@id} RETURNING author_id;")
  end

  def self.edit_title(book_id, title)
    Book.from_pg_result(DB.exec("UPDATE books SET title = '#{title}' WHERE id = '#{book_id}';"))
  end

  def self.all
    Book.from_pg_result(DB.exec("SELECT * FROM books"))
  end

  def self.search_by_title(title)
    Book.from_pg_result(DB.exec("SELECT * FROM books WHERE title like '%#{title}%'"))
    
  end

  def self.search_by_author(author_id)
    Book.from_pg_result(DB.exec("SELECT * FROM books WHERE author_id = '#{author_id}'"))
    
  end

  def self.search_by_id(book_id)
    Book.from_pg_result(DB.exec("SELECT * FROM books WHERE id = '#{book_id}'"))
    
  end

  def self.delete_by_id(book_id)
    results = DB.exec("DELETE FROM books WHERE id = '#{book_id}'")
  end

  def ==(other)
    if other.class != self.class
      false
    else
      self.id == other.id && self.title.title == other.title.title && self.copy_number == other.copy_number
    end
  end

  # def to_s
  #   "#{@title.title} " + "Copy number is: " + "#{@copy_number}"
  # end

  def self.get_author(author_id)
    results = DB.exec("SELECT * FROM authors WHERE id = #{author_id}")
    results.inject([]) {|authors, author_hash| authors << Author.new(author_hash)}
  end

  private

  def self.from_pg_result(pg_result)
    pg_result.inject([]) {|books, book_hash| books << Book.new(book_hash)}
  end


end
