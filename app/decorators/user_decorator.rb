class UserDecorator < Draper::Decorator
  delegate_all

  def tag
    h.content_tag(:span,'',:id => "user-info", :data => data_hash)
  end

  def nil?
    object.nil?
  end

  def min_date
    return '' if object.staff?
    date = Time.current
    "#{date.month}/#{date.day}/#{date.year}"
  end

  def reservation_popup_partial
    return "admin_reservation_popup" if object.staff?
    "reservation_popup"
  end

  private

  def data_hash
    {:onid => onid,
     :max_reservation => self.max_reservation_time,
     :staff => object.staff?
    }
  end

end
