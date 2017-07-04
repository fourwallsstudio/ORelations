require_relative 'sql_object'

class Species < SQLObject
  belongs_to :genus
  has_one_through :family, :genus, :family

  self.finalize!
end

class Genus < SQLObject
  belongs_to :family
  has_many :species

  self.finalize!
end

class Family < SQLObject
  has_many :genus

  self.finalize!
end
