# class Waypolygon

  # attr_accessor :wp_visited

  # # Instead of wp_adjacents I would have used neighbors but it collides with Waypolygon namespace
  # def wp_adjacents
  #   compass.values.compact
  # end

  # def wp_mark
  #   @wp_visited = true
  # end

# end


# This assumes waypolygons have methods:
#   wp_adjacents()
#   wp_visit()
#   wp_visited?()
#   ==()
# Also WayPath must implement a distance between waypolygons
#   wp_distance2()
class WayPath

  attr_accessor :starting_point, :final_point

  def initialize(starting_point, final_point = nil)
    @starting_point = starting_point
    @final_point = final_point
  end

  def steps
    search([starting_point],final_point)
  end

  # private

  # Usage: puts search([start], final_point)
  def search(path, final_point)

    current = path.first
    puts "current.center = #{current.center}"
    puts "final_point.center = #{final_point.center}"
    puts "path.size = #{path.size}"
    puts "path = #{path.map{ |p| [p.center,p.wp_visited?].flatten }}"
    puts "current.wp_visited? = #{current.wp_visited?}"

binding.pry # => debugger

    if wp_distance2(current, final_point) < 1.0
      puts "found"
      return path.reverse
    end

    wp_adjacents = sort_and_filter(current.wp_adjacents, final_point)

    wp_adjacents.each do |wp|
      search(path.unshift(wp), final_point)
binding.pry # => debugger
      wp.wp_mark
    end
  end

  def sort_and_filter(adjacents, point)
    adjacents = adjacents.reject{ |adjacent| adjacent.wp_visited? }
    adjacents = adjacents.sort{ |a, b| wp_distance2(a, point) <=> wp_distance2(b, point) }
  end

  def wp_distance2(a,b)
    (b.center[0] - a.center[0])**2 + (b.center[1] - a.center[1])**2
  end
end

# bordering
# adjacent wp_adjacents
