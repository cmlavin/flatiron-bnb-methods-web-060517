class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_str, end_str)
    #binding.pry
    start_date = Date.parse(start_str)
    end_date = Date.parse(end_str)
    self.listings.map do |listing|
      conflict = false
      listing.reservations.each do |reservation|
        #binding.pry
        if reservation.checkin < end_date && reservation.checkout > start_date
            #conflict
            conflict = true
        end
      end
      if !conflict
        listing
      end
    end.compact
    #binding.pry
  end

  def self.highest_ratio_res_to_listings
    highest_ratio_city = nil
    highest_ratio = 0.0
    self.all.each do |city|
      num_reservations = 0
      ratio = 0.0
      city.listings.each do |listing|
        num_reservations += listing.reservations.size
      end
      ratio = num_reservations / city.listings.size.to_f
      if ratio > highest_ratio
        highest_ratio = ratio
        highest_ratio_city = city
      end
    end
    highest_ratio_city
  end

  def self.most_res
    most_popular_city = nil
    highest_reservations = 0
    self.all.each do |city|
      num_reservations = 0
      city.listings.each do |listing|
        #listing.reservations.size.inject(0) {|num_res, listing| num_res + listing}
        num_reservations += listing.reservations.size
      end
      if num_reservations > highest_reservations
        highest_reservations = num_reservations
        most_popular_city = city
      end
    end
    most_popular_city
  end

end
