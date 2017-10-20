class CreateEmailMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :email_messages do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :conversation, foreign_key: true
      t.string :url
      t.datetime :seen_at

      t.timestamps
    end
  end
end
