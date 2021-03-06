defmodule Prometheus.Metric.Summary do
  @moduledoc """
  Summary metric, to track the size of events.

  Example use cases for Summaries:
    - Response latency;
    - Request size;
    - Response size.

  Example:

  ```
  defmodule MyProxyInstrumenter do

    use Prometheus.Metric

    ## to be called at app/supervisor startup.
    ## to tolerate restarts use declare.
    def setup() do
      Summary.declare([name: :request_size_bytes,
                       help: "Request size in bytes."])

      Summary.declare([name: :response_size_bytes,
                       help: "Response size in bytes."])
    end

    def observe_request(size) do
      Summary.observe([name: :request_size_bytes], size)
    end

    def observe_response(size) do
      Summary.observe([name: :response_size_bytes], size)
    end
  end
  ```

  """

  use Prometheus.Erlang, :prometheus_summary

  @doc """
  Creates a summary using `spec`.
  Summary cannot have a label named "quantile".

  Raises `Prometheus.MissingMetricSpecKeyError` if required `spec` key is missing.<br>
  Raises `Prometheus.InvalidMetricNameError` if metric name is invalid.<br>
  Raises `Prometheus.InvalidMetricHelpError` if help is invalid.<br>
  Raises `Prometheus.InvalidMetricLabelsError` if labels isn't a list.<br>
  Raises `Prometheus.InvalidMetricNameError` if label name is invalid.<br>
  Raises `Prometheus.InvalidValueError` exception if duration_unit is unknown or
  doesn't match metric name.<br>
  Raises `Prometheus.MFAlreadyExistsError` if a summary with the same `spec`
  already exists.
  """
  defmacro new(spec) do
    Erlang.call([spec])
  end

  @doc """
  Creates a summary using `spec`.
  Summary cannot have a label named "quantile".

  If a summary with the same `spec` exists returns `false`.

  Raises `Prometheus.MissingMetricSpecKeyError` if required `spec` key is missing.<br>
  Raises `Prometheus.InvalidMetricNameError` if metric name is invalid.<br>
  Raises `Prometheus.InvalidMetricHelpError` if help is invalid.<br>
  Raises `Prometheus.InvalidMetricLabelsError` if labels isn't a list.<br>
  Raises `Prometheus.InvalidMetricNameError` if label name is invalid;<br>
  Raises `Prometheus.InvalidValueError` exception if duration_unit is unknown or
  doesn't match metric name.
  """
  defmacro declare(spec) do
    Erlang.call([spec])
  end

  @doc """
  Observes the given amount.

  Raises `Prometheus.InvalidValueError` exception if `amount` isn't an integer.<br>
  Raises `Prometheus.UnknownMetricError` exception if a summary for `spec`
  can't be found.<br>
  Raises `Prometheus.InvalidMetricArityError` exception if labels count mismatch.
  """
  defmacro observe(spec, amount \\ 1) do
    Erlang.metric_call(spec, [amount])
  end

  @doc """
  Observes the given amount.
  If `amount` happened to be a float number even one time(!) you shouldn't use `observe/2`
  after dobserve.

  Raises `Prometheus.InvalidValueError` exception if `amount` isn't a number.<br>
  Raises `Prometheus.UnknownMetricError` exception if a summary for `spec`
  can't be found.<br>
  Raises `Prometheus.InvalidMetricArityError` exception if labels count mismatch.
  """
  defmacro dobserve(spec, amount \\ 1) do
    Erlang.metric_call(spec, [amount])
  end

  @doc """
  Observes the amount of seconds spent executing `fun`.

  Raises `Prometheus.UnknownMetricError` exception if a summary for `spec`
  can't be found.<br>
  Raises `Prometheus.InvalidMetricArityError` exception if labels count mismatch.
  Raises `Prometheus.InvalidValueError` exception if `fun` isn't a function or block.
  """
  defmacro observe_duration(spec, fun) do
    Erlang.metric_call(spec, [Erlang.ensure_fn(fun)])
  end

  @doc """
  Removes summary series identified by spec.

  Raises `Prometheus.UnknownMetricError` exception if a summary for `spec`
  can't be found.<br>
  Raises `Prometheus.InvalidMetricArityError` exception if labels count mismatch.
  """
  defmacro remove(spec) do
    Erlang.metric_call(spec)
  end

  @doc """
  Resets the value of the summary identified by `spec`.

  Raises `Prometheus.UnknownMetricError` exception if a summary for `spec`
  can't be found.<br>
  Raises `Prometheus.InvalidMetricArityError` exception if labels count mismatch.
  """
  defmacro reset(spec) do
    Erlang.metric_call(spec)
  end

  @doc """
  Returns the value of the summary identified by `spec`. If there is no summary for
  given labels combination, returns `:undefined`.

  If duration unit set, sum will be converted to the duration unit.
  [Read more here.](time.html)

  Raises `Prometheus.UnknownMetricError` exception if a summary for `spec`
  can't be found.<br>
  Raises `Prometheus.InvalidMetricArityError` exception if labels count mismatch.
  """
  defmacro value(spec) do
    Erlang.metric_call(spec)
  end
end
