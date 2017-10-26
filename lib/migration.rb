require './db_connection'

class Migration

  def self.string(name, contraints = {})
    columns << "#{name} VARCHAR(255) #{add_contraints(contraints)}"
  end

  def self.text(name, contraints = {})
    columns << "#{name} TEXT #{add_contraints(contraints)}"
  end

  def self.integer(name, contraints = {})
    columns << "#{name} INTEGER #{add_contraints(contraints)}"
  end

  def self.float(name, contraints = {})
    columns << "#{name} FLOAT #{add_contraints(contraints)}"
  end

  def self.boolean(name, contraints = {})
    columns << "#{name} BOOLEAN #{add_contraints(contraints)}"
  end

  def self.timestamps
    "created_at DATE DEFAULT GETDATE(), updated_at DATE DEFAULT GETDATE()"
  end

  def create_table(table_name)
    yield self if block_given?

    DBConnection.execute(<<-SQL, columns, references, unique_constraints)
      CREATE TABLE #{table_name}(
        id INTEGER PRIMARY_KEY
        #{columns.length > 0 ? (', ' + columns.join(', ')) : ''}
        UNIQUE (id #{unique_constraints.length > 0 ? (', ' + unique_constraints.join(', ')) : ''})
        #{references.length > 0 ? (', ' + references.join(', ')) : ''}
      );
    SQL
  end

  def change_table(table_name)
  end

  def add_column(column_name)
  end

  def remove_column(column_name)
  end

  def add_index(table_name, columns)
  end

  private

    def add_contraints(name, contraints)
      add_foriegn_key(contraints['reference'], name) if contraints['reference']
      add_unique(name) if contraints['unique']

      contraints_list = []
      contraints_list << contraints[:null] == false ? 'NOT NULL' : ''
      contraints_list << contraints[:default] ? "DEFAULT #{contraints[:default]}" : ''
      contraints_list.join(', ')
    end

    def add_foriegn_key(reference, column_name)
      references << "FOREIGN KEY(#{column_name}) REFERENCES #{reference}(id)"
    end

    def add_unique(column_name)
      unique_constraints << column_name
    end

    def unique_constraints
      @unique_constraint ||= []
    end

    def columns
      @columns ||= []
    end

    def references
      @references ||= []
    end
end
