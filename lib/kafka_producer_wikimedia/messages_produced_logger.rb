# frozen_string_literal: true

module KafkaProducerWikimedia
  class MessagesProducedLogger
    def initialize
      @count = 0
      @timestamps = [] # Stores timestamps of recent messages
      @start_time = Time.now # Track when logging started
    end

    def increment!
      @count += 1
      record_timestamp
      print_status
    end

    private

    attr_reader :count, :timestamps, :start_time

    def record_timestamp
      now = Time.now
      @timestamps << now

      # Remove timestamps older than 60 seconds
      @timestamps.reject! { |t| t <= now - 60 }
    end

    def calculate_rate
      now = Time.now
      elapsed_time = now - start_time

      if elapsed_time < 60
        # Extrapolate rate for the first minute
        (count / elapsed_time).round
      else
        # Use message count from the last 60 seconds
        (timestamps.size / 60.0).round
      end
    end

    def print_status
      rate = calculate_rate
      print "\rMessages produced: #{count} (#{rate}/sec)"
    end
  end
end
