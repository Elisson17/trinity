class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :sku, null: false
      t.boolean :active, default: true, null: false
      t.boolean :featured, default: false, null: false
      t.string :material
      t.text :care_instructions

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :active
    add_index :products, :featured
    add_index :products, :price
  end
end
