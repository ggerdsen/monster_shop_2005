class User <ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  validates_presence_of :name, :address, :city, :state, :zip

  enum role: %w(default merchant admin)
end
