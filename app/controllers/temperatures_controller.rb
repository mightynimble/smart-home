class TemperaturesController < ApplicationController
  respond_to :json, :only => [:get_metrics]

  def index
    @temperatures = Temperature.all
  end

  def get_metrics
    @temperatures = params[:time_span] ? Temperature.send(params[:time_span]) : Temperature.last_60_minutes
    respond_with @temperatures
  end
end
