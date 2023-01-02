# frozen_string_literal: true

require "thor"
require "DevBuddy"

module DevBuddy
  class CLI < Thor
    desc "start", "Start DevBuddy"
    def start
      start_time = Time.now
      DevBuddy::TextBox.new(
        ["Start", "Type `help` for more options"],
        padded: true,
        length: 50,
        divider_char: "-"
      ).display

      DevBuddy::MainLoop.new

      end_time = Time.now
      total_time = (end_time - start_time).to_s[0..3]
      print("\n")
      DevBuddy::TextBox.new(
        ["Process Finished", "ran for -> #{total_time}s"],
        padded: true,
        length: 50,
        divider_char: "-"
      ).display
    end
  end
end
