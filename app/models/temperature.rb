class Temperature < ActiveRecord::Base
  attr_accessible :device, :inserted, :temperature

  def self.find_time_span(number, unit, *args, &block)
    case unit
      when 'days', 'day', 'd'
        history_metrics(number * 60 * 24)
      when 'hours', 'hour', 'hr', 'h'
        history_metrics(number * 60)
      when 'minutes', 'minute', 'min', 'm'
        history_metrics(number)
      else
        nil
    end
  end

  def self.last_60_minutes
    history_metrics(60)
  end

  def self.history_metrics(minutes)
    temps = Temperature.where("inserted > ?", (Time.now - minutes.minutes).strftime("%F %T"))
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
            cpu_1_core<<t.temperature
          when APP_CONFIG['temp_cpu_2_core']
            cpu_2_core<<t.temperature
          when APP_CONFIG['temp_hd']
            hd<<t.temperature
          when APP_CONFIG['temp_cpu_1_diode']
            cpu_1_diode<<t.temperature
          when APP_CONFIG['temp_cpu_2_diode']
            cpu_2_diode<<t.temperature
          when APP_CONFIG['temp_heat_sink']
            heat_sink<<t.temperature
          when APP_CONFIG['temp_logic_board']
            logic_board<<t.temperature
        end
      end
    end

    response = [{:name => 'CPU Core 1', :type => 'line', :data => cpu_1_core, :visible => true, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
                {:name => 'CPU Core 2', :type => 'line', :data => cpu_2_core, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
                {:name => 'Hard Disk', :type => 'line', :data => hd, :visible => true, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
                {:name => 'CPU Diode 1', :type => 'line', :data => cpu_1_diode, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
                {:name => 'CPU Diode 2', :type => 'line', :data => cpu_2_diode, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
                {:name => 'Heat Sink', :type => 'line', :data => heat_sink, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000},
                {:name => 'Logical Board', :type => 'line', :data => logic_board, :visible => false, :pointInterval => 1.minute * 1000, :pointStart => 1.hour.ago.to_i * 1000}].to_json
    response
  end

  private

  def method_missing(meth, *args, &block)
    if meth.to_s =~ /^last_(\d+)_(.+)$/
      find_time_span($1, $2, *args, &block)
    else
      super
    end
  end
end
