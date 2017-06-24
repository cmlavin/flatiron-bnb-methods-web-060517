class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.each_with_object([]) do |listing, guests_array|
      reservations.each do |reservation|
        guests_array << reservation.guest
      end
    end
  end

  def hosts
    self.reviews.each_with_object([]) do |review, hosts_array|
      hosts_array << review.reservation.listing.host
    end
    #This should work, but doesn't:
    # self.reservations.each_with_object([]) do |reservation, hosts_array|
    #   hosts_array << reservation.listing.host
    # end
  end

  def host_reviews
    self.listings.each_with_object([]) do |listing, review_array|
      listing.reservations.each do |reservation|
        review_array << reservation.review
      end
    end
  end
end
