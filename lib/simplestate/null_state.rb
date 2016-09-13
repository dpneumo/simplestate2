class NullState
  # Simplifies call via super to SimpleDelegator during StateHolder#new
  # Avoid chicken and egg problem by mimicing rather than inheriting from State

  attr_reader :master, :holder
  def initialize(master: nil, holder: nil, opts: {})
    @master = master
    @holder = holder
    if @master && @master.holder
      # no acton required
    elsif @master && @holder
      @master.holder = @holder
    else
      @master = DefaultMaster.new(holder: @holder)
    end
    @master.holder.__send__(:add_state, self)
  end

  def self.list
    {}
  end

  def name
    'NullState'
  end
  alias :to_s :name

  def symbol
    :NullState
  end

  private
    def transition_to(state)
    end

    def enter
    end

    def exit
    end
end
