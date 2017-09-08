require "civil_number/version"

module CivilNumber
  autoload :Validator, 'civil_number/validator'
  autoload :Country, 'civil_number/country'
  Dir["#{__dir__}/civil_number/country/*.rb"].each { |f| require f }
end
