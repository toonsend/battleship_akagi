require 'httparty'
require 'json'
require 'yaml'

class AkagiBattleship

  MAP_WIDTH = 9

  def initialize
    config    = YAML.load_file('team_config.yml')
    @host     = config['host']
    @team_id  = config['team_id']
    @api_key  = config['api_key']
    @test     = true
    @missiles = []
  end

  def print_result
    system('clear')
    puts "#{@result['move']} : #{@result['status']}"
    @result['grid'].each do |grid_line|
      puts grid_line.gsub(/x/,'X')
    end
    puts @result
  end

  def clean
    (0..9).each do |x|
      (0..9).each do |y|
        fire(x,y)
        print_result
        abort if @result["game_status"] == 'completed'
      end
    end
  end

  def http_post(x,y)
    query   = {'move' => [x,y], :test => @test}
    headers = {"HTTP-MIDWAY-API-KEY" => @api_key }
    HTTParty.post("http://#{@host}/teams/#{@team_id}/game", :query => query, :headers => headers)
  end

  def fire(x,y)
    sleep 2
    raise "Repeat Hit" if @missiles.include?([x,y])
    response = http_post(x,y)
    @result = JSON.parse(response.body)
    @map    = @result['grid']
    print_result
    check_for_complete
  end

  def check_for_complete
    abort if @result["game_status"] == 'completed'
  end

  def hunt_coordinates
    (0..MAP_WIDTH).inject([]) do |hunting_ground, count|
      (count % 2).step(MAP_WIDTH, 2) do |x|
        hunting_ground << [count, x]
      end
      hunting_ground
    end.shuffle
  end

  def hunt
    hunt_coordinates.each do |x,y|
      next if @missiles.include?([x,y])
      fire(x,y)
      if @result['status'] == 'hit'
        hit = @result['move']
        shoot_until_miss(hit, -1,  0, 1)
      end
    end
  end

  def shoot_until_miss(hit, xoffset, yoffset, direction)

    return if @result['status'] == 'hit and destroyed'

    x,y = hit
    x = x + xoffset
    y = y + yoffset

    if (x > MAP_WIDTH || y > MAP_WIDTH) || (x < 0 || y < 0)
      direction += 1
      xoffset = 0
      yoffset = 0
    elsif @map[x][y] != 'o'
      direction += 1
      xoffset = 0
      yoffset = 0
    end

    case direction
    when 1
      xoffset -= 1
    when 2
      xoffset += 1
    when 3
      yoffset -= 1
    when 4
      yoffset += 1
    end
    fire(x,y)
    shoot_until_miss(hit, xoffset, yoffset, 1)
  end
end
    # if @result['status'] == 'hit and destroyed'
    #   return
