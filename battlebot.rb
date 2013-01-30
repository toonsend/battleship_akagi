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
@missiles = []

def fire(x,y)
  @missiles << [x,y]
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
  if result['game_status'] == 'completed'
    print_result(result)
    puts result
    exit
  end
  return result if result['status'] == 'hit and destroyed'
  map = result["grid"]
  hunting = true
  hitx, hity = hit
  while(hunting)
    hitx -= 1
    hunting = check_square(hitx, hity, hit, map)
  end

  hunting = true
  hitx, hity = hit
  while(hunting)
    hitx += 1
    hunting = check_square(hitx, hity, hit, map)
  end

  hunting = true
  hitx, hity = hit
  while(hunting)
    hity -= 1
    hunting = check_square(hitx, hity, hit, map)
  end

  hunting = true
  hitx, hity = hit
  while(hunting)
    hity += 1
    hunting = check_square(hitx, hity, hit, map)
  end
end

def check_square(hitx, hity, hit, map)
  if (hitx < 0 || hitx > 9)
    return false
  elsif (hity < 0 || hity > 9)
    return false
  elsif map[hitx][hity] == 'o'
    hunt_ship(fire(hitx, hity), hit)
  elsif map[hitx][hity] == 'x'
    return true
  elsif map[hitx][hity] == 'm'
    return false
  end
end

def attack
  hunt_points.each do |x,y|
    next if @missiles.include?([x,y])
    result = fire(x,y)
    print_result(result)
    if result['status'] == 'hit'
      hunt_ship(result, result['move'])
    end
    return result if result["game_status"] == 'completed'
  end
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
