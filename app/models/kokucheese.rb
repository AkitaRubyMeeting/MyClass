class Kokucheese

  attr_reader :url
  attr_reader :title, :ics, :index_url
  
  def initialize url
    @url = url
    analize
  end
  
  def benkyoukai
    b = Benkyoukai.site(Benkyoukai::KOKUCHEESE).title(title).first
    unless b
      b = Benkyoukai.create(site:Benkyoukai::KOKUCHEESE, title:title, source_url:index_url, ics:ics)
    end
    b
  end

  private

  def analize
    @index_url, @title = get_index_url
    make_ical get_akitam_events
  end
  
  def get_akitam_events
    doc = Nokogiri::HTML(open(index_url))

    # イベントは.veventで取得できる
    doc.search(".vevent").map do |event_info|
    
      # 日付は.event_dateで取得
      a = event_info
          .search(".event_date").inner_text.gsub("\r\n", "")
          .scan(/(\d+)年(\d+)月(\d+)日/)
          .flatten
          .map{|e| e.to_i}
      date = Date.new(*a)
  
      # イベント名は.event_nameで取得
      name = event_info
                    .search(".event_name").inner_text

      { date:date, name:name }
    end
  end
  
  
  def get_index_url
    doc = Nokogiri::HTML(open(url))

    a = doc.search("a").map do |a|
      url = a["href"]
    if /http:\/\/kokucheese.com\/main\/host\/([^\/]+)/ =~ url
        [url, URI.unescape($1)]
      end
    end.select{|a| a}
    a.first
  end

  def make_ical events
    cal = Icalendar::Calendar.new
    events.each do |event|
      e = cal.event  # 新規eventがcalに追加され、それが返される
      e.dtstart = Icalendar::Values::Date.new(event[:date].strftime("%Y%m%d"))
      e.dtend = Icalendar::Values::Date.new(event[:date].strftime("%Y%m%d"))
      e.summary = event[:name]
      e.description = event[:name]
      e.ip_class = "PRIVATE"
    end
    @ics = cal.to_ical
  end
  

end

__END__


def scan_group
  #url = "http://kokucheese.com/main/host/Akita.m"
  url = "http://kokucheese.com/main/calendar/"
  doc = Nokogiri::HTML(open(url))

  doc.search("a").each do |a|
    url = a["href"]
if /http:\/\/kokucheese.com\/main\/host\/(.+)/ =~ url
p  url, URI.unescape($1)#.force_encoding("utf-8")
end
  end

end

scan_group
#s = make_ical get_akitam_events
#File.open("akitam.ics", "w"){|f| f.write(s)}
