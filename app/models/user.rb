class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  before_create :create_remember_digest

  #create a random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # make into digest
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #remember token in database for persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
		update_attribute(:remember_digest, nil)
  end

  private

    def create_remember_digest
      self.remember_token = User.new_token
      self.remember_digest = User.digest(remember_token)
    end

end
