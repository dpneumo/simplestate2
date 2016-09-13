class StateHistory
  attr_reader :hx_size_limit

  def initialize(hx_size_limit: 10)
    @hx_size_limit = hx_size_limit
    @container = []
  end

  def <<(state_symbol)
    @container << state_symbol
    @container = @container.last(hx_size_limit)
    self
  end

  def list
    @container
  end
end
