#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require_relative 'akagi_battleship'

battleship = AkagiBattleship.new
if ARGV[0] == "clean"
  battleship.clean
else
  battleship.hunt
end
