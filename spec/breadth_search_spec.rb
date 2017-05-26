require 'spec_helper'
require_relative '../lib/way_path.rb'

# The following runs but does not terminate.  Try the following instead
# => Not sure this does what it is suppose to so just add stuff to WAYPOLYGON!

class WpDecorator < SimpleDelegator

  attr_accessor :wp_visited

  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
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
  let (:poly1) { double("Waypolygon") }
  let (:poly2) { double("Waypolygon") }
  let (:poly3) { double("Waypolygon") }
  let (:poly4) { double("Waypolygon") }

  let (:naked_adjacents_waypolygons) { [poly2, poly3, poly4] }

  let (:adjacents_waypolygons) {WpDecorator.wrap naked_adjacents_waypolygons}

  let (:unattached_poly1) { double("Waypolygon") }
  let (:unattached_poly2) { double("Waypolygon") }
  let (:unattached_poly3) { double("Waypolygon") }
  let (:unattached_poly4) { double("Waypolygon") }
  let (:unattached_poly5) { double("Waypolygon") }

  let (:way_path1) { WayPath.new(poly1,poly4) }

  before(:each) do

    allow(poly1).to receive(:wp_adjacents).and_return adjacents_waypolygons

    allow(poly2).to receive(:wp_adjacents).and_return [poly1]
    allow(poly3).to receive(:wp_adjacents).and_return [poly1]
    allow(poly4).to receive(:wp_adjacents).and_return [poly1]

    allow(poly1).to receive(:center).and_return([0.0,0.0])
    allow(poly2).to receive(:center).and_return([2.0,2.0])
    allow(poly3).to receive(:center).and_return([3.0,3.0])
    allow(poly4).to receive(:center).and_return([4.0,4.0])

    allow(poly1).to receive(:wp_visited?).and_return(nil)
    allow(poly2).to receive(:wp_visited?).and_return(nil)
    allow(poly3).to receive(:wp_visited?).and_return(nil)
    allow(poly4).to receive(:wp_visited?).and_return(nil)

    allow(unattached_poly1).to receive(:center).and_return([10.0,10.0])
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

binding.pry # => debugger
    start = WpDecorator.new poly1
    final_point = adjacents_waypolygons.last

    x =  way_path1.search([start], final_point)

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
