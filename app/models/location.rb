# == Schema Information
#
# Table name: locations
#
#  id              :integer          not null, primary key
#  latitude        :decimal(10, 6)
#  longitude       :decimal(10, 6)
#  street          :string
#  city            :string
#  county          :string
#  state           :string
#  postal_code     :string
#  display_address :string           default([]), is an Array
#  raw_data        :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Location < ApplicationRecord
  has_many :apartment_locations
  has_many :apartments, through: :apartment_locations

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :state, presence: true
end
