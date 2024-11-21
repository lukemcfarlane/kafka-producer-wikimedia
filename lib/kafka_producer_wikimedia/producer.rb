# frozen_string_literal: true

module KafkaProducerWikimedia
  class Producer

    TOPIC = 'wikimedia.recentchange'
    STREAM_URL = 'https://stream.wikimedia.org/v2/stream/recentchange'
    INT32_MAX = (2**31 - 1).freeze

    def initialize(config)
      @config = config
      # Reference: https://github.com/confluentinc/librdkafka/blob/master/CONFIGURATION.md
      @kafka_config = {
        'bootstrap.servers' => config.bootstrap_server,
        'enable.idempotence' => true,
        'acks' => 'all',
        'retries' => INT32_MAX,
        'linger.ms' => 20,
        'batch.size' => 32 * 1024, # 32
        'debug' => 'conf',
        'compression.type' => 'snappy',
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
