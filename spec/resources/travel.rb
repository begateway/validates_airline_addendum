class Travel < ActiveRecord::Base
  serialize :data, Hash

  validates :name, inclusion: { in: %w(airline), message: "%{value} is not a valid name" }
  validates :data, airline_data: true
end
