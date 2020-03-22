class User < ApplicationRecord
  has_many :search_terms, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates :email, uniqueness: true

  accepts_nested_attributes_for :search_terms

  protected

  def password_required?
    false
  end
end
