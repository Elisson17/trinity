class AddWhatsappVerificationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :whatsapp_code, :string
    add_column :users, :whatsapp_code_expires_at, :datetime
    add_column :users, :phone_verified_at, :datetime

    add_index :users, :whatsapp_code
    add_index :users, :phone_verified_at
  end
end
