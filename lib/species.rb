require_relative 'sql_object'

class Species < SQLObject
  belongs_to :genus
  has_one_through :family, :genus, :family

  finalize!
end


class Genus < SQLObject
  belongs_to :family
  has_many :species

  finalize!
end


class Family < SQLObject
  has_many :genus

  finalize!
end
