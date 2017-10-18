class Relationship < ApplicationRecord
  belongs_to :user_1, foreign_key: :user_1_id, class_name: User
  belongs_to :user_2, foreign_key: :user_2_id, class_name: User
  validates :user_1_id, uniqueness: { scope: :user_2_id }
  scope :between, -> (user_1_id, user_2_id) do
    where(user_1_id: user_1_id, user_2_id: user_2_id).or(
      where(user_1_id: user_2_id, user_2_id: user_1_id)
    )
  end
end
