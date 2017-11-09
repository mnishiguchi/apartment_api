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

FactoryBot.define do
  factory :location do
    latitude { Faker::Number.between(36.540759, 39.466012) }
    longitude  { Faker::Number.between(-83.675395, -75.166435) }
    street { Faker::Address.street_address }
    county { "#{Faker::Address.state} County" }
    city "Washington"
    state { %w[DC MD VA].sample }
    neighbourhood { Faker::Address.community }
    postal_code { Faker::Address.zip_code }
  end
end
