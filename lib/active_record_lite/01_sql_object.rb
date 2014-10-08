require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    cols = DBConnection::execute2(<<-SQL)
      SELECT * FROM #{self.table_name}
    SQL
    
    cols.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col|
      define_method("#{col}=") { |value| attributes[col] = value }
      define_method("#{col}") { attributes[col] }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.inspect.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |options| self.new(options) }
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{self.table_name}.id = ?
      LIMIT
        1
    SQL
    self.new(result.first)
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    columns = self.class.columns
    
    col_names = columns.map(&:to_s).join(", ")
    question_marks = (["?"] * columns.count).join(", ")
    
    result = DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    
    self.id = DBConnection.last_insert_row_id
  end

  def initialize(options = {})
    options.each do |attr_name, attr_value|
      col = attr_name.to_sym
      
      unless self.class.columns.include?(col)
        raise "unknown attribute '#{col}'"
      end

      self.send("#{col}=", attr_value)
    end
  end

  def save
    self.id.nil? ? self.insert : self.update
  end

  def update
    set_values = self.class.columns.map { |col| "#{col} = ?"}.join(", ")
    
    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_values}
      WHERE
        id = ?
    SQL
    
  end

  def attribute_values
    self.class.columns.map { |col| self.send(col) }
  end
end
