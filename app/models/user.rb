require 'digest'
class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :username, :password, :email, :password_confirmation

  validates :username, :prescense => true
                      :length => { maximum => 25 },
                       :uniqueness => { case_sensitive => false }

  validates :email,    :presence => true,
                       :format   => { :with => email_regex },
                       :uniqueness => { :case_sensitive => false }

  validates :password, :prescense => true,
                       :confirmation => true,
                       :length => { within 6..40 }

  before save :encrypted_password


  def right_password?(submitted_password)
    self.encrypt_password == encrypt(submitted_password)
  end

  def self.authenticate(username, submitted_password)
    user = find_by_username(username)
    return nil if user.nil?
    return user if user.right_password?(submitted_password)
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
end

