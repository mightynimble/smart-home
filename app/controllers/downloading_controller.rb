class DownloadingController < ApplicationController
  respond_to :json, :only => [:all, :active]

  def active
    torrents = Utorrent.new
    filtered_results = nil
    torrents.list['torrents'].each do |item|
      unless torrents.status(item).eql? 'completed'
        filtered_results << item
      end
    end
    respond_with [filtered_results]
  end

  def all
    torrents = Utorrent.new
    filtered_results = nil
    torrents.list['torrents'].each do |item|
      filtered_results << item
    end
    respond_with [filtered_results]
  end
end
