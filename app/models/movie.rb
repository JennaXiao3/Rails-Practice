class Movie < ApplicationRecord
  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  has_one_attached :main_image

  validates :title, presence: true, uniqueness: true

  validates :released_on, presence: true

  validates :description, length: { minimum: 25 }

  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  RATINGS = %w[G PG PG-13 R NC-17]
  validates :rating, inclusion: { in: RATINGS }

  validate :acceptable_image

  scope :upcoming, -> { where('released_on > ?', Time.now).order('released_on asc') }
  scope :released, -> { where('released_on < ?', Time.now).order('released_on desc') }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :flops, -> { released.where('total_gross < 225000000').order(total_gross: :asc) }
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100
  end

  def to_param
    title.parameterize
  end

  private

  def acceptable_image
    return unless main_image.attached?

    errors.add(:main_image, 'is too big') unless main_image.blob.byte_size <= 1.megabyte

    acceptable_types = ['image/jpeg', 'image/png']
    return if acceptable_types.include?(main_image.content_type)

    errors.add(:main_image, 'must be jpeg or png')
  end

  def set_slug
    self.slug = title.parameterize
  end
end
