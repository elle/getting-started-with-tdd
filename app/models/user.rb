class User < ApplicationRecord
  has_many :pets, dependent: :destroy
end
