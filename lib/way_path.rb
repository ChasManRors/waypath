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

  def initialize(starting_point, final_point)
    @starting_point = starting_point
    @final_point = final_point
  end

  def steps
    search([starting_point],final_point)
  end

  def pwp(p)
    [p.center,p.wp_visited?].flatten
  end

  # private

  # Usage: puts search([start], final_point)
  def search(path, final_point)

    current = path.first
    #current = path.last

    puts "start #{pwp starting_point} | current #{pwp current} | final #{pwp final_point}"
    puts "path-size: #{path.size} | steps: #{path.map{ |p| pwp p }}"

    if wp_distance2(current, final_point) < 1.0
      current.wp_mark
      puts "found minimum distance"
      return path.reverse
    end

    wp_adjacents = sort_and_filter(current.wp_adjacents, final_point)

    wp_adjacents.each do |wp|
      if final_point.wp_visited?
        puts "found visited final point"
        return path.reverse
      end
      wp.wp_mark
      search(path.unshift(wp), final_point)
    end
  end

  def sort_and_filter(adjacents, point)
    adjacents = adjacents.reject{ |adjacent| adjacent.wp_visited? }
    adjacents = adjacents.sort{ |a, b| wp_distance2(a, point) <=> wp_distance2(b, point) }
  end

  def wp_distance2(a,b)
    # puts a.center.to_s + " " + b.center.to_s
    (b.center[0] - a.center[0])**2 + (b.center[1] - a.center[1])**2
  end
end

# bordering
# adjacent wp_adjacents
