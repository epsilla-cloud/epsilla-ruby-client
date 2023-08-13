# frozen_string_literal: true

require "faraday"


module Epsilla
  class Client
    attr_reader :protocol, :host, :port, :adapter, :debug
  
    def self.welcome
      puts "WELCOME To EPSILLA VECTOR DATABASE!"
    end

    def initialize(protocol, host, port, adapter: Faraday.default_adapter, debug: false)
      @url = "#{protocol}://#{host}:#{port}"
      @adapter = adapter
      @debug = debug
    end
  
  
    def connection
      @conn ||= Faraday.new(url: "#{@url}", request: { timeout: 30 }) do |faraday|
        faraday.request :json
        faraday.response :logger if @debug
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter @adapter
        faraday.options.timeout = 30 # 30s
        faraday.options.open_timeout = 30 # 30s
        faraday.headers['Content-type'] = 'application/json'
      end
    end
  
    def live?
      @health ||= Epsilla::Health.new(client: self)
      @health.live?
    end

    def state
      @health ||= Epsilla::Health.new(client: self)
      @health.state
    end

    def database
      @database ||= Epsilla::DataBase.new(client: self)
    end
    
  end
end
