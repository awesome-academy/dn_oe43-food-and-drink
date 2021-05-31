class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  before_save :downcase_email
  attr_accessor :remember_token

  enum role: {
    user: 0,
    admin: 1
  }

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  validates :email, format: {with: Settings.user.email.regex},
                    length: {maximum: Settings.user.email.max_length},
                    presence: true,
                    uniqueness: true
  validates :name, presence: true
  validates :password, presence: true,
                       length: {minimum: Settings.user.password.min_length}

  def downcase_email
    email.downcase!
  end

  has_secure_password
end
