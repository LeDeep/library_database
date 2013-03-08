class Author

  attr_reader :id, :first_name, :last_name

  def initialize(attributes)
    @last_name = attributes['last_name']
    @first_name = attributes['first_name']
    @id = attributes['id'].to_i
  end

  def author_full_name
    "#{@first_name} #{@last_name}"
  end 

  def save
    first_name = @first_name.split.map {|first| first.capitalize}.join(" ")
    last_name = @last_name.split.map {|last| last.capitalize}.join(" ")
    @id = (DB.exec("INSERT INTO authors (first_name, last_name) 
      VALUES ('#{first_name}', '#{last_name}')RETURNING id;").map {|result| result['id']})[0].to_i
  end 

  def self.search_by_first(first_name)
    results = DB.exec("SELECT * FROM authors WHERE first_name like '%#{first_name}%'")
    results.inject([]) {|authors, author_hash| authors << Author.new(author_hash)}
  end

  def self.search_by_last(last_name)
    results = DB.exec("SELECT * FROM authors WHERE last_name like '%#{last_name}%'")
    results.inject([]) {|authors, author_hash| authors << Author.new(author_hash)}
  end

  def self.search_by_id(author_id)
    results = DB.exec("SELECT * FROM authors WHERE id = '#{author_id}'")
    results.inject([]) {|authors, author_hash| authors << Author.new(author_hash)}
  end

  def self.edit_author(author_id, first_name, last_name)
    DB.exec("UPDATE authors SET first_name = '#{first_name}', last_name = '#{last_name}' WHERE id = '#{author_id}';").inject([]) {|books, book_hash| books << Book.new(book_hash)}
  end

   def ==(other)
    if other.class != self.class
      false
    else
      self.id == other.id && self.first_name == other.first_name && self.last_name == other.last_name
    end
  end

end