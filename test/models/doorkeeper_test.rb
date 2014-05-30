require 'test_helper'

class DoorkeeperTest < ActiveSupport::TestCase

  test "index url should " do
    k = Doorkeeper.new "http://akitarubymeeting.doorkeeper.jp/events/9240"
    assert_equal ["akitarubymeeting", "Akita Ruby Meeting(秋田Rubyお楽しみ会)", "http://akitarubymeeting.doorkeeper.jp/"],
                 [k.group, k.title, k.url]
  end

  test "benkyoukai should get" do
    k = Doorkeeper.new "http://akitarubymeeting.doorkeeper.jp/events/9240"
    b = k.benkyoukai
    assert_equal ["doorkeeper", "Akita Ruby Meeting(秋田Rubyお楽しみ会)", "http://akitarubymeeting.doorkeeper.jp/"],
                 [b.site, b.title, b.source_url]
    assert_not_nil b.ics
  end

  test "it should be able to initialize with benkyoukai" do
    k = Doorkeeper.new "http://akitarubymeeting.doorkeeper.jp/events/9240"
    b = k.benkyoukai
    k2 = Kokucheese.new b
    assert_not_nil k2
  end

end
