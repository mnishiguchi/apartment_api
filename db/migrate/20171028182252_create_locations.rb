class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :street
      t.string :city
      t.string :county
      t.string :state
      t.string :postal_code
      t.string :display_address, array: true, default: []
      t.jsonb :raw_data, default: {}

      t.timestamps
    end
  end
end
