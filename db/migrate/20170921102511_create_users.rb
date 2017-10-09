class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :username
      t.string :token

      t.timestamps
    end

    add_index :users, :token, unique: true
  end
end
