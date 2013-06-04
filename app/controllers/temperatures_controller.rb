class TemperaturesController < ApplicationController
  respond_to :json, :only => [:last_60_minutes]

  def index
    @temperatures = Temperature.all
  end

  def last_60_minutes
    @temperatures = Temperature.last_60_minutes
    respond_with @temperatures
  end
end
