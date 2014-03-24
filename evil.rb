# if you have seeing_is_believing installed, s_arb is a tab trigger to get
# an in-memory database
# s_arb[TAB]

require "pry";
require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.logger = Logger.new $stdout
ActiveSupport::LogSubscriber.colorize_logging = false

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :evil_henchmen do |t|
    t.string :name
    t.string :title
  end

end

class EvilHenchmen < ActiveRecord::Base

end

sauron = EvilHenchmen.create! name: "Sauron", title: "Dark Lord"

binding.pry