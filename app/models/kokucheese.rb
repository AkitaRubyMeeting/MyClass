class Kokucheese

  attr_reader :url
  attr_reader :title, :ics, :index_url, :prefecture, :description
  
  def initialize url
    @url = url
    analize
  end
  
  def benkyoukai
    b = Benkyoukai.site(Benkyoukai::KOKUCHEESE).title(title).first
    unless b
      b = Benkyoukai.create(site:Benkyoukai::KOKUCHEESE, title:title, source_url:index_url, ics:ics, prefecture:prefecture)
    end
    b
  end

  private

  def analize
    @index_url, @title = get_index_url
    make_ical get_events
  end
  
  def get_events
    doc = Nokogiri::HTML(open(index_url))

    # イベントは.veventで取得できる
    doc.search(".vevent").map do |event_info|
    
      detail_url = event_info
          .search("a.article.summary").first["href"]
#p detail_url
#      get_event detail_url

      # 日付は.event_dateで取得
      a = event_info
          .search(".event_date").inner_text.gsub("\r\n", "")
          .scan(/(\d+)年(\d+)月(\d+)日/)
          .flatten
          .map{|e| e.to_i}
      date = Date.new(*a)
      
  
      name = event_info.search(".event_name").inner_text
      @prefecture = event_info.search("td.event_prefecture.location").inner_text
      description = event_info.search("td.event_description").inner_text.gsub("__", "")

      { date:date, name:name, description:description, prefecture:@prefecture }
    end
  end
  
  def get_event url
    doc = Nokogiri::HTML(open(url))
#p doc
    doc.search("table.indexTable").each do |table|
#p table
      table.search("tr").each do |tr|
        p tr.search("th").inner_text
        p tr.search("td").inner_text
      end
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
      e.description = event[:description]
      e.ip_class = "PRIVATE"
    end
    @ics = cal.to_ical
  end
  

end
