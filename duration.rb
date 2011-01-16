# This code largely ripped off from Isaac Priestly's Natural Time gem, but
# without the external dependency and stripped down somewhat.
# See: https://github.com/progressions/natural_time

class Duration
  attr_accessor :duration, :past, :elapsed_time

  UNITS_OF_TIME = [["year", "years"], ["month", "months"], ["week", "weeks"], ["day", "days"], ["hour", "hours"], ["minute", "minutes"]]

  def initialize(duration_in_seconds, options={})
    duration_in_seconds = duration_in_seconds.to_i
    @past = duration_in_seconds < 1
    @duration = duration_in_seconds.abs
    @elapsed_time = calculate_elapsed_time(duration)
  end

  def to_sentence
    elapsed_time.compact.first
  end

  def distance
    if past
      modifier = "ago"
    else
      modifier = "from now"
    end
    "#{to_sentence} #{modifier}"
  end

  def calculate_elapsed_time(duration_in_seconds)
    elapsed_time = []

    seconds_left = duration_in_seconds

    UNITS_OF_TIME.each do |period|
      amount = (seconds_left / self.send(period.first)).to_i
      str = amount == 1 ? period[0] : period[1]
      elapsed_time << "#{amount} #{str}" if amount > 0
      seconds_left = seconds_left % self.send(period.first)
    end

    seconds = seconds_left % minute
    str = seconds == 1 ? "second" : "seconds"
    elapsed_time << "#{seconds.to_i} #{str}" unless (seconds == 0 && elapsed_time.compact.length > 0)

    elapsed_time
  end

  def year
    365.25 * day
  end

  def month
    30 * day
  end

  def week
    7 * day
  end

  def day
    24 * hour
  end

  def hour
    60 * minute
  end

  def minute
    60
  end
end
