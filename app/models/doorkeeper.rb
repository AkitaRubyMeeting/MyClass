class Doorkeeper

  attr_reader :ics, :group, :title, :url, :events, :prefecture
  attr_reader :benkyoukai
  
  def initialize arg
    case arg
    when /^http:\/\/(.+)\.doorkeeper\.jp/
      @group = $1
    end
    analize
  end
  
  def benkyoukai
    unless @benkyoukai
      @benkyoukai = Benkyoukai.site(Benkyoukai::DOORKEEPER).title(title).first
      unless @benkyoukai
        @benkyoukai = Benkyoukai.create(site:Benkyoukai::DOORKEEPER, title:title, source_url:url, ics:ics, prefecture:prefecture)
      end
    end
    @benkyoukai
  end
  


  private
  
  def analize
    get_events
    make_ical
  end
  
  def events_url
    "http://api.doorkeeper.jp/groups/#{group}/events"
  end
  
  def get_events
  s = open(events_url){|f| f.read}
    @events = JSON.load(s)
    event = @events.first["event"]
    if event
      @title = event["group"]["name"]
      @url = event["group"]["public_url"]
    end
  end
  
  def make_ical
    cal = Icalendar::Calendar.new
    events.each do |event|
      event = event["event"]
      e = cal.event  # 新規eventがcalに追加され、それが返される
      e.dtstart = Icalendar::Values::Date.new(Time.new(event["starts_at"]).to_datetime)
      e.dtend = Icalendar::Values::Date.new(Time.new(event["ends_at"]).to_datetime)
      e.summary = event["title"]
      e.description = event["title"]
      e.location = [event["address"], event["venue_name"]].join(" ")
      e.ip_class = "PRIVATE"
    end
    @ics = cal.to_ical
  end

end