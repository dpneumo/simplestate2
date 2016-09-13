require 'test_helper'
require 'interface/state_history_interface_test'

class StateHistoryTest < Minitest::Test

  include StateHistoryInterfaceTest

  def test_sets_a_default_history_size_limit_on_creation
    @state_history = StateHistory.new
    assert_equal 10, @state_history.hx_size_limit
  end

  def test_can_change_the_history_size_limit_on_creation
    @state_history = StateHistory.new(hx_size_limit: 4)
    assert_equal 4, @state_history.hx_size_limit
  end

  def test_maintains_an_ordered_list_of_most_recent_state_names
    @state_history = StateHistory.new(hx_size_limit: 4)
    @state_history << :one << :two << :three << :four << :five
    assert_equal [:two, :three, :four, :five], @state_history.list
  end
end
