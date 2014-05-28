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
      begin
        unless site.blank? || title.blank?
          b = Benkyoukai.site(site).title(title).first
          unless b
            case site
            when KOKUCHEESE
              k = Kokucheese.new title
              b = k.benkyoukai
            end
          end
        end
      rescue
        b = nil
      end
      b
    end
  

  end
      
end
