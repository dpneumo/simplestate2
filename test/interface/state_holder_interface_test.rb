module StateHolderInterfaceTest
  def test_responds_to_transition_to
    assert_respond_to(@state_holder, :transition_to)
  end

  def test_responds_to_current_state
    assert_respond_to(@state_holder, :current_state)
  end

  def test_responds_to_state_history
    assert_respond_to(@state_holder, :state_history)
  end

  def test_responds_to_history
    assert_respond_to(@state_holder, :history)
  end

  def test_responds_to_hx_size_limit
    assert_respond_to(@state_holder, :hx_size_limit)
  end

  def test_responds_to_initial_state
    assert_respond_to(@state_holder, :initial_state)
  end
end
