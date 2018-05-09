# SocialSecurityNumber

This small Gem adds useful methods to your Ruby or Ruby on Rails app to validate for national identification numbers.

Find version information in the CHANGELOG.

## Suppoted countries and numbers:

* Belgium [National Register Number (Rijksregisternummer)](https://en.wikipedia.org/wiki/National_identification_number#Belgium)
* Canadian [Social Insurance Numbers (SINs)](https://en.wikipedia.org/wiki/Social_Insurance_Number)
* Chinese [Resident Identity Card Number](https://en.wikipedia.org/wiki/Resident_Identity_Card#Identity_card_number)
* Czech [birth numbers](https://en.wikipedia.org/wiki/National_identification_number#Czech_Republic_and_Slovakia)
* Germany [Steuer-IdNr (Steuerliche Identifikationsnummer)](https://en.wikipedia.org/wiki/National_identification_number#Germany)
* Denmark [Personal Identification Number (Det Centrale Personregister (CPR))](https://en.wikipedia.org/wiki/National_identification_number#Denmark)
* Estonian [Personal Identification Code (Isikukood (IK))](https://en.wikipedia.org/wiki/National_identification_number#Estonia)
* Finland [Personal Identity Code (Finnish: henkilötunnus (HETU))](https://en.wikipedia.org/wiki/National_identification_number#Finland)
* France [social insurance number](https://en.wikipedia.org/wiki/National_identification_number#France)
* Ireland [Personal Public Service Number (PPS No)](https://en.wikipedia.org/wiki/Personal_Public_Service_Number)
* Iceland [personal and organisation identity code (Kennitala)](https://en.wikipedia.org/wiki/National_identification_number#Iceland)
* Italy [tax code for individuals (Codice fiscale)](https://en.wikipedia.org/wiki/National_identification_number#Italy)
* Latvian [Personal Code (Personas kods)](https://en.wikipedia.org/wiki/National_identification_number#Latvia)
* Lithuania [Personal Code (Asmens kodas)](https://en.wikipedia.org/wiki/National_identification_number#Lithuania)
* Mexico [Unique Population Registry Code (Clave Única de Registro de Población (CURP))](https://en.wikipedia.org/wiki/Unique_Population_Registry_Code)
* Netherlands [Citizen's Service Number (Burgerservicenummer)](https://en.wikipedia.org/wiki/National_identification_number#Netherlands)
* Norway [birth number (Fødselsnummer)](https://en.wikipedia.org/wiki/National_identification_number#Norway)
* Pakistan [computerised national identity card number (CNIC)](https://en.wikipedia.org/wiki/National_identification_number#Pakistan)
* Spain [National Identity Document (Documento Nacional de Identidad (DNI)) number](https://en.wikipedia.org/wiki/National_identification_number#Spain)
* Sweden [Personal Identity Number (Personnummer)](https://en.wikipedia.org/wiki/National_identification_number#Sweden)
* Swiss [social security numbers](https://en.wikipedia.org/wiki/National_identification_number#Switzerland)
* United Kingdom National Insurance number (NINO)
* United Kingdom National Health Service number
* United Kingdom CHI (Community Health Index) number
* U.S. [Social Security number (SSN)](https://en.wikipedia.org/wiki/Social_Security_number)
* U.S. [Individual Taxpayer Identification Number (ITIN)](https://en.wikipedia.org/wiki/Individual_Taxpayer_Identification_Number)
* U.S. Employer Identification Number (EIN)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'social_security_number'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install social_security_number

## Usage
The country_code should always be a ISO 3166-1 alpha-2 (http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
```ruby
# Options:
#   :number => Civil number.
#   :country_code => Some fallback code (eg. 'nl').
#   :birth_date => Birth date (eg. 'yyyy-mm-dd').
#   :gender => Gender (eg. 'famale').
```
Validations
```ruby
SocialSecurityNumber::Validator.new({number:'Some number', country_code:'nl'}).valid? # => true

SocialSecurityNumber::Validator.new({number:'Some number', country_code:'nl', birth_date: 'yyyy-mm-dd'}).valid? # => true

SocialSecurityNumber::Validator.new({number:'Some number', country_code:'nl'}) # => #<SocialSecurityNumber::Validator:0x000000021e2420 @civil_number="Some number", @country_code="NL", @birth_date=birth_date from civil number information, @gender=gender from civil number information>

civil_number = SocialSecurityNumber::Validator.new({number:'Some number', country_code:'nl'})
civil_number.valid? # => false
civil_number.error # => "birth date 1933-09-25 dont match 1933-09-24"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Don't forget to add tests and run rspec before creating a pull request :)

See all contributors on https://github.com/samesystem/social_security_number/graphs/contributors .

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SocialSecurityNumber project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/samesystem/social_security_number/blob/master/CODE_OF_CONDUCT.md).
