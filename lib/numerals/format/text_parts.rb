
# Numeral parts represented in text form
class TextParts

 def self.text_part(*names)
   names.each do |name|
     attr_writer name.to_sym
     define_method name do
       instance_variable_get("@#{name}") || ""
     end
     define_method :"#{name}?" do
       !send(name.to_sym).empty?
     end
   end
 end

 def initialize
   @special = nil
   @sign = @integer = @fractional = @repeat = @exponent = @exponent_base = nil
   @integer_value = @exponent_value = @exponent_base_value = nil
 end

 text_part :special
 text_part :sign, :integer, :fractional, :repeat, :exponent, :exponent_base

 attr_accessor :integer_value, :exponent_value, :exponent_base_value

end