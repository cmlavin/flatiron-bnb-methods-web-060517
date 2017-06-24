class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  #before_create host: true

  def average_review_rating
    binding.pry
    sum_of_ratings = (rating.reviews).inject { |sum, rating| sum + rating }
    sum_of_ratings / (rating.reviews.length)
  end
end
