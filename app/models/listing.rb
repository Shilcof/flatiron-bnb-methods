class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  before_create :set_host_as_host
  before_destroy :unset_host_as_host

  def average_review_rating
    reviews.average(:rating)
  end

  def available?(start_date, end_date)
    reservations.where('checkin <= ? AND checkout >= ?', end_date, start_date).size > 0 ? false : true
  end
  
  private
  
  def set_host_as_host
    host.update(host: true)
  end

  def unset_host_as_host
    if Listing.where(host: host).where.not(id: id).empty?
      host.update(host: false)
    end
  end
end
