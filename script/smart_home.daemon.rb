#!/usr/bin/ruby

require 'mysql'
require 'logger'

#
# Constants
#
devices = ['CPU Core 1', 'CPU Core 3', 'SMART Disk SanDisk SDSSDX120GG25 (130810401622)', 
	'SMC MAIN HEAT SINK 1', 'SMC MAIN LOGIC BOARD', 'SMC CPU A DIODE', 'SMC CPU B DIODE']

sys_info_cmd = "top -l3 | egrep '^[A-Z].+:.+' | tail -9"

interval = 5

#
# Global variables
#
connection = Mysql.new("localhost", 'root', '123!@#qweQWE', 'smarthome')
logger = Logger.new('/Users/server/code/smart-home-api/logs/smart-home.log', File::WRONLY | File::APPEND)
logger.datetime_format = '%Y-%m-%d %H:%M:%S,%L'
logger.formatter = proc do |severity, datetime, progname, msg|
	"#{datetime.strftime(logger.datetime_format)} #{severity} smart_home.daemon.rb - #{msg}\n"
end

#
# Main logic
#
logger.info("smart_home.daemon.rb started up... ")	

while 1 do
	# get temperatures
	cmd_outs = `/Applications/TemperatureMonitor.app/Contents/MacOS/tempmonitor -a -l`
	temps = cmd_outs.split(/\n/)
	temps.each do |t|
		name = t.split(/:/)[0]
		is_match = t.split(/:/)[1].match(/\s+(\d+)\s+.*/)
		is_match ? value = is_match[1] : value = ""

		unless value.empty?
			if devices.include? name
				now = Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")
				begin 
					connection.query("INSERT INTO temperatures (device, temperature, inserted) VALUES ('#{name}', #{value.to_i}, '#{now}')")
				rescue Mysql::Error => e
					logger.error("Failed to insert record to database.#{e.inspect}")
					logger.error("Operation failed: INSERT INTO temperatures (device, temperature, inserted) VALUES ('#{name}', #{value.to_i}, '#{now}')")
				end
			end
		end
	end

	# get system info every FIVE minutes	
	if interval != 0
		interval = interval - 1
	else
		interval = 5
		sys_info = `#{sys_info_cmd}`
		items = sys_info.split(/\n/)
		metrics = {}
		items.each do |i|
			key = i.split(/:/, 2)[0]
			value = i.split(/:/, 2)[1]
			case key
			when "Processes"
				proc_types = value.match(/\s+(\d+) total, (\d+) running, (\d+) stuck, (\d+) sleeping, (\d+) threads.*/)
				metrics[:proc_total] = proc_types[1]
				metrics[:proc_running] = proc_types[2]
				metrics[:proc_stuck] = proc_types[3]
				metrics[:proc_sleeping] = proc_types[4]
				metrics[:proc_threads] = proc_types[5]
			when "CPU usage"
				usage_types = value.match(/\s+(\d+\.\d+)% user, (\d+\.\d+)% sys.+/)
				metrics[:cpu_user] = usage_types[1]
				metrics[:cpu_sys] = usage_types[2]
			when "PhysMem"
				mem_types = value.match(/\s+(\d+.) wired, (\d+.) active, (\d+.) inactive, (\d+.) used.+/)
				metrics[:mem_wired] = mem_types[1]
				metrics[:mem_active] = mem_types[2]
				metrics[:mem_inactive] = mem_types[3]
				metrics[:mem_used] = mem_types[4]
			when "Networks"
				net_types = value.match(/.+:\s(\d+)\/(\d+.) in, (\d+)\/(\d+.) out.*/)
				metrics[:net_in_pkt] = net_types[1]
				metrics[:net_in_data] = net_types[2]
				metrics[:net_out_pkt] = net_types[3]
				metrics[:net_out_data] = net_types[4]
			when "Disks"
				disk_types = value.match(/.+\/(\d+.) read.+\/(\d+.) written.*/)
				metrics[:disk_read] = disk_types[1]
				metrics[:disk_write] = disk_types[2]
			end
		end
		inserted = Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")
		begin
			connection.query("INSERT INTO system_metrics (inserted, proc_total, proc_running, proc_stuck, proc_sleeping, proc_threads,
				cpu_user, cpu_sys, mem_wired, mem_active, mem_inactive, mem_used, net_in_pkt, net_in_data, net_out_pkt, net_out_data, 
				disk_read, disk_write) VALUES('#{inserted}', #{metrics[:proc_total]}, #{metrics[:proc_running]}, #{metrics[:proc_stuck]}, 
				#{metrics[:proc_sleeping]}, #{metrics[:proc_threads]}, #{metrics[:cpu_user]}, #{metrics[:cpu_sys]}, '#{metrics[:mem_wired]}',
				'#{metrics[:mem_active]}', '#{metrics[:mem_inactive]}', '#{metrics[:mem_used]}', #{metrics[:net_in_pkt]}, '#{metrics[:net_in_data]}',
				#{metrics[:net_out_pkt]}, '#{metrics[:net_out_data]}', '#{metrics[:disk_read]}', '#{metrics[:disk_write]}')")
		rescue Mysql::Error => e
			logger.error("Failed to insert record to database.#{e.inspect}")
			logger.error("INSERT INTO system_metrics (inserted, proc_total, proc_running, proc_stuck, proc_sleeping, proc_threads,
				cpu_user, cpu_sys, mem_wired, mem_active, mem_inactive, mem_used, net_in_pkt, net_in_data, net_out_pkt, net_out_data, 
				disk_read, disk_write) VALUES('#{inserted}', #{metrics[:proc_total]}, #{metrics[:proc_running]}, #{metrics[:proc_stuck]}, 
				#{metrics[:proc_sleeping]}, #{metrics[:proc_threads]}, #{metrics[:cpu_user]}, #{metrics[:cpu_sys]}, '#{metrics[:mem_wired]}',
				'#{metrics[:mem_active]}', '#{metrics[:mem_inactive]}', '#{metrics[:mem_used]}', #{metrics[:net_in_pkt]}, '#{metrics[:net_in_data]}',
				#{metrics[:net_out_pkt]}, '#{metrics[:net_out_data]}', '#{metrics[:disk_read]}', '#{metrics[:disk_write]}')")
		end
	end	

	sleep (60)
end