require 'nokogiri'
require 'open-uri'
require 'date'

url = "http://kokucheese.com/main/host/Akita.m"
doc = Nokogiri::HTML(open(url))

events = []

# イベントは.veventで取得できる
doc.search(".vevent").each do |event_info|
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

end
