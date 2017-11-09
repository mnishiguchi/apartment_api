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

require "rails_helper"

RSpec.describe Location, type: :model do
  describe "ORM" do
    it "has correct columns" do
      should have_db_column(:latitude)
      should have_db_column(:longitude)
      should have_db_column(:street)
      should have_db_column(:county)
      should have_db_column(:city)
      should have_db_column(:state)
      should have_db_column(:postal_code)
      should have_db_column(:display_address)
      should have_db_column(:raw_data)
    end
  end

  it "has correct associations" do
    should have_many(:apartments)
  end

  it "is valid" do
    expect(create(:location)).to be_valid
  end
end
