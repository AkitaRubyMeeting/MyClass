class Benkyoukai < ActiveRecord::Base

  scope :site, lambda{|s| where("site = ?", s) }
  scope :title, lambda{|t| where("title = ?", t) }
  
  KOKUCHEESE = "kokucheese"
  DOORKEEPER = "doorkeeper"
  
  class << self
  
    def supported_sites
      [
        ["こくちーず", KOKUCHEESE],
        ["Doorkeeper", DOORKEEPER],
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
            when DOORKEEPER
              d = Doorkeeper.new title
              b = d.benkyoukai
            end
          end
        end
      rescue => e
p e
        b = nil
      end
      b
    end
  

    def update_all
      Benkyoukai.all.each do |b|
        b.update
      end
    end

  end
      

  def update
    service.new(self).update
  end


  private

    def service
      case site
      when KOKUCHEESE
        Kokucheese
      else
        nil
      end
    end
end
