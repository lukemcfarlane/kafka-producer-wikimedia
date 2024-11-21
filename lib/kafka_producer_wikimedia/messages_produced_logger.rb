# frozen_string_literal: true

module KafkaProducerWikimedia
  class MessagesProducedLogger
    def initialize
      @count = 0
    end

    def increment!
      @count += 1
      print_messages_produced
    end

    private

    attr_reader :count

    def print_messages_produced
      print "\rMessages produced: #{count}"
    end
  end
end
