class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :users, dependent: :destroy
  has_many :items, through: :admin_user_items
  has_many :admin_user_items

  ROLES = %w(super regular) unless defined? ROLES

  scope :regular_admins, -> { where(role: 'regular') }
end
