module StateInterfaceTest
  def test_responds_to_master
    assert_respond_to(@state, :master)
  end

  def test_responds_to_holder
    assert_respond_to(@state, :holder)
  end

  def test_responds_to_name
    assert_respond_to(@state, :name)
  end

  def test_responds_to_to_s
    assert_respond_to(@state, :to_s)
  end

  def test_responds_to_symbol
    assert_respond_to(@state, :symbol)
  end

  def test_responds_to_pvt_method_transition_to
    prvt = true
    assert_equal true, @state.respond_to?(:transition_to, prvt)
  end

  def test_enter_and_exit_instance_methods_are_defined_in_this_class
    assert @state.class.private_instance_methods(false).include?(:enter)
    assert @state.class.private_instance_methods(false).include?(:exit)
  end
end
