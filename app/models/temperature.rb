class Temperature < ActiveRecord::Base
  attr_accessible :device, :inserted, :temperature

  def self.find_time_span(number, unit, *args, &block)
    case unit
      when 'days', 'day', 'd'
        history_metrics(number.to_i * 60 * 24, 'd')
      when 'hours', 'hour', 'hr', 'h'
        history_metrics(number.to_i * 60, 'h')
      when 'minutes', 'minute', 'min', 'm'
        history_metrics(number.to_i, 'm')
      else
        nil
    end
  end

  def self.last_60_minutes
    history_metrics(60, 'm')
  end

  #
  # interval: integer - in minutes
  #           Given the chart displays 60 points max, an interval of 5 means sample temperature every 5 minutes in the
  #           last 3 hours. Every minute, there are 7 temperature metrics being inserted into db. Therefore, we need to
  #           retrieve 7x5x60=2100 metrics from db if interval is 5 minutes.
  def self.init_chart(interval)
    temps =  Temperature.where('device = ? AND inserted > ?', 'CPU Core 1', (Time.now - (interval*30).minutes).strftime("%F %T")).reverse
    # for now return only cpu 1 temperature
    cpu_1_core = []

    # this temporary array holds records whose temperature will be averaged later
    sub_temp = 0
    i = 0
    while !temps.blank?
      t = temps.pop
      case t.device
        when APP_CONFIG['temp_cpu_1_core']
          if i < interval - 1
            sub_temp = sub_temp + t.temperature
            i = i + 1
          else
            sub_temp = (sub_temp + t.temperature) / interval
            cpu_1_core<<[t.inserted.to_i * 1000, sub_temp]
            i = 0
            sub_temp = 0
          end
      end
    end

    cpu_1_core.to_json
    #response = {:name => 'CPU Core 1', :type => 'line', :data => cpu_1_core, :visible => true, :pointInterval => pointInterval}.to_json
    #response
  end

  def self.history_metrics(minutes, unit='m')
    pointInterval = 1.minute * 1000
    if unit.eql? 'd'
      pointInterval = 1.hour * 1000
    elsif unit.eql? 'h'
      pointInterval = 1.minute * 1000
    end

    temps = Temperature.where("inserted > ?", (Time.now - 61.second).strftime("%F %T"))
    #pointStart = temps.first.inserted.to_datetime.to_i * 1000
    cpu_1_core = []
    cpu_2_core = []
    hd = []
    cpu_1_diode = []
    cpu_2_diode = []
    heat_sink = []
    logic_board = []
    if temps
      temps.each do |t|
        case t.device
          when APP_CONFIG['temp_cpu_1_core']
            cpu_1_core<<[t.inserted.to_i * 1000, t.temperature]
          when APP_CONFIG['temp_cpu_2_core']
            cpu_2_core<<[t.inserted.to_i * 1000, t.temperature]
          when APP_CONFIG['temp_hd']
            hd<<[t.inserted.to_i * 1000, t.temperature]
          when APP_CONFIG['temp_cpu_1_diode']
            cpu_1_diode<<[t.inserted.to_i * 1000, t.temperature]
          when APP_CONFIG['temp_cpu_2_diode']
            cpu_2_diode<<[t.inserted.to_i * 1000, t.temperature]
          when APP_CONFIG['temp_heat_sink']
            heat_sink<<[t.inserted.to_i * 1000, t.temperature]
          when APP_CONFIG['temp_logic_board']
            logic_board<<[t.inserted.to_i * 1000, t.temperature]
        end
      end
    end

    #response = [{:name => 'CPU Core 1', :type => 'line', :data => cpu_1_core, :visible => true, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
    #            {:name => 'CPU Core 2', :type => 'line', :data => cpu_2_core, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
    #            {:name => 'Hard Disk', :type => 'line', :data => hd, :visible => true, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
    #            {:name => 'CPU Diode 1', :type => 'line', :data => cpu_1_diode, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
    #            {:name => 'CPU Diode 2', :type => 'line', :data => cpu_2_diode, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
    #            {:name => 'Heat Sink', :type => 'line', :data => heat_sink, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
    #            {:name => 'Logical Board', :type => 'line', :data => logic_board, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000}].to_json
    #response = {:name => 'CPU Core 1', :type => 'line', :data => cpu_1_core, :visible => true}.to_json #, :pointInterval => pointInterval}.to_json
    #response
    cpu_1_core.to_json
  end

  def self.method_missing(meth, *args, &block)
    if meth.to_s =~ /^every_(\d+)_(.+)$/
      find_time_span($1, $2, *args, &block)
    elsif meth.to_s =~ /^init_chart$/
      init_chart(args[0])
    else
      super
    end
  end
end
