class DashboardsController < ApplicationController
  def index
    #TODO: check session
    @utorrent = Utorrent.new
  end
end
