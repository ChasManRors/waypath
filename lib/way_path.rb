# This assumes waypolygons have methods:
#   neighbors()
#   mark()
#   marked?()
#   ==()
# Also WayPath must implement a distance between waypolygons
#   wp_distance()
class WayPath

  attr_accessor :starting_point, :final_point

  def initialize(starting_point, final_point = nil)
    @starting_point = starting_point
    @final_point = final_point
  end

  def steps
    search([starting_point],final_point)
  end

  private

  # Usage: puts search([start], final_point)
  def search(path, final_point)

    current = path.first

    if current == final_point
      puts "found"
      return path.reverse
    end

    neighbors = current.neighbors
    neighbors = neighbors.reject{ |candidate| candidate.marked? }
    neighbors = neighbors.sort{ |a, b| wp_distance(a,final_point) <=> wp_distance(b,final_point) }

    neighbors.each do |child|
      search(path.unshift(child), final_point)
      child.mark
    end
  end

  def wp_distance(a,b)
    raise 'Not yet implemented'
  end

end
