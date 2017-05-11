require 'way_path'




# Given:
# When:
# Then:

# Happy path
# Unhappy path
# Edge cases
# Bugs that are fixed

describe 'WayPath' do # => given
  let(:wp_start) { double("Waypolygon") }
  let(:wp_end) { double("Waypolygon")}
  let(:trivial_way_path) {WayPath.new(wp_start, wp_end)}

	context '#initialized' do  # => when
    it 'will know its starting waypolygon' do # => then
      expect(trivial_way_path.start).not_to be_nil
    end

    it 'will know its destination waypolygon' do
      expect(trivial_way_path.end).not_to be_nil
    end
	end

  context 'send path# where the start and end are neighbors' do
    it 'returns the path with the start and end waypolygons' do
      allow(wp_start).to receive(:adjacent?).with(any_args) { true }
      expect(trivial_way_path.path).to match_array([wp_start,wp_end])
    end
  end

end
