class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_movies, through: :favourites, source: :movie

  has_secure_password

  validates :name, presence: true

  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
end
