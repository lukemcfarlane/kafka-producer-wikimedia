# Kafka Producer Wikimedia

This Ruby application streams recent change data from Wikimedia and publishes it to a Kafka topic. It was developed as part of the [Udemy Apache Kafka](https://www.udemy.com/course/apache-kafka/) course.

## Features

- Reads real-time Wikimedia change data using their event stream.
- Publishes the streamed data to a specified Kafka topic for further processing.

## Prerequisites

- Ruby (ensure the correct version is installed based on the project's `Gemfile`)
- Kafka broker running and accessible
- Environment variables properly configured (see `.env.example`)

## Installation

1. Clone repository:
```
git clone git@github.com:lukemcfarlane/kafka-producer-wikimedia.git
cd kafka-producer
```
2. Bundle install:
```
bundle install
```

## Usage

```
bin/produce
```
