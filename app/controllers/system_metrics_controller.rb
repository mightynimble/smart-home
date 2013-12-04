class SystemMetricsController < ApplicationController
  respond_to :json, :only => [:total_processes, :total_cpu, :mem_usage]

  def total_processes
    @metrics = SystemMetric.last
    respond_with [@metrics.proc_total]
  end

  def total_cpu
    @metrics = SystemMetric.last
    respond_with [(@metrics.cpu_user + @metrics.cpu_sys).to_i]
  end

  def mem_usage
    @metrics = SystemMetric.last
    if @metrics.mem_wired[-1] == 'M' && @metrics.mem_active[-1] == 'M' && @metrics.mem_inactive[-1] == 'M'
      respond_with [
                       ['Wired', @metrics.mem_wired[0..-2].to_i],
                       ['Active', @metrics.mem_active[0..-2].to_i],
                       ['Inactive', @metrics.mem_inactive[0..-2].to_i],
                       ['Free', 16 * 1024 - @metrics.mem_used[0..-2].to_i],

                   ]
    else
      # TODO: convert 'KB' to 'MB'
      nil
    end
  end
end
