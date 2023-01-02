# frozen_string_literal: true

require_relative "./text_box"

class Worker
  def initialize(&block)
    @worker_thread = Thread.new do
      loop(&block)
    end
  rescue StandardError => e
    puts e
  end

  def kill_worker
    Thread.kill(@worker_thread)
  end
end

# needs input position=(1,2), prompt=">>>"
class InputWorker < Worker
end

class PrintWorker < Worker
  def print(val); end
end

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

start_time = Time.now
TextBox.new(
  ["Start", "Type `help` for more options"],
  padded: true,
  length: 50,
  divider_char: "-"
).display

MainLoop.new

end_time = Time.now
total_time = (end_time - start_time).to_s[0..3]
print("\n")
TextBox.new(
  ["Process Finished", "ran for -> #{total_time}s"],
  padded: true,
  length: 50,
  divider_char: "-"
).display
