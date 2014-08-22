require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key.to_s} = ?"}.join(" AND ")
    args = params.values
        
    results = DBConnection.execute(<<-SQL, *args)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    
    self.parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
