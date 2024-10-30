# frozen_string_literal: true

module KafkaProducerWikimedia
  class Producer
    def initialize(config)
      @config = config
    end

    def produce_from_stream
      puts config.bootstrap_server
    end

    def self.produce_from_stream
      new(KafkaProducerWikimedia.config).produce_from_stream
    end

    private

    attr_reader :config
  end
end
