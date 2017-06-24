# requ CitiesHelper
class Neighborhood < ActiveRecord::Base
  extend CitiesHelper

  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_str, end_str)
    start_date = Date.parse(start_str)
    end_date = Date.parse(end_str)
    self.listings.map do |listing|
      conflict = false
      listing.reservations.each do |reservation|
        if reservation.checkin < end_date && reservation.checkout > start_date
            #conflict
            conflict = true
        end
      end
      if !conflict
        listing
      end
    end.compact
  end
end
