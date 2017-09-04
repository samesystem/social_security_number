require "civil_number/version"
require "civil_number/validator"
require "civil_number/country"

module CivilNumber
  autoload :Validator, 'civil_number/validator'
  autoload :Country, 'civil_number/country'
end
