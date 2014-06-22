require 'test_helper'

class DoorkeeperTest < ActiveSupport::TestCase

  test "it should be able to initializedfrom url" do
    k = Doorkeeper.new "http://akitarubymeeting.doorkeeper.jp/events/9240"
    assert_equal ["akitarubymeeting", "Akita Ruby Meeting(秋田Rubyお楽しみ会)", "http://akitarubymeeting.doorkeeper.jp/"],
                 [k.group, k.title, k.url]
  end

  test "it should be able to initialize from title" do
    k = Doorkeeper.new "Akita Ruby Meeting"
    assert_equal ["akitarubymeeting", "Akita Ruby Meeting(秋田Rubyお楽しみ会)", "http://akitarubymeeting.doorkeeper.jp/"],
                 [k.group, k.title, k.url]
  end

  test "it should be able to initialize with benkyoukai" do
    k = Doorkeeper.new "http://akitarubymeeting.doorkeeper.jp/events/9240"
    b = k.benkyoukai
    k2 = Kokucheese.new b
    assert_not_nil k2
  end

  test "benkyoukai should get" do
    k = Doorkeeper.new "http://akitarubymeeting.doorkeeper.jp/events/9240"
    b = k.benkyoukai
    assert_equal ["doorkeeper", "Akita Ruby Meeting(秋田Rubyお楽しみ会)", "http://akitarubymeeting.doorkeeper.jp/"],
                 [b.site, b.title, b.source_url]
    assert_not_nil b.ics
  end

  test "benkyoukai should be unique" do
    k = Doorkeeper.new "Akita Ruby Meeting(秋田Rubyお楽しみ会)"
    c = Benkyoukai.all.count
    b = k.benkyoukai
    assert_equal c + 1, Benkyoukai.all.count
    
    k = Doorkeeper.new "Akita Ruby Meeting"
    b = k.benkyoukai

    assert_equal c + 1, Benkyoukai.all.count
  end

end
