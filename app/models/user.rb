class User < ApplicationRecord
  before_save{self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.user.name_maxlength}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.user.email_maxlength},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.user.pass_minlenght}
  has_secure_password
end