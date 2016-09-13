class StateList
  def initialize
    @list = {}
  end

  def add(state)
    @list[state.symbol] = state
  end

  def [](symb)
    @list[symb]
  end

  # Convenience methods
  def empty?
    @list.empty?
  end

  def size
    @list.size
  end

  def keys
    @list.keys
  end
end
