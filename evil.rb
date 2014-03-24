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

  create_table :evil_scheme_realizations do |t|
    t.integer :evil_henchmen_id
    t.integer :evil_scheme_id
  end

end

class EvilHenchmen < ActiveRecord::Base
  has_many :evil_schemes

  has_many :evil_scheme_realizations
  has_many :evil_schemes_realized, through: :evil_scheme_realizations, source: :evil_scheme
end

class EvilSchemeRealization < ActiveRecord::Base
  belongs_to :evil_henchmen
  belongs_to :evil_scheme
end

class EvilScheme < ActiveRecord::Base
  belongs_to :creator, class_name: "EvilHenchmen", foreign_key: "evil_henchmen_id"
end

sauron = EvilHenchmen.create! name: "Sauron", title: "Dark Lord"
scheme = EvilScheme.create!(codename: "Palantir", description: "Bind them all")
sauron.evil_schemes << scheme

minion = EvilHenchmen.create! name: "Nazgûl", title: "Ring Wraith"
minion.evil_schemes_realized << scheme

binding.pry