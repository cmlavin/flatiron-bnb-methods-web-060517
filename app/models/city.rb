class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  extend CitiesHelper

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

end
