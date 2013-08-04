class SystemMetricsController < ApplicationController
  respond_to :json, :only => [:total_processes]

  def total_processes
    @metrics = SystemMetric.last
    respond_with [@metrics.proc_total]
  end

end
