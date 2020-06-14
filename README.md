# Development environment for Prometheus and Grafana Demo

This example illustrates how to use [yabeda] gem suite with rails application to draw graphs for app metrics.

## Prerequisites

Recent versions of Docker and Docker Compose installed.

## Usage

- Execute `docker-compose up` to start.
- Go to rails application at http://localhost:5000
- Hit the button and refresh page few times
- Go to Grafana Web UI at [localhost](http://localhost:3000/d/000000001/yabeda-metrics-for-rails-sidekiq-and-puma?refresh=5s) (user: `admin`/`admin`)
- Look for graphs
- After starting up docker-compose will run `rails-stressor` service to simulate huge load for the rails app. By default will do the request for 2 minutes.
Settings could be changed in `docker-compose.yml` config (command parameter of the `rails_stressor` service).

You also could run rails stressor again by executing `docker-compose up rails_stressor` command.

## Notes

- Sample [Rails] application is equipped with [yabeda-rails], [yabeda-sidekiq], [yabeda-puma-plugin], and [yabeda-prometheus] gems and properly configured.
- Raw rails metrics are exposed at http://localhost:5000/metrics
- Raw sidekiq metrics are exposed at http://localhost:5100/metrics
- Raw puma metrics are exposed at http://localhost:5100/metrics
- The [Prometheus] Web UI runs at http://localhost:9090
- The [Grafana] Web UI runs at http://localhost:3000 , user: `admin`/`admin`.
- The [Sidekiq] Web UI is available at http://localhost:5000/sidekiq

## Acknowledgement

The Prometheus and Grafana goodies are from [yabeda-rb](https://github.com/yabeda-rb/example-prometheus) and the Evil Martians crew. This is also a great blog post on Yabeda on the [Evil Martian's blog](https://evilmartians.com/chronicles/meet-yabeda-modular-framework-for-instrumenting-ruby-applications).
