require 'test_helper'

class KokucheeseTest < ActiveSupport::TestCase

  test "index url should " do
    k = Kokucheese.new "http://kokucheese.com/event/index/169542/"
    assert_equal "http://kokucheese.com/main/host/Akita.m/" ,k.index_url
    assert_equal "Akita.m", k.title
    assert_not_nil k.ics
  end

  test "benkyoukai should get" do
    k = Kokucheese.new "http://kokucheese.com/event/index/169542/"
    b = k.benkyoukai
    assert_equal "kokucheese", b.site
    assert_equal "Akita.m", b.title
    assert_equal "http://kokucheese.com/main/host/Akita.m/", b.source_url
    assert_not_nil b.ics
  end

  test "it should get by title" do
    k = Kokucheese.new "Akita.m"
    assert_equal "http://kokucheese.com/main/host/Akita.m/" ,k.index_url
    assert_equal "Akita.m", k.title
    assert_not_nil k.ics
  end

end
