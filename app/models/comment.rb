# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  user_id    :bigint
#  article_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  # Associations
  belongs_to :article
  belongs_to :user, optional: true

  # Validations
  validates :content, length: { minimum: 3 }
end
