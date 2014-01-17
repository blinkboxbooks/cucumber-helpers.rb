class Hash
  def deep_key(deep_key)
    sub_obj = self
    deep_key.split('.').each do |k|
      if k.match(/^(.+)\[(\d+)\]$/)
        sub_obj = sub_obj[$1][$2.to_i]
      else
        sub_obj = sub_obj[k]
      end
    end
    sub_obj
  rescue
    nil
  end

  def deep_delete(deep_key)
    path_keys = deep_key.split('.')
    final_key = path_keys.pop

    sub_obj = self
    path_keys.each do |k|
      if k.match(/^(.+)\[(\d+)\]$/)
        sub_obj = sub_obj[$1][$2.to_i]
      else
        sub_obj = sub_obj[k]
      end
    end

    sub_obj.delete(final_key)
  end

  def deep_set(deep_key, value)
    path_keys = deep_key.split('.')
    final_key = path_keys.pop

    sub_obj = self
    path_keys.each do |k|
      if k.match(/^(.+)\[(\d+)\]$/)
        sub_obj = sub_obj[$1][$2.to_i]
      else
        sub_obj[k] ||= {}
        sub_obj = sub_obj[k]
      end
    end

    if final_key.match(/^(.+)\[(\d+)\]$/)
      sub_obj[$1][$2.to_i] = value
    else 
      sub_obj[final_key] = value
    end
  end

  # Collapses any nested hashes, converting the keys to delimited strings.
  #
  # For example, the hash `{ "address" => { "line1" => ..., "line2" => ... } }` will be converted to
  # `{ "address.line1" => ..., "address.line2" => ... }`. The keys produced are compatible with the
  # `deep_*` functions on hash, so this can provide a convenient way to iterate through values of a
  # hash.
  #
  # Note that this function is lossy - if two nested hashes would result in the same keys then only
  # one will be preserved.
  def flat_hash(separator = ".")
    each_with_object({}) do |(k, v), result|
      if v.is_a?(Hash)
        v.flat_hash(separator).each do |k2, v2|
          result["#{k}#{separator}#{k2}"] = v2
        end
      else
        result[k] = v
      end
    end
  end
end

class Integer
  def digits
    self.to_s.chars.map(&:to_i)
  end
end

# This is a bit of a hack to allow you to say "type: Boolean" as a validation
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

# This is a bit of a hack to allow you to say "type: Enum" as a validation
module Enum; end
class String; include Enum; end

class String
  # Converts a string to camelCase.
  def camel_case
    s = self
    s = s.snake_case unless /^[a-z0-9]+$/i =~ s
    s = s.downcase if s == s.upcase # stop "CVV" -> "cVV" when it should be "cvv"
    s.camelize(:lower)
  end

  # Converts a string to snake_case or SNAKE_CASE.
  def snake_case(casing = :lower)
    s = self.tr(" ", "_")
    case casing
    when :lower then s.downcase 
    when :upper then s.upcase
    else raise ArgumentError, "unsupported casing"
    end
  end

  # Converts a string to the specified primitive type. Useful because all Gherkin values are treated as strings.
  def to_type(type)
    # note: cannot use 'case type' as that expands to === which checks for instances of rather than type equality
    if type == Boolean
      self == "true"
    elsif type == Date
      Date.parse(self)
    elsif type == DateTime
      DateTime.parse(self)
    elsif type == Enum
      self.snake_case(:upper)
    elsif type == Float
      self.to_f
    elsif type == Integer
      self.to_i
    else
      self
    end
  end
end