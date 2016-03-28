require 'active_model'

module ActiveModel
  module Validations
    class AirlineDataValidator < ActiveModel::EachValidator

      def initialize(options)
        super(options)
      end

      def validate_each(record, attribute, value)
        base_block_validation(record, attribute, value)
        legs_block_validation(record, attribute, value)
        passengers_block_validation(record, attribute, value)
      end

      private

      def base_block_validation(record, attribute, value)
        record.errors.add(attribute, 'Ticket number should contain 3-digit ticketing code, 4-digit form number, 6-digit serial number, and check digit') if value[:ticket_number].to_s.gsub(/[^\d]/, '').size != 14

        record.errors.add(attribute, 'Restricted ticked indicator should be 0 or 1') unless %w(0 1).include?(value[:restricted_ticked_indicator].to_s)
      end

      def legs_block_validation(record, attribute, value)
        unless value[:legs].present? && value[:legs].is_a?(Array)
          record.errors.add(attribute, 'Legs should be an array')
          return
        end

        value[:legs].each do |leg|
          record.errors.add(attribute, 'Airline code should be 2-letter IATA code') if leg[:airline_code].to_s !~ /\w{2}/
          record.errors.add(attribute, 'Destination airport code should be 3-letter IATA code') if leg[:destination_airport_code].to_s !~ /\w{3}/
          record.errors.add(attribute, 'Originating airport code should be 3-letter IATA code') if leg[:originating_airport_code].to_s !~ /\w{3}/
          record.errors.add(attribute, 'Departure date time should has valid format') if invalid_date?(leg[:departure_date_time])
          record.errors.add(attribute, 'Arrival date time should has valid format') if invalid_date?(leg[:arrival_date_time])
          record.errors.add(attribute, 'Class should be 1-letter IATA code') if leg[:class].to_s !~ /\w{1}/
          record.errors.add(attribute, 'Stop over code can\'t be blank') unless leg[:stop_over_code].present?
          record.errors.add(attribute, 'Flight number can\'t be blank') unless leg[:flight_number].present?
          record.errors.add(attribute, 'Originating country can\'t be blank') unless leg[:originating_country].present?
          record.errors.add(attribute, 'Originating city can\'t be blank') unless leg[:originating_city].present?
          record.errors.add(attribute, 'Destination country can\'t be blank') unless leg[:destination_country].present?
          record.errors.add(attribute, 'Destination city can\'t be blank') unless leg[:destination_city].present?
        end
      end

      def invalid_date?(date)
        begin
          Time.parse(date)
          false
        rescue
          true
        end
      end

      def passengers_block_validation(record, attribute, value)
        unless value[:passengers].present? && value[:passengers].is_a?(Array)
          record.errors.add(:passengers, 'Passengers should be an array')
          return
        end

        value[:passengers].each do |passenger|
          record.errors.add(attribute, 'First name can\'t be blank') unless passenger[:first_name].present?
          record.errors.add(attribute, 'Last name can\'t be blank') unless passenger[:last_name].present?
        end
      end
    end

    module ClassMethods
      def validates_airline_data(*attr_names)
        validates_with AirlineDataValidator, _merge_attributes(attr_names)
      end
    end
  end
end
