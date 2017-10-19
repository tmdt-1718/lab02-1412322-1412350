class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :user_1_id
      t.integer :user_2_id
      t.integer :action_user_id
      t.integer :status

      t.timestamps
    end
    add_index :relationships, :user_1_id
    add_index :relationships, :user_2_id
    add_index :relationships, [:user_1_id, :user_2_id], unique: true    
    
  end
end
