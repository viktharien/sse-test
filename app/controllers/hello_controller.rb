class HelloController < ApplicationController
  include ActionController::Live
  def ticker
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Ticker::SSE.new(response.stream)
    begin
      loop do
        if Transaction.content.changed?
          sse.write({ time: Time.now })
          sleep 2
        else
          sse.write({ time: Time.now })
          sleep 2
        end
        sleep 2
      end
    rescue IOError
      logger.info 'Client disconnects causes IOError on write'
    ensure
      sse.close
    end
  end
end
