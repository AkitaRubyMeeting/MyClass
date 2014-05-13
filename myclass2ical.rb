require 'nokogiri'
require 'open-uri'
require 'date'
require 'icalendar'


def get_akitam_events
  url = "http://kokucheese.com/main/host/Akita.m"
  doc = Nokogiri::HTML(open(url))

  # イベントは.veventで取得できる
  doc.search(".vevent").map do |event_info|
    event = {}
  
    # 日付は.event_dateで取得
    a = event_info
          .search(".event_date").inner_text.gsub("\r\n", "")
          .scan(/(\d+)年(\d+)月(\d+)日/)
          .flatten
          .map{|e| e.to_i}
    event[:date] = Date.new(*a)
  
    # イベント名は.event_nameで取得
    event[:name] = event_info
                    .search(".event_name").inner_text
    event
  end
end


def make_ical events
  cal = Icalendar::Calendar.new
  events.each do |event|
    e = cal.event
    e.dtstart = Icalendar::Values::Date.new(event[:date].strftime("%Y%m%d"))
    e.dtend = Icalendar::Values::Date.new(event[:date].strftime("%Y%m%d"))
    e.summary = event[:name]
    e.description = event[:name]
    e.ip_class = "PRIVATE"
  end
  cal.to_ical
end

s = make_ical get_akitam_events
File.open("akitam.ics", "w"){|f| f.write(s)}
