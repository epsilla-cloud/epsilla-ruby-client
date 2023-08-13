# frozen_string_literal: true

module Epsilla
  class Health < Base

    def live?
      response = client.connection.get do |req|
        req.url '/'
      end
      if response.status != 200
        raise Exception.new "[ERROR] Failed to connect to #{@url}"
      else
        true
      end
    end

    def state
      response = client.connection.get("/state")
      response.status == 200
    end
  end
end
