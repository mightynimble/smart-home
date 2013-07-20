class SystemMetric < ActiveRecord::Base
  attr_accessible :cpu_sys, :cpu_user, :disk_read, :disk_write, :inserted, :mem_active, :mem_inactive, :mem_used, :mem_wired, :net_in_data, :net_in_pkt, :net_out_data, :net_out_pkt, :proc_running, :proc_sleeping, :proc_stuck, :proc_threads, :proc_total
end
