class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :user, null: true, foreign_key: true
      t.string :session_id, null: true
      t.datetime :expires_at

      t.timestamps
    end

    add_index :carts, :session_id
    add_index :carts, :expires_at
    add_index :carts, [ :user_id, :session_id ]
  end
end
