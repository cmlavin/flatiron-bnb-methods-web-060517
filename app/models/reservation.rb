class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validates :checkin, :checkout, presence: true
  after_validation :host_not_guest, :is_available, :is_available_at_checkin,
                   :is_available_at_checkout, :checkin_before_checkout, on: [ :create, :update]



  def host_not_guest
    if self.listing.host_id == self.guest_id
      self.errors.add(:guest_id, "Cannot rent your own room.")
    end
  end

  def is_available

    self.listing.reservations.each do |reservation|
      if self.checkin && self.checkout && reservation.checkin < self.checkin && reservation.checkout > self.checkout
          #conflict
          self.errors.add(:checkin, "Not available for that date range.")
      end
    end
  end

  def is_available_at_checkout
    self.listing.reservations.each do |reservation|
      if self.checkout && self.checkout.between?(reservation.checkin, reservation.checkout)
          #conflict
          self.errors.add(:checkout, "Not available for that date range.")
      end
    end
  end

  def is_available_at_checkin
    self.listing.reservations.each do |reservation|
      if self.checkin && self.checkin.between?(reservation.checkin, reservation.checkout)
          #conflict
          self.errors.add(:checkin, "Not available for that date range.")
      end
    end
  end

  def checkin_before_checkout

    if self.checkin && self.checkout && self.checkin >= self.checkout
      self.errors.add(:checkin, "Checkout has to be at least one day after checkin")
    end
  end

end
