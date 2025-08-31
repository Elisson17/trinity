class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nickname, null: false
      t.string :cep, null: false
      t.string :street, null: false
      t.string :number, null: false
      t.string :complement
      t.string :neighborhood, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.boolean :is_default, default: false

      t.timestamps
    end

    add_index :addresses, [ :user_id, :is_default ]
  end
end
