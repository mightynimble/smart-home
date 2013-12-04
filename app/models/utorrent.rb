require 'net/http'
require 'json'

class Utorrent
  INFO_HASH = {
      :hash => 0,
      :status => 1,
      :name => 2,
      :size => 3,
      :percent_progress => 4,
      :downloaded => 5,
      :uploaded => 6,
      :ratio => 7,
      :upload_speed => 8,
      :download_speed => 9,
      :ETA => 10,
      :label => 11,
      :peers_connected => 12,
      :peers_in_swarm => 13,
      :seeds_connected => 14,
      :seeds_in_swarm => 15,
      :availability => 16,
      :torrent_queue_order => 17,
      :remaining => 18
  }

  STATUS_HASH ={
      :started => 1,
      :checking => 2,
      :start_after_check => 4,
      :checked => 8,
      :error => 16,
      :paused => 32,
      :queued => 64,
      :loaded => 128
  }

  def initialize
    @token = get_token if @token.nil?
  end

  def list
    list = get("?list=1&token=#{@token[:token]}", @token[:cookies])
    JSON.parse(list)
  end

  def name (item)
    item[INFO_HASH[:name]]
  end

  def size (item)
    size_in_byte = item[INFO_HASH[:size]]
    size = convert_bytes(size_in_byte)
    size
  end

  def status(item)
    status_code = item[INFO_HASH[:status]]
    if percent(item) == 100
      status = 'completed'
    elsif (status_code & STATUS_HASH[:error]) == STATUS_HASH[:error]
      status = '<i class="icon-ok-circle" /> error'
    elsif (status_code & STATUS_HASH[:paused]) == STATUS_HASH[:paused]
      status = 'paused'
    elsif (status_code & STATUS_HASH[:started]) == STATUS_HASH[:started]
      status = 'started'
    else
      status = 'stopped'
    end

    status
  end

  def speed(item)
    if status(item) == 'started'
      speed_in_byte = item[INFO_HASH[:download_speed]]
    else
      speed_in_byte = 0
    end
    speed = convert_bytes(speed_in_byte)
    speed
  end

  def percent(item)
    item[INFO_HASH[:percent_progress]]/10
  end

  def eta(item)
    if status(item) == 'started'
      convert_seconds(item[INFO_HASH[:ETA]])
    else
      'N/A'
    end
  end

  def label(item)
    item[INFO_HASH[:label]]
  end

  def connections(item)
    "s:#{item[INFO_HASH[:seeds_connected]]}/#{item[INFO_HASH[:seeds_in_swarm]]} p:#{item[INFO_HASH[:peers_connected]]}/#{item[INFO_HASH[:peers_in_swarm]]}"
  end

  private

  def convert_seconds(sec)
    if sec < 60
      value = "0:00:#{sec}"
    elsif sec < 3600 && sec >= 60
      value = "0:#{sec/60}:#{sec%60}"
    elsif sec < 86400 && sec >= 3600
      value = "#{sec/3600}:#{(sec-sec/3600*3600)/60}:#{sec%60}"
    else
      value = "> 1d"
    end
    value
  end


  def convert_bytes(byte)
    if byte < 1024
      value = "#{byte} B"
    elsif byte < 1048576 && byte >= 1024 #1024^2
      tmp = sprintf "%.2f", byte.to_f/1024.0
      value = "#{tmp} KB"
    elsif byte < 1073741824 && byte >= 1048576
      tmp = sprintf "%.2f", byte.to_f/1048576.0
      value = "#{tmp} MB"
    elsif byte < 1099511627776 && byte >= 1073741824
      tmp = sprintf "%.2f", byte.to_f/1073741824.0
      value = "#{tmp} GB"
    end
    value
  end

  def get_token
    result = get('token.html')
    response = {}
    response[:token] = result.body.gsub(%r{</?[^>]+?>}, '')
    response[:cookies] = result.cookies
    response
  end

  def get(url, cookies = nil)
    RestClient::Request.new(
        :method => :get,
        :url => "#{APP_CONFIG['utorrent_url_prefix']}/#{url}",
        :user => APP_CONFIG['utorrent_user'],
        :password => APP_CONFIG['utorrent_password'],
        :cookies => cookies
    ).execute
  end
end