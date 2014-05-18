class Benkyoukai < ActiveRecord::Base

  scope :site, lambda{|s| where("site = ?", s) }
  scope :title, lambda{|t| where("title = ?", t) }
  
  KOKUCHEESE = "kokucheese"
  
end
