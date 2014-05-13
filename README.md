# Akita Ruby Meeting #8 (2014/5/13)


## 今日の目標

Akita.m のイベントをこくちーずから拾ってiCal形式にする。
将来的にはサーバー経由で取得できるようにしてARM等も組込んで行く。

## Gemfile作成

```sh
$ bundle init
```

## Nokogiri

HTMLの解析をするgem。
Agentとしてブラウザの代わりにクロールしたりできる。

[Nokogiri](http://nokogiri.org)

```Gemfile
gem 'nokogiri'
```

1.6.2ではlibiconvエラーでインストールできず。

```sh
$ bundle
  .
  .
-----
libiconv is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.
-----
*** extconf.rb failed ***
  .
  .
An error occurred while installing nokogiri (1.6.2), and Bundler cannot
continue.
Make sure that `gem install nokogiri -v '1.6.2'` succeeds before bundling.
```

1.6.1ならインストールできた。

参照:
[Install Nokogiri 1.6.1 under Ruby 2.0.0p353 (rvm based installation) fails (OSX Mavericks)?](http://stackoverflow.com/questions/20890808/install-nokogiri-1-6-1-under-ruby-2-0-0p353-rvm-based-installation-fails-osx)

```sh
gem install nokogiri -v '1.6.1'
Fetching: nokogiri-1.6.1.gem (100%)
Building native extensions.  This could take a while...
Successfully installed nokogiri-1.6.1
1 gem installed
```

バージョン指定に変更

```Gemfile
gem "nokogiri", "1.6.1"
```


## パース

こくちーずからAkita.mのイベントを取得する

- .vevent で切り出す。
	- .event_date で日付を取得できる
	- .event_name でタイトルを取得できる

```myclass2ical.rb
def get_akitam_events
  url = "http://kokucheese.com/main/host/Akita.m"
  doc = Nokogiri::HTML(open(url))

  events = []

  # イベントは.veventで取得できる
  doc.search(".vevent").each do |event_info|
    event = {}
    events << event
  
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
  events
end
```

## iCal形式に変換

[iCalendar](https://github.com/icalendar/icalendar)を使用

Gemfileに追加

```Gemfile
gem "icalendar"
```

```sh
$ bundle
```

```myclass2ical.rb
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
```

## icsファイルに書き出し
```myclass2ical.rb
s = make_ical get_akitam_events
File.open("akitam.ics", "w"){|f| f.write(s)}
```

## 実行

```sh
$ ruby myclass2ical.rb
```

akitam.icsが生成される。
ダブルクリックでiCalに反映される。

将来的にはサーバー経由で取得できる様にする。
