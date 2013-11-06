class User < OpenStruct
  def initialize(name, extra_params={})
    extra_params ||= {}
    extra_params[:onid] = name
    super(extra_params)
  end

  def banner_record
    @banner_record ||= BannerRecord.where(:onid => self.onid).first
  end

  def reservations
    Reservation.where(:user_onid => onid)
  end

  def max_reservation_time
    @max_reservation_time ||= calculate_max_reservation_time
  end

  def nil?
    onid.blank?
  end

  def roles
    Role.where(:onid => onid)
  end

  def admin?
    return false if onid.blank?
    roles.map(&:role).include?("admin")
  end

  private

  def calculate_max_reservation_time
    if admin?
      result ||= reservation_times["admin"]
    end
    if banner_record && banner_record.status
      result ||= reservation_times[banner_record.status.downcase] if reservation_times.has_key?(banner_record.status.downcase)
    end
    result ||= default_reservation_time
    result.to_i*60
  end

  def default_reservation_time
    APP_CONFIG["users"]["reservation_times"]["default"]
  end

  def reservation_times
    APP_CONFIG["users"]["reservation_times"]
  end

end
