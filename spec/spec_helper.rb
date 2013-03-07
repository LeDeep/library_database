require 'rspec'
require 'pg'
require 'book'
require 'author'
require 'title'

DB = PG.connect(:dbname => 'catalog_test', :host => 'localhost')


RSpec.configure do |config|
  config.after(:all) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
  end
end