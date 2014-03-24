# s_arb

require 'pry'
require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.logger = Logger.new $stdout
ActiveSupport::LogSubscriber.colorize_logging = false

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :evil_henchmen do |t|
    t.string :name
    t.boolean :eyepatch
    t.string :title
    t.integer :overlord_id
  end

  create_table :evil_scheme_assignments do |t|
    t.integer :evil_scheme_id
    t.integer :evil_henchmen_id
  end

  create_table :evil_schemes do |t|
    t.string :codename
    t.string :description
    t.integer :evil_henchmen_id
  end
end

class EvilHenchmen < ActiveRecord::Base
  has_many :masterminded_schemes, class_name: "EvilScheme"

  belongs_to :overlord, class_name: "EvilHenchmen"
  has_many :minions, class_name: "EvilHenchmen", foreign_key: :overlord_id

  has_many :evil_scheme_assignments
  has_many :evil_campaigns, through: :evil_scheme_assignments, source: :evil_scheme
end

class EvilSchemeAssignment < ActiveRecord::Base
  belongs_to :evil_henchmen
  belongs_to :evil_scheme
end

class EvilScheme < ActiveRecord::Base
  belongs_to :mastermind, class_name: "EvilHenchmen", foreign_key: :evil_henchmen_id

  has_many :evil_scheme_assignments
  has_many :evil_henchmen, through: :evil_scheme_assignments
end

sauron = EvilHenchmen.create! name: 'Sauron', title: "Dark Lord", eyepatch: true
nazgul = EvilHenchmen.create!(name: "Witch-king of Angmar", title: "Lord of the Nazgûl")
uruk = EvilHenchmen.create!(name: "Uglúk", title: "Captain of the Uruk-hai")
sauron.minions << nazgul << uruk

cover_the_land_in_darkness = EvilScheme.create!(codename: "sunshine", description: "Burn Middle-earth!")
bind_them = EvilScheme.create!(codename: "hamburgers", description: "Give them all rings.")

sauron.masterminded_schemes << cover_the_land_in_darkness << bind_them

# The association works both ways, same sql
uruk.evil_campaigns << cover_the_land_in_darkness
cover_the_land_in_darkness.evil_henchmen << nazgul

# Things to try in console:
#
# sauron.masterminded_schemes
# cover_the_land_in_darkness.evil_henchmen
# sauron.minions
# EvilScheme.all.map(&:mastermind)

binding.pry