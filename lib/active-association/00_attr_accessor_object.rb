# Automatically generates a getter and setter methods for instance variables defined in by AttrAccessor
class AttrAccessorObject
  def self.lite_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}".to_sym) do
        instance_variable_get("@#{name}")
      end
      
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end