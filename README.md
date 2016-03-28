# Validates Airline addendum

This gem adds the capability of validating sirialized Airline addendmun hash to ActiveRecord and ActiveModel

## Installation
    
```    
# add this to your Gemfile
gem "validates_airline_addendum"

# and  run
sudo gem install validates_airline_addendum
```

## Usage

### With ActiveRecord

```ruby
class Travel < ActiveRecord::Base
  serialize :data, Hash

  validates :name, inclusion: { in: %w(airline), message: "%{value} is not a valid name" }
  validates :data, airline_data: true
end
```

## Valid airline data
```ruby
    {
      agency_code: "03",
      agency_name: "Corel travel",
      ticket_number: "390 5241 025377 1",
      booking_number: "DKZVUA",
      restricted_ticked_indicator: "0",
      legs:[
        {
          airline_code: "B2",
          stop_over_code: "X",
          flight_number: "A3 971",
          departure_date_time: "2014-05-26T05:15:00",
          originating_country: "RU",
          originating_city: "Moscow",
          originating_airport_code: "DME",
          arrival_date_time: "2014-05-26T07:30:00",
          destination_country: "Greece",
          destination_city: "Athems",
          destination_airport_code: "ATH",
          coupon: "coupon code",
          class: "C"
        }
      ],
      passengers:[
        {
          first_name: "KONSTANTIN",
          last_name: "IVANOV"
        },
        {
          first_name: "JULIA",
          last_name: "IVANOVA"
        }
      ]
    }
```

## Contributing
 We appreciate all your work on new features and bugfixes.

## Credits

Airline addendum validator is created and maintained by [eComCharge](https://ecomcharge.com/).

## License

Validates URL is Copyright © 2016 [eComCharge](https://ecomcharge.com/). It is free software, and may be redistributed under the terms specified in the LICENSE file.
