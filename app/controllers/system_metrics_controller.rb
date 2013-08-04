class SystemMetricsController < ApplicationController
  respond_to :json, :only => [:total_processes, :total_cpu]

  def total_processes
    @metrics = SystemMetric.last
    respond_with [@metrics.proc_total]
  end

  def total_cpu
    @metrics = SystemMetric.last
    respond_with [@metrics.cpu_user + @metrics.cpu_sys]
  end
end
