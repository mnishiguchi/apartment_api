# == Schema Information
#
# Table name: apartments
#
#  id           :integer          not null, primary key
#  identifier   :string
#  name         :string
#  email        :string
#  description  :text
#  url          :string
#  phone        :string
#  office_hours :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Apartment < ApplicationRecord
  has_many :floorplans

  has_many :apartment_locations
  has_many :locations, through: :apartment_locations

  has_many :apartment_amenities
  has_many :amenities, through: :apartment_amenities

  scope :without_floorplans, -> { distinct.left_outer_joins(:floorplans).where(floorplans: { id: nil }) }
  scope :with_floorplans, -> { distinct.joins(:floorplans) }
  scope :without_management, -> { where(management_id: nil) }
end
