class Title


  attr_reader :title

  def initialize(attributes)
    @title = attributes['title'].split.map {|word| word.capitalize}.join(" ")
  end
  
  def ==(other)
    if other.class != self.class
      false
    else
      self.title == other.title
    end
  end


end