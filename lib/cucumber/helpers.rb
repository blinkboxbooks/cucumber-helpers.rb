require "cucumber/helpers/version"
require "cucumber/helpers/core_ext"

module Cucumber
  module Helpers
    VERSION = ::File.read(File.join(File.dirname(__FILE__),"../../VERSION"))
  end
end
