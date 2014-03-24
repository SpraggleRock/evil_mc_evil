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

  create_table :evil_schemes do |t|
    t.string :codename
    t.string :description
    t.integer :evil_henchmen_id
  end

end

class EvilHenchmen < ActiveRecord::Base
  has_many :evil_schemes
end

class EvilScheme < ActiveRecord::Base
end

sauron = EvilHenchmen.create! name: "Sauron", title: "Dark Lord"
sauron.evil_schemes << EvilScheme.create!(codename: "Palantir", description: "Bind them all")

binding.pry