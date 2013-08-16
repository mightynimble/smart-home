require 'net/http'
require 'json'

class Utorrent

  def initialize
    @token = get_token if @token.nil?
  end

  def list
    list = get("?list=1&token=#{@token[:token]}", @token[:cookies])
    JSON.parse(list)
  end

  private

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