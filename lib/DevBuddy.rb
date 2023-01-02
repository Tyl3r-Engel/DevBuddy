# frozen_string_literal: true

require_relative "DevBuddy/version"

module DevBuddy
  class MainLoop
    def initialize
      @break_condition = false
      Signal.trap("INT") do
        @break_condition = true
      end

      worker = Worker.new do
        print "worker\n"
        sleep(5)
      end

      input_worker = InputWorker.new do
        $stdout.flush
        print(">>> ")
        input = gets
        if %W[break\n exit\n close\n].include?(input) then @break_condition = true end
      end

      loop until @break_condition
    end
  end
  class TextBox
    def initialize(text, padded: false, length: 33, divider_char: "~")
      @padded = padded
      @rows = if @padded
                text.length + 2
              else
                text.length
              end
      @length = length
      @divider_char = divider_char
      @hash = {}
      create_text_box_hash(text)
    end

    def create_text_box_hash(array)
      if @padded
        array.unshift " "
        array << " "
      end
      array.length.times { @hash[(_1 + 1).to_s] = array[_1] }
    end

    def display
      divider = String.new
      @length.times { divider << @divider_char }

      puts divider
      @rows.times do |i|
        puts Row.new(@length, @hash[(i + 1).to_s]).row
      end
      puts divider
    end

    class Row
      attr_reader :row

      def initialize(length, text)
        raise StandardError, "row not long enough" if text.length + 2 > length

        @length = length
        @row = "|#{add_white_space(text)}|"
      end

      private

      def add_white_space(text)
        max_length = @length - 2
        text_length = text.length

        num_of_white_space = max_length - text_length

        beginning_of_text = String.new
        end_of_text = String.new
        num_of_white_space.times do |i|
          i.even? ? beginning_of_text << " " : end_of_text << " "
        end

        "#{beginning_of_text}#{text}#{end_of_text}"
      end
    end
  end
end
