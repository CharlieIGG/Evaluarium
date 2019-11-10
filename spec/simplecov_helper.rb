
require "simplecov"
require "simplecov-console"
require "simplecov-reporter"
require "simplecov-json"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::Reporter,
  SimpleCov::Formatter::Console
]

SimpleCov.start "rails" do
  add_filter [/spec/, /config/]
end
