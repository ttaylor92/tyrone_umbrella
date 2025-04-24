defmodule GraphqlApiAssignment.Metrics.HashringCounter do
    @moduledoc false
    import Telemetry.Metrics, only: [distribution: 2]

    @event_prefix [:grapql_api]
    @distribution_event_name @event_prefix ++ [:hash_ring]
    @get_event_name @distribution_event_name ++ [:get]
    @put_event_name @distribution_event_name ++ [:put]
    @buckets PrometheusTelemetry.Config.default_millisecond_buckets()

    def metrics do
      [
        distribution(
          "grapql_api.hash_ring.get.duration.millisecond",
          event_name: @get_event_name,
          measurement: :duration,
          description: "Time to process counter get requests",
          reporter_options: [buckets: @buckets]
        ),
        distribution(
          "grapql_api.hash_ring.put.duration.millisecond",
          event_name: @put_event_name,
          measurement: :duration,
          description: "Time to process counter get requests",
          reporter_options: [buckets: @buckets]
        )
      ]
    end

    def inc_hash_ring_get_duration(duration) do
      :telemetry.execute(@get_event_name, %{duration: duration})
    end

    def inc_hash_ring_put_duration(duration) do
      :telemetry.execute(@put_event_name, %{duration: duration})
    end
end
