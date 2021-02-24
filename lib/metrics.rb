class Metrics
  def initialize
    @prometheus = Prometheus::Client.registry
    @counter = @prometheus.counter(:photos_processed, docstring: "A counter of Google photos media items processed.")
    @run = @prometheus.counter(:photos_successrul_run, docstring: "A counter of Google photos media items processed.")
  end

  def count_success
    @counter.increment
  end

  def log_successful_run
    @run.increment
  end

  def sync
    r = Prometheus::Client::Push.new("push-photos", nil, ENV["PUSHGATEWAY_URL"]).add(@prometheus)
    puts r
  end
end
