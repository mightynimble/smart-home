class TemperaturesController < ApplicationController
  respond_to :json, :only => [:get_metrics]

  def index
    @temperatures = Temperature.all
  end

  def get_metrics

    @temperatures = params[:method] ? Temperature.send(params[:method], params[:interval].to_i) : Temperature.last_60_minutes
    respond_with @temperatures
  end
end
