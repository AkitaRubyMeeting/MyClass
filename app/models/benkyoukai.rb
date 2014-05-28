class Benkyoukai < ActiveRecord::Base

  scope :site, lambda{|s| where("site = ?", s) }
  scope :title, lambda{|t| where("title = ?", t) }
  
  KOKUCHEESE = "kokucheese"
  
  class << self
  
    def supported_sites
      [
        ["こくちーず", KOKUCHEESE],
      ]
    end
    
    
    def benkyoukai_with_site_and_title site, title
      b = nil
      unless site.blank? || title.blank?
        b = Benkyoukai.site(site).title(title).first
        unless b
          case site
          when KOKUCHEESE
            k = Kokucheese.new "http://kokucheese.com/main/host/#{title}/"
            b = k.benkyoukai
          end
        end
      end
      b
    end
  

  end
      
end
