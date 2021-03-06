require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'
require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable

  def self.columns
    return @columns if @columns

    cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    @columns = cols.first.map(&:to_sym)
  end


  def self.finalize!
    self.columns.each do |column|

      define_method(column) do
        attributes[column]
      end

      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end


  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end


  def self.all
    all_from_table = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    parse_all(all_from_table)
  end


  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end


  def self.find(id)
    found = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = ?
    SQL

    parse_all(found).first
  end


  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym

      if !self.class.columns.include?(attr_name)
        raise 'unknown attribute "#{attr_name}"'
      else
        self.send("#{attr_name}=", value)
      end
    end
  end


  def attributes
    @attributes ||= {}
  end


  def attribute_values
    self.class.columns.map { |attr_name| self.send(attr_name) }
  end


  def insert
    col_names = self.class.columns.join(", ")
    question_marks = (["?"] * self.class.columns.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.send("id=", DBConnection.last_insert_row_id)
  end


  def update
    set = self.class.columns.map { |c| "#{c} = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set}
      WHERE
        #{self.class.table_name}.id = ?
    SQL
  end


  def save
    id.nil? ? insert : update
  end
end
