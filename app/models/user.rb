class User < ActiveRecord::Base
  attr_accessible :access_level, :email, :password, :uid

  def authenticate(password)
    self.password.eql? password
  end
end
