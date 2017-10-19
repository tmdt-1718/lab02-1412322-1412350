class CreateEmailMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :email_messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :content
      t.datetime :seen_at

      t.timestamps
    end
  end
end
