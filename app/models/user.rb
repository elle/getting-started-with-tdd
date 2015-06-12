class User < ApplicationRecord
  has_many :pets, dependent: :destroy

  validates :first_name, presence: true

  def full_name
    [first_name, last_name].compact.join(" ").titleize
  end
end
