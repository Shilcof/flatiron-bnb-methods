class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true

  validate :guest_and_host_not_the_same, :availible, :checkout_after_checkin

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

  private

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You cannot book your own apartment.")
    end
  end

  def availible
    Reservation.where(listing_id: listing.id).where.not(id: id).each { |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this is unavailable for your requested dates.")
      end
    }
  end

  def checkout_after_checkin
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Your check-out date must be after your check-in.")
    end
  end
end
