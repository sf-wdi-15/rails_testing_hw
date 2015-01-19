class User < ActiveRecord::Base

  has_secure_password
  # confirm method for 'has_secure_password'
  def self.confirm(email_param, password_param)
    user = User.find_by({email: email_param})
    if user
      user.authenticate(password_param)
    end
  end
  
  # password validations
  validates_presence_of :password_confirmation
  validates_length_of :password, minimum: 8

  # email validations
  validates_confirmation_of :email
  validates_presence_of :email_confirmation
  validates_format_of :email, with: /.+@.+/

  # associations
  has_many :articles

  
end
