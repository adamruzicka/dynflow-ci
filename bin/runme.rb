require_relative 'example_helper'
require 'dynflow/web'
require 'dynflow-ci'

world = ExampleHelper.create_world
ExampleHelper.set_world(world)
ExampleHelper.world.action_logger.level = Logger::DEBUG

Thread.new do
  ExampleHelper.run_web_console
end

require 'pry'; binding.pry

puts
