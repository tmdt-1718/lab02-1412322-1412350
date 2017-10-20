class CreateEmailMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :email_messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.string :content
      t.string :url
      t.datetime :seen_at

      t.timestamps
    end
    add_index :email_messages, :recipient_id
    add_index :email_messages, :sender_id
    add_index :email_messages, [:recipient_id, :sender_id]
  end
end
