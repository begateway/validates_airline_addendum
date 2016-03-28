require 'spec_helper'

describe Travel do
  let(:params) do
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
  end

  let(:travel) { Travel.new }

  before(:all) do
    ActiveRecord::Schema.define(:version => 1) do
      create_table :travels, :force => true do |t|
        t.column :name, :string
        t.column :data, :text
      end
    end
  end

  after(:all) do
    ActiveRecord::Base.connection.drop_table(:travels)
  end

  it "validates all" do
    travel.name = 'airline'
    travel.data = params

    expect(travel).to be_valid
  end

  it "validates name" do
    travel.name = 'air'
    expect(travel).to_not be_valid
    expect(travel.errors[:name]).to eq(['air is not a valid name'])

    travel.name = 'airline'
    expect(travel).to_not be_valid
    expect(travel.errors[:name]).to be_empty
  end

  it "validates base airline block" do
    params[:ticket_number] = '123'
    params[:restricted_ticked_indicator] = '3'
    travel.data = params

    expect(travel).to_not be_valid
    expect(travel.errors[:data]).to eq ['Ticket number should contain 3-digit ticketing code, 4-digit form number, 6-digit serial number, and check digit', 'Restricted ticked indicator should be 0 or 1']
  end

  it "validates presense of legs" do
    params[:legs] = ''
    travel.data = params
    expect(travel).to_not be_valid
    expect(travel.errors[:data]).to eq(['Legs should be an array'])

    params.delete(:legs)

    travel.data = params
    expect(travel).to_not be_valid
    expect(travel.errors[:data]).to eq(['Legs should be an array'])
  end

  it "validates legs" do
    params[:legs] = [
      {
        airline_code: "B2-2",
        departure_date_time: "Test-time",
        originating_airport_code: "DME-T",
        arrival_date_time: "Test",
        destination_airport_code: "ATH-T",
        coupon: "coupon code",
        class: "C-T"
      }
    ]

    travel.data = params
    expect(travel).to_not be_valid

    expect(travel.errors[:data]).to eq [
                                      "Departure date time should has valid format",
                                      "Arrival date time should has valid format",
                                      "Stop over code can't be blank",
                                      "Flight number can't be blank",
                                      "Originating country can't be blank",
                                      "Originating city can't be blank",
                                      "Destination country can't be blank",
                                      "Destination city can't be blank"
                                    ]
  end

  it "validates presense of passengers" do
    params[:passengers] = ''
    travel.data = params
    expect(travel).to_not be_valid
    expect(travel.errors[:passengers]).to eq(['Passengers should be an array'])

    params.delete(:passengers)

    travel.data = params
    expect(travel).to_not be_valid
    expect(travel.errors[:passengers]).to eq(['Passengers should be an array'])
  end

  it "validates passengers" do
    params[:passengers] = [{name: "John"}]

    travel.data = params
    expect(travel).to_not be_valid

    expect(travel.errors[:data]).to eq ["First name can't be blank", "Last name can't be blank"]
  end
end
