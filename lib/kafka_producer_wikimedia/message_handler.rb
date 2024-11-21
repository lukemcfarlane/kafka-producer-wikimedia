# frozen_string_literal: true

require_relative 'messages_produced_logger'

module KafkaProducerWikimedia
  class MessageHandler
    def initialize(producer, topic)
      @producer = producer
      @topic = topic
    end

    def call(message)
      producer.produce(
        topic: topic,
        payload: message,
        key: nil,
      )
      messages_produced_logger.increment!
    end

    private

    attr_reader :producer, :topic

    def messages_produced_logger
      @messages_produced_logger ||= MessagesProducedLogger.new
    end
  end
end
