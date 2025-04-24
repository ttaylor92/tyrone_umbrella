defmodule GraphqlApiAssignment.Metrics.TokenPipeline do
  @moduledoc false
  import Telemetry.Metrics, only: [distribution: 2, counter: 2]

  @event_prefix [:grapql_api]
  @distribution_event_name @event_prefix ++ [:token_generation]
  @counter_event_name @event_prefix ++ [:token_generation, :total]
  @buckets PrometheusTelemetry.Config.default_millisecond_buckets()

  def metrics do
    [
      distribution(
        "grapql_api.token_generation.duration.millisecond",
        event_name: @distribution_event_name,
        measurement: :duration,
        description: "Time to generate auth tokens",
        reporter_options: [buckets: @buckets]
      ),
      counter(
        "grapql_api.token_generationtotal.count",
        event_name: @counter_event_name,
        description: "Total generated auth tokens"
      )
    ]
  end

  def inc_total_count do
    :telemetry.execute(@counter_event_name, %{count: 1})
  end

  def inc_generate_session_token(duration) do
    :telemetry.execute(@distribution_event_name, %{duration: duration})
  end
end
