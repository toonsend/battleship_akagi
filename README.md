# Installing with rvm

    rvm 1.9.3-p362
    rvm gemset create battlebot
    rvm 1.9.3-p362@battlebot
    rvm gemset create battlebot
    gem install bundler
    bundle install
    cp team_config.yml.example team_config.yml
    chmod 755 battlebot.rb

Update your team_config.yml with your api key and team id

    ./battlebot.rb
