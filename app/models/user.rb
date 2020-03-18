class User < ApplicationRecord
  has_many :search_terms
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true

  protected

  def password_required?
    false
  end
end
