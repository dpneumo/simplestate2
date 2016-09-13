require 'test_helper'

class StateListTest < Minitest::Test
  def setup
    @statelist = StateList.new
  end

  def test_state_list_initializes_to_an_empty_hash
    assert @statelist.empty?
  end

  def test_can_add_states_to_the_list
    @statelist.add(DummyState.new)
    assert_equal 1, @statelist.size
    assert_equal 'DummyState', @statelist[:DummyState].name
  end

end
