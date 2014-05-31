class Doorkeeper

  attr_reader :ics, :group, :title, :url, :events, :prefecture
  attr_reader :benkyoukai
  
  def initialize arg
    case arg
    when /^http:\/\/(.+)\.doorkeeper\.jp/
      @group = $1
    when String
      @group = get_group_of_title arg
    when Benkyoukai
      @benkyoukai = arg
      /^http:\/\/(.+)\.doorkeeper\.jp/ =~ @benkyoukai.source_url
      @group = $1
      @title = @benkyoukai.title
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
  
  def get_group_of_title title
    url = "http://api.doorkeeper.jp/events?q=#{URI.escape(title)}"
    s = open(url){|f| f.read}
    @events = JSON.load(s)
    event = @events.first["event"]
    if event
      /^http:\/\/(.+)\.doorkeeper\.jp/ =~ event["group"]["public_url"]
      $1
    else
      nil
    end
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
    tzid = Time.zone.name
    events.each do |event|
      event = event["event"]
      e = cal.event  # 新規eventがcalに追加され、それが返される
      
      # to_datetimeではnsecがないと出るのでDateTime.newを使っている
      t = Time.iso8601(event["starts_at"]).in_time_zone(Time.zone)
      t = DateTime.new t.year, t.month, t.day, t.hour, t.min
      e.dtstart = Icalendar::Values::DateTime.new t, 'tzid' => tzid
      
      t = Time.iso8601(event["ends_at"]).in_time_zone(Time.zone)
      t = DateTime.new t.year, t.month, t.day, t.hour, t.min
      e.dtend = Icalendar::Values::DateTime.new t, 'tzid' => tzid
      
      e.summary = event["title"]
      e.description = event["title"]
      e.location = [event["address"], event["venue_name"]].join(" ")
      e.ip_class = "PRIVATE"
    end
    @ics = cal.to_ical
  end

end