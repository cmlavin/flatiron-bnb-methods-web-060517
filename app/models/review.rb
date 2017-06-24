class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true
  validate :reservation_in_past

  def reservation_in_past
    # binding.pry]
    if self.reservation && self.reservation.checkout > Time.now 
        self.errors.add(:reservation_id, "Finish your stay before writing review.")
    end
  end
end
