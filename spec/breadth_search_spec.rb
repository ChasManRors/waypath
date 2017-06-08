require 'spec_helper'
require 'awesome_print'
require_relative '../lib/way_path.rb'

# The following runs but does not terminate.  Try the following instead
# => Not sure this does what it is suppose to so just add stuff to WAYPOLYGON!

class FakeWaypolygon
  attr_accessor :wp_visited, :center, :wp_adjacents
  def initialize(x,y)
    @center = [x, y]
  end
  def wp_mark
    @wp_visited = true
  end
  def wp_visited?
    @wp_visited
  end
end

# Expectations, fancy
describe 'WayPath' do
  let (:poly1) { FakeWaypolygon.new(0.0, 0.0) }
  let (:poly2) { FakeWaypolygon.new(2.0, 2.0) }
  let (:poly3) { FakeWaypolygon.new(3.0, 3.0) }
  let (:poly4) { FakeWaypolygon.new(4.0, 4.0) }

  let (:unattached_poly1) { FakeWaypolygon.new(10.0, 10.0) }
  let (:polys){ [poly1, poly2, poly3, poly4, unattached_poly1] }
  let (:adjacents_waypolygons) { [poly2, poly3, poly4] }
  let (:way_path1) { WayPath.new(poly1, poly4) }

  ########################################################################

  # Define and print visual representation
  # for j in [15,25,35,45]
  #   arow = ""
  #   for i in [15,25,35]
  #     puts "let (:poly#{i}x#{j}) { FakeWaypolygon.new(#{i}, #{j}) }"
  #     arow << "poly#{i}x#{j}, "
  #     # let("poly#{i}x#{j}".to_sym) { FakeWaypolygon.new(i.to_f, j.to_f) }
  #   end
  #   puts arow
  # end

  let (:start1) { FakeWaypolygon.new(25.0, 45.0) }
  let (:final1) { FakeWaypolygon.new(25.0, 25.0) }

  ################################################################


  let (:poly15x15) { FakeWaypolygon.new(15, 15) }
  let (:poly25x15) { FakeWaypolygon.new(25, 15) }
  let (:poly35x15) { FakeWaypolygon.new(35, 15) }

  let (:poly15x25) { FakeWaypolygon.new(15, 25) }
  let (:poly25x25) { FakeWaypolygon.new(25, 25) }
  let (:poly35x25) { FakeWaypolygon.new(35, 25) }

  let (:poly15x35) { FakeWaypolygon.new(15, 35) }
  let (:poly25x35) { FakeWaypolygon.new(25, 35) }
  let (:poly35x35) { FakeWaypolygon.new(35, 35) }

  let (:poly15x45) { FakeWaypolygon.new(15, 45) }
  let (:poly25x45) { FakeWaypolygon.new(25, 45) }
  let (:poly35x45) { FakeWaypolygon.new(35, 45) }





  before(:each) do
    poly1.wp_adjacents = adjacents_waypolygons
    polys.each{ |p| p.wp_visited = nil }
  end

  it 'finds reachable candidates' do
    expect(poly1.wp_adjacents.size).to eq(3)
  end

  it 'wont return non adjacent candidates' do
    expect(poly1.wp_adjacents).not_to include(unattached_poly1)
  end

  it 'will allow for search initialization' do
    expect(WayPath.new(poly1,poly4).is_a?(WayPath)).to be(true)
  end

  it 'order reachable candidates' do
    # final is unattached_poly1.center => [10.0, 10.0]
    array = way_path1.sort_and_filter(adjacents_waypolygons,unattached_poly1)
    expect(array.map(&:center)).to match_array([[4.0, 4.0], [3.0, 3.0], [2.0, 2.0]])
  end

  # it 'filters out marked ones' do
  #   allow(poly3).to receive(:wp_visited?).and_return(true)
  #   array = way_path1.sort_and_filter(adjacents_waypolygons,unattached_poly1)
  #   expect(array.map(&:center)).to match_array([[4.0, 4.0], [2.0, 2.0]])
  # end

  # Usage: puts search([start], final_point)
  it 'returns path to neighbor' do
    final_point = adjacents_waypolygons.last
    wp = way_path1.search([poly1], final_point).map( &:center)
    expect(wp).to match_array([[0.0, 0.0], [4.0, 4.0]])
  end

  # poly15x15, poly25x15, poly35x15,
  # poly15x25, poly25x25, poly35x25,
  # poly15x35, poly25x35, poly35x35,
  # poly15x45, poly25x45, poly35x45,

  # poly15x15, poly25x15, poly35x15,
  # poly15x25, fini25x25, poly35x25,
  # poly15x35, poly25x35, poly35x35,
  # poly15x45, star25x45, poly35x45,

  it 'finds direct path one removed' do
    star25x45 = poly25x45
    fini25x25 = poly25x25

    poly15x15.wp_adjacents= [poly25x15, poly15x25, fini25x25]
    poly25x15.wp_adjacents= [poly15x15, poly35x15, poly15x25, fini25x25, poly35x25]
    poly35x15.wp_adjacents= [poly25x15, fini25x25, poly35x25]
    poly15x25.wp_adjacents= [poly15x15, poly25x15, fini25x25, poly15x35, poly25x35]
    fini25x25.wp_adjacents= [poly15x15, poly25x15, poly35x15, poly15x25, poly35x25, poly15x35, poly25x35, poly35x35]
    poly35x25.wp_adjacents= [poly25x15, poly35x15, fini25x25, poly25x35, poly35x35]
    poly15x35.wp_adjacents= [poly15x25, fini25x25, poly25x35, poly15x45, star25x45]
    poly25x35.wp_adjacents= [poly15x25, fini25x25, poly35x25, poly15x35, poly35x35, poly15x45, star25x45, poly35x45]
    poly35x35.wp_adjacents= [fini25x25, poly35x25, poly25x35, star25x45, poly35x45]
    poly15x45.wp_adjacents= [poly15x35, poly25x35, star25x45]
    star25x45.wp_adjacents= [poly15x35, poly25x35, poly35x35, poly15x45, poly35x45]
    poly35x45.wp_adjacents= [poly25x35, poly35x35, star25x45]

    way_path2 = WayPath.new(star25x45, fini25x25)
    wp = way_path2.steps
    expect(wp.map(&:center)).to match_array([[25, 45], [25, 35], [25, 25]])
  end


  xit "move to best unmarked candidate and mark" do

  end

end

=begin
  def depth_first_search(node, target)
    if node.value == target
      puts "yes"
      return node
    end
    left = depth_first_search(node.child_left, target) if node.child_left
    right = depth_first_search(node.child_right, target) if node.child_right
    left or right
  end
=end
