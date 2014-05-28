require 'test_helper'

class BenkyoukaiTest < ActiveSupport::TestCase

  test "benkyoukai_with_site_and_title should get Akita.m" do
    b = Benkyoukai.benkyoukai_with_site_and_title Benkyoukai::KOKUCHEESE, "Akita.m"
    assert_equal "Akita.m", b.title
  end

  test "benkyoukai_with_site_and_title should not get HogeFuga" do
    b = Benkyoukai.benkyoukai_with_site_and_title Benkyoukai::KOKUCHEESE, "Akitam"
    assert_nil b
  end

end
