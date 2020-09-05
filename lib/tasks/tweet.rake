# frozen_string_literal: true

# wkhtmlimage only seems to work with Heroku cedar-14/heroku-16 stack so
# don't change it - see https://devcenter.heroku.com/articles/stack-packages
# the required library is libpng12-0

namespace :tweet do
  include Rails.application.routes.url_helpers

  desc 'Generate and post tweet'
  task post: :environment do
    wake_up

    usd_url = ENV.fetch('HOST')
    kit = IMGKit.new(usd_url, zoom: 2, width: 2048, height: 1024)
    usd_chart = kit.to_file("chart_usd.jpg")

    tweet = client.update_with_media(Tweet.status, [usd_chart])

    post_tweet_to_discord(tweet)
  end

  desc 'Generate and post a managers tweet'
  task post_managers: :environment do
    wake_up

    managers_url = "#{ENV.fetch('HOST')}#{charts_managers_path}"
    kit = IMGKit.new(managers_url, zoom: 2, width: 2048, height: 1024)
    managers_chart = kit.to_file("chart_managers.jpg")

    tweet = client.update_with_media(Tweet.managers, [managers_chart])

    post_tweet_to_discord(tweet)
  end

  desc 'Generate and post a funds tweet'
  task post_funds: :environment do
    wake_up

    funds_url = "#{ENV.fetch('HOST')}#{charts_funds_path}"
    kit = IMGKit.new(funds_url, zoom: 2, width: 2048, height: 1024)
    funds_chart = kit.to_file("chart_funds.jpg")

    tweet = client.update_with_media(Tweet.funds, [funds_chart])

    post_tweet_to_discord(tweet)
  end

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def wake_up
    begin
      # wake up the dyno
      res = HTTParty.get(ENV.fetch('HOST'))
      # wait a bit longer in case of a request timeout
      sleep 30 if res.code == 500
    rescue
      # wait a bit longer in case of an unexpected error
      sleep 30
    end
  end

  def post_tweet_to_discord(tweet)
    # Run Discord bot in background.
    bot = Discordrb::Bot.new(token: ENV.fetch('DISCORD_TOKEN'))
    bot.run(true)
    bot.send_message(ENV.fetch('DISCORD_CHANNEL'), tweet.uri.to_s)
    bot.stop
  end
end
