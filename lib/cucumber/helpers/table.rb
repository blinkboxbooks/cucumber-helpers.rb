require "active_support/inflector"

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
  #   If provided this defines value of the attribute, cast according to the `type` specified. If
  #   not provided the value of the corresponding hash key will be the class constant of the `type`
  #   specified, or an array containing the class constant in the case of a 'List of' type.
  #
  # type::
  #   The type of the attribute. This is used both as documentation of the type of the attribute
  #   which is useful in itself, but also to control how the parameter is formatted in the JSON.
  #   As well as built-in types, you can use the special type "Enum" which will represent the value
  #   as a string, but convert it to the appropriate case, e.g. a value of "Sales Rank" will be
  #   formatted as "SALES_RANK" inkeeping with enumeration conventions.
  #
  #   If the `type` is given as "List of <Type>", the `value` is assumed to be a comma delimited
  #   list of items of the "<Type>" specified and is emitted as an array of typecast objects.
  #   White space either side of commas is stripped.
  #
  # Any other columns in the table will be ignored, so you can have other columns in the table for
  # different purposes, e.g. "description" is a fairly useful column purely for documentation.
  def attribute_hash(casing: :camel_case)
    class_only = !raw.first.include?('value')
    hashes.each_with_object({}) do |row, hash|
      name = row["attribute"].gsub(/: /, ".").send(casing)
      hash.deep_set(name, value_from_row(row, class_only))
    end
  end

  private

  def value_from_row(row, class_only)
    list_of = row["type"].match(/^List of (?<type>.*)$/)
    type = (list_of ? list_of[:type].singularize : row["type"]).constantize

    return type if class_only

    if list_of
      row["value"].split(/\s*,\s*/).collect do |subvalue|
        subvalue.to_type(type)
      end
    else
      row["value"].to_type(type)
    end
  end
end