# frozen_string_literal: true

require 'rdkafka'

module KafkaProducerWikimedia
  class Producer

    TOPIC = 'wikimedia.recentchange'

    def initialize(config)
      @config = config
    end

    def produce_from_stream
      kafka_config = {
        'bootstrap.servers' => config.bootstrap_server,
      }
      producer = Rdkafka::Config.new(kafka_config).producer
      delivery_handles = []
      i = 0

      loop do
        puts "producing message #{i}"
        delivery_handles << producer.produce(
          topic: TOPIC,
          payload: "test #{i}",
          key: "message_#{i}",
        )

        i += 1
        sleep 1
      end
    end

    def self.produce_from_stream
      new(KafkaProducerWikimedia.config).produce_from_stream
    end

    private

    attr_reader :config
  end
end
