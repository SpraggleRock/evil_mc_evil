# if you have seeing_is_believing installed, s_arb is a tab trigger to get
# an in-memory database
# s_arb[TAB]

require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.logger = Logger.new $stdout
ActiveSupport::LogSubscriber.colorize_logging = false

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users do |t|
    t.string :name
  end

  create_table :posts do |t|
    t.string :name
    t.integer :user_id
  end
end

class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end

user = User.create! name: 'Josh'
user.posts = [Post.new(name: 'yo ho ho'), Post.new(name: 'and a bottle of rum')]
