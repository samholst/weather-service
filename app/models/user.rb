class User < ApplicationRecord
  validates_presence_of :name

  has_many :access_keys
  has_many :text_messages
end
