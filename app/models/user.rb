class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :rememberable_value
  before_validation :get_ldap_email

  attr_accessor :remember_token

  def get_ldap_email
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first
  end

  def rememberable_value
    self.remember_token ||= Devise.friendly_token
  end

end
