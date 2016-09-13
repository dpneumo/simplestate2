class State
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

  def name
    'State'
  end
  alias :to_s :name

  def symbol
    name.to_sym
  end

  private
    def transition_to(state)
      master.holder.transition_to(state)
    end

    def enter
      raise NotImplementedError, "#enter was called on an instance of State either directly or via super."
    end

    def exit
      raise NotImplementedError, "#exit was called on an instance of State either directly or via super."
    end
end
