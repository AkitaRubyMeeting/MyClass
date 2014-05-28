class CalendarController < ApplicationController
  
  def index
    @site = params["site"]
    @title = params["title"]
    @benkyoukai = nil
    unless @site.blank? || @title.blank?
      @benkyoukai = Benkyoukai.benkyoukai_with_site_and_title @site, @title
      if @benkyoukai
        @download_url = calendar_download_url(@benkyoukai.site, @benkyoukai.title.gsub(/\./, "%2E"), format:"ics")
      end
    end
    @sites = Benkyoukai.supported_sites
  end
  
  def make
    site = params["site"]
    title = params["title"]
    benkyoukai = Benkyoukai.benkyoukai_with_site_and_title site, title

    if benkyoukai
      redirect_to calendar_index_path site:benkyoukai.site, title:benkyoukai.title
    else
      redirect_to calendar_index_path(site:site, title:title), alert: "#{title}は見つかりませんでした"
    end
  end
  
  def download
    site = params["site"]
    title = params["title"]
    benkyoukai = Benkyoukai.benkyoukai_with_site_and_title site, title

    if benkyoukai
      render text: benkyoukai.ics
    else
      render text: nil #"該当する勉強会はありません。"
    end
  end
  
end
