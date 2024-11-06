# frozen_string_literal: true

module KafkaProducerWikimedia
  class Producer

    TOPIC = 'wikimedia.recentchange'
    STREAM_URL = 'https://stream.wikimedia.org/v2/stream/recentchange'

    def initialize(config)
      @config = config
      @kafka_config = {
        'bootstrap.servers' => config.bootstrap_server,
      }
    end

    def produce_from_stream
      begin
        sse_client = SSE::Client.new(STREAM_URL) do |client|
          client.on_event do |event|
            message_handler.call(event.data) if event.type == :message
          end

          client.on_error do |error|
            puts "Error received: #{error}"
          end
        end

        # Block the main thread to keep the SSE connection open
        sleep
      ensure
        sse_client.close if sse_client
        puts "SSE connection closed."
      end
    end

    def self.produce_from_stream
      new(KafkaProducerWikimedia.config).produce_from_stream
    end

    private

    attr_reader :config, :kafka_config

    def producer
      @producer ||= Rdkafka::Config.new(kafka_config).producer
    end

    def message_handler
      @message_handler ||= MessageHandler.new(producer, TOPIC)
    end
  end
end
