class Room < ActiveRecord::Base
  attr_accessible :floor, :name
  validates :floor, :name, presence: true
  validates :floor, numericality: {only_integer: true}
  has_many :reservations

  def load_reservations_today day
    end_of_day = day.end_of_day
    midnight = day.midnight
    @reservations_today = self.reservations.where('start_time < ? AND end_time > ?', end_of_day, midnight).to_a
    @reservations_today.each do |r|
      r.start_time = midnight if r.start_time < midnight
      r.end_time = end_of_day if r.end_time > end_of_day
    end
    @reservations_today <<= Reservation.new :start_time => midnight, :end_time => midnight + 6.hours, :reserver_onid => 'drupal', :user_onid => '_schedule', :description => 'Library closed'
    @reservations_today <<= Reservation.new :start_time => midnight + 20.hours, :end_time => midnight + 24.hours, :reserver_onid => 'drupal', :user_onid => '_schedule', :description => 'Library closed'
    @reservations_today <<= Reservation.new :start_time => midnight + 8.hours, :end_time => midnight + 9.hours, :reserver_onid => 'admin1', :user_onid => '_maintainance', :description => 'Room cleaning'
    @reservations_today.sort_by! { |r| r.start_time }
  end

  def reservations_today
    @reservations_today rescue nil
  end

end
