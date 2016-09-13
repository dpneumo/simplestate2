require 'test_helper'
require 'interface/state_holder_interface_test'

class State1 < State
  def name;  'State1'; end
  private
    def enter; 'State1 enter method called'; end
    def exit;  'State1 exit method called';  end
end

class State2 < State
  def name;  'State2'; end
  private
    def enter; 'State2 enter method called'; end
    def exit;  'State2 exit method called';  end
end

class StateHolderTest < Minitest::Test
  def setup
    @master = DefaultMaster.new(holder: StateHolder.new(initial_state: :State1))
    @state_holder = @master.holder
      State1.new(master: @master)
      State2.new(master: @master)
    @state_holder.start
  end

  include StateHolderInterfaceTest

  def test_creation_requires_initial_state_argument
    assert_raises(ArgumentError) { StateHolder.new }
  end

  def test_creation_initializes_current_state_to_initial_state
    assert_equal :State1, @state_holder.current_state.symbol
  end

  def test_can_transition_to_new_state
    expect = 'State2 enter method called'
    assert_equal expect, @state_holder.transition_to(:State2)
    expect = :State2
    assert_equal expect,  @state_holder.current_state.symbol
  end

  def test_initializes_state_history
    assert_equal [:NullState, :State1], @state_holder.history
  end

  def test_updates_state_history_on_state_transition
    @state_holder.transition_to(:State2)
    assert_equal [:NullState, :State1, :State2], @state_holder.history
  end
end

