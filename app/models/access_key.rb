class AccessKey < ApplicationRecord
  belongs_to :user
  before_create :generate_token

  validates_uniqueness_of :token

  def generate_token
    10.times do |_|
      token = SecureRandom.hex(10)

      unless AccessKey.find_by_token(token)
        self.token = token
        break
      end
    end

    raise "Error creating token" unless self.token
  end
end
