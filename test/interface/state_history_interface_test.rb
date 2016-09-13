module StateHistoryInterfaceTest
  def test_responds_to_list
    @state_history = StateHistory.new
    assert_respond_to(@state_history, :list)
  end

  def test_responds_to_hx_size_limit
    @state_history = StateHistory.new
    assert_respond_to(@state_history, :hx_size_limit)
  end

  def test_responds_to_push
    @state_history = StateHistory.new
    assert_respond_to(@state_history, :<<)
  end
end
