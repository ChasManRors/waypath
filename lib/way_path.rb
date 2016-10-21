class WayPath

  attr_accessor :waypolygon_start, :waypolygon_end
  attr_accessor :steps

  def initialize(waypolygon_start, waypolygon_end = nil)
    @waypolygon_start = waypolygon_start
    @waypolygon_end = waypolygon_end
    @steps = [waypolygon_start]
  end

  def start
    @waypolygon_start
  end

  def end
    @waypolygon_end
  end

  def path
    if steps.last.adjacent?(waypolygon_end)
      steps << waypolygon_end
      return steps
    else
      steps << next_step
    end
  end

  def adjacent?(waypolygon)
    true
  end

  def next_step
    nil
  end
end
