# Globalize3::Validations

Provides a uniqueness validator which can be used with globalize3 translated models.

## Compatibility

The validator is currently based on the activerecord 3.1 uniqueness validator. It should also work with 3.0 (and probably with 3.2).

## Installation

Add this line to your application's Gemfile:

    gem 'globalize3-validations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install globalize3-validations

## Usage

Provides a `GlobalizedUniquenessValidator` which checks whether
the value of the specified attributes are unique across the system.

See validates_uniqueness_of in ActiveRecord::Validations::ClassMethods for further explanation.
This validator basically works the same, but respects globalize3 model translations.
Also, you can use :locale when specifying the :scope option.

For instance, if you want to validate that a product title is unique in each locale:

  class Product < ActiveRecord::Base
    translates :title
    validates_globalized_uniqueness_of :title, :scope => :locale
  end

Or:

  class Product < ActiveRecord::Base
    translates :title
    validates :title, :globalized_uniqueness => {:scope => :locale}
  end

## Todo / Known Issues

* Might not yet work correctly with serialized attributes which are translated
* Verify that it works with activerecord 3.2
* Tests!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
