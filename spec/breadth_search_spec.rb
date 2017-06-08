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
  let (:way_path1) { WayPath.new(poly1,poly4) }

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
