class Article < ActiveRecord::Base

  # validations
  validates :title, presence: true, length: { minimum: 3 }
  validates :content, presence: true, length: { minimum: 5 }

  # associations
  belongs_to :user

end
