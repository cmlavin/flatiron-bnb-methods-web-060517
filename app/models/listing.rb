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

  before_create :make_host
  before_destroy :remove_host

  def average_review_rating
    ratings = self.reviews.map {|review| review.rating}
    ratings.inject(0.0) { |sum, rating| sum + rating } / ratings.size
  end

  def make_host
    host = User.find(self.host_id)
    host.update(host: true)
  end

  def remove_host
    host = User.find(self.host_id)
    if host.listings.size == 1
      host.update(host: false)
    end
  end

end
