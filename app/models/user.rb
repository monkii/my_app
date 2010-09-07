class User < ActiveRecord::Base
attr:accessible :username, :password, :email

validates :username, :prescense => true
                     :length => { maximum => 25 },
                     :uniqueness => { case_sensitive => false }

validates :email,    :presence => true,
                     :format   => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false }

validates :password, :prescense => true,
                     :length => { within 6..40 }

end

