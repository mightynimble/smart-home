class User < ActiveRecord::Base
  attr_accessible :access_level, :email, :password, :uid
end
