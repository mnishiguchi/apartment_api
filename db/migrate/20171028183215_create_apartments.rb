class CreateApartments < ActiveRecord::Migration[5.1]
  def change
    create_table :apartments do |t|
      t.string :identifier
      t.string :name
      t.string :email
      t.text :description
      t.string :url
      t.string :phone
      t.jsonb :office_hours, default: {}

      t.timestamps
    end
  end
end
