require 'test_helper'
require 'interface/state_interface_test'

class NullStateTest < Minitest::Test
  def setup
    @master = DefaultMaster.new(holder: DummyStateHolder.new)
    @state = NullState.new(master: @master)
  end

  include StateInterfaceTest
end
