#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require 'httparty'
require 'json'
require 'yaml'

config    = YAML.load_file('team_config.yml')
@host     = config['host']
@team_id  = config['team_id']
@api_key  = config['api_key']
@test     = true
@map_size = 9

def fire(x,y)
  response = HTTParty.post("http://#{@host}/teams/#{@team_id}/game", :query => {'move' => [x,y], 'test' => @test}, :headers => {"HTTP-MIDWAY-API-KEY" => @api_key})
  result = JSON.parse(response.body)
end

def print_result(result)
  system('clear')
  puts "#{result['move']} : #{result['status']}"
  result['grid'].each do |grid_line|
    puts grid_line
  end
end

def hunt_points
  (0..@map_size).inject([]) do |hunting_ground, count|
    (count % 2).step(@map_size,2) do |x|
      hunting_ground << [count, x]
    end
    hunting_ground
  end
end

def hunt_ship(result, hit)
  puts "hunting"
  if result['status'] != 'hit and destroyed'
    hunt_ship(result, hit)
  end
end

def attack
  hunt_points.each do |x,y|
    result = fire(x,y)
    print_result(result)
    hunt_ship(result) if result['status'] == 'hit'
    return result if result["game_status"] == 'completed'
  end
rescue Exception => e
  puts e.message
end

def complete_game
  (0..9).each do |x|
    (0..9).each do |y|
      result = fire(x,y)
      print_result(result)
      return result if result["game_status"] == 'completed'
    end
  end
end


if ARGV[0] == "clean"
  puts complete_game
else
  attack
end
