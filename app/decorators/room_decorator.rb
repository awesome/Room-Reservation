class RoomDecorator < Draper::Decorator
  delegate_all
  attr_accessor :events

  def filter_string
    string = ""
    filters.each do |filter|
      string += "filter-#{filter.id} "
    end
    string.strip
  end


  # This returns the room's events but with filler "available" events to allow for
  # easier iteration in the views.
  # @TODO Refactor this into something more readable.
  def decorated_events(base_time)
    return @decorated_events if @decorated_events
    @decorated_events = []
    last_start_time = base_time.midnight.seconds_since_midnight
    events.each do |event|
      # Prefix with an 'available' event if required.
      if event.start_time.seconds_since_midnight > last_start_time
        start_time = event.start_time.midnight+last_start_time.seconds
        end_time = event.start_time
        @decorated_events << build_available_decorator(start_time, end_time)
      end
      last_start_time = event.end_time.seconds_since_midnight
      @decorated_events << event
    end
    # Suffix with an 'available' event if necessary
    if events.length == 0 || last_start_time != 0
      start_time = base_time.midnight+last_start_time.seconds
      end_time = base_time.tomorrow.midnight
      @decorated_events << build_available_decorator(start_time, end_time)
    end
    return @decorated_events
  end

  def build_available_decorator(start_time, end_time)
    AvailableDecorator.new(Event.new(start_time, end_time, 0))
  end

end
