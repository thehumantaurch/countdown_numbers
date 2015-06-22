class Countdown
  attr_reader :card_combos

  TOP_ROW_NUMS = [25, 50, 75, 100]
  LOW_NUMS = (1..10).to_a

  def initialize
    @deck = TOP_ROW_NUMS + LOW_NUMS
    @target = 0
    @cards = []
    @ops = ["+", "-", "*", "/"]
  end

  def cecil
    @target = (100..999).to_a.sample
  end

  def get_basics
    6.times do
      @cards << @deck.sample
    end
    @ops.each do |op|
      @cards << op
    end
  end

  def get_card_combos
    @card_combos = []
    max = @cards.length
    (3..max).to_a.each do |x|
      initial_combos = @cards.permutation(x).to_a
      initial_combos.each do |combo|
        op_count = combo.count{ |x| x.is_a?(String) }
        num_count = combo.count{ |x| x.is_a?(Integer) }
        if ((num_count - op_count) == 1 && combo[-1].is_a?(String))
          @card_combos << combo.join(" ")
        end
      end
    end
  end

  def evaluate_combos
    calc = RPNCalculator.new
    @card_combos.each do |combo|
      calc.evaluate(combo)
    end
    calc.finals.reject! { |x| (x - @target).abs > 10}
  end

end

class RPNCalculator
  attr_accessor :finals

  def initialize
    @finals = []
  end

  def evaluate(rpn)
    a = rpn.split(' ')
    array = a.inject([]) do |array, i|
      if array != nil
        if i =~ /\d+/
          array << i.to_i
        else
          if array.length > 1
            b = array.pop(2)
            case
              when i == "+"
                array << b[0] + b[1]
              when i == '-'
                array << b[0] - b[1]
              when i == '*'
                array << b[0] * b[1]
              when i == '/'
                if b[1] != 0
                  if (b[0] % b[1]) == 0
                    array << b[0] / b[1]
                  end
                end
            end
          end
        end
      end
    end
    if array != nil
      @finals << array.pop
    end
  end

end

test = Countdown.new
test.cecil
test.get_basics
test.get_card_combos
test.evaluate_combos

