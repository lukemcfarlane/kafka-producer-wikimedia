# frozen_string_literal: true

module KafkaProducerWikimedia
  class MessageHandler
    def initialize(producer, topic)
      @producer = producer
      @topic = topic
    end

    def call(message)
      puts "producing message: #{message}"
      producer.produce(
        topic: topic,
        payload: message,
        key: nil,
      )
    end

    private

    attr_reader :producer, :topic
  end
end
