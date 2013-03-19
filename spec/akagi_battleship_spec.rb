require_relative '../akagi_battleship'

describe AkagiBattleship do

  it "should create a battleship" do
    AkagiBattleship.new.should be_instance_of(AkagiBattleship)
  end

  it "should return the hunting coordinates" do
    ab = AkagiBattleship.new
    ab.hunt_coordinates.size.should == 50
  end

  describe "ship target" do

    before(:each) do
      @battleship = AkagiBattleship.new
    end

    it "should find the longest empty space"
    it "should continue until a non empty space after a secondary hit"
    it "should continue in the opposite direction after a non empty space follows a hit"
  end

end

def map(scenario)
  {
    :with_one_long_empty_zone  => [
      "oooooxoooo",
      "oooooooooo",
      "oooooooooo",
      "oooxoxooxo",
      "oooooooooo",
      "oooooxoooo",
      "oooooooooo",
      "oooooooooo",
      "oooooooooo",
      "oooooooooo"
    ]
  }[scenario]
end

def game_move_response
  {
    "game_id"=>60,
    "grid"=>[
      "momomomomo",
      "omomomomom",
      "mommmmxxxm",
      "omomommmom",
      "momomomomo",
      "omomommmom",
      "mmmommxxxx",
      "xxxxxxxooo"
    ],
    "opponent_id"=>2,
    "status"=>"hit and destroyed",
    "move"=>[9, 5],
    "game_status"=>"completed",
    "moves"=>81
  }
end
