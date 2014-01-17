class Cucumber::Ast::Table
  # Converts a table of attributes to a hash.
  #
  # The table must have the following columns:
  #  
  # attribute::
  #   The name of the attribute. You can use natural language here and the parameter name will be
  #   inferred, for example "Cardholder Name" will be converted to "cardholderName". You can also
  #   specify nested objects using a `:` separator, for example "Address: Line 1" will be converted 
  #   to an attribute like `{ "address": { "line1": ... } }`.
  #
  # value::
  #   The value of the attribute, which will be interpreted according to the specified type.
  #
  # type::
  #   The type of the attribute. This is used both as documentation of the type of the attribute
  #   which is useful in itself, but also to control how the parameter is formatted in the JSON.
  #   As well as built-in types, you can use the special type "Enum" which will represent the value
  #   as a string, but convert it to the appropriate case, e.g. a value of "Sales Rank" will be
  #   formatted as "SALES_RANK" inkeeping with enumeration conventions.
  #
  # Any other columns in the table will be ignored, so you can have other columns in the table for
  # different purposes, e.g. "description" is a fairly useful column purely for documentation.
  def attribute_hash(casing: :camel_case)
    hashes.each_with_object({}) do |row, hash|
      name = row["attribute"].gsub(/: /, ".").send(casing)
      value = row["value"].to_type(row["type"].constantize)
      hash.deep_set(name, value)
    end
  end
end