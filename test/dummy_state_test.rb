require 'test_helper'
require 'interface/state_interface_test'
require 'dummys/dummy_state'

class DummyStateTest < Minitest::Test
  def setup
    @state = DummyState.new
  end

  include StateInterfaceTest
end
