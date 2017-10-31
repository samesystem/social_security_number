require 'social_security_number/version'

module SocialSecurityNumber
  autoload :Validator, 'social_security_number/validator'
  autoload :Country, 'social_security_number/country'
  Dir["#{__dir__}/social_security_number/country/*.rb"].each { |f| require f }
end
