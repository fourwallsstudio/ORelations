require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    param_cols = params
      .map { |attr_name, _| "#{attr_name} = ?" }.join(" AND ")

    result = DBConnection.execute2(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{param_cols}
    SQL

    parse_all(result.drop(1))
  end
end
