# frozen_string_literal: true

namespace :tweet do
  desc 'Generate and post tweet'
  task post: :environment do
    include Rails.application.routes.url_helpers

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end

    # url = "#{ENV.fetch('HOST')}#{root_path}"
    url = "https://gvt-progress-bot.herokuapp.com"

    image_kit = IMGKit.new(url, zoom: 2, width: 2048, height: 1024)
    chart = image_kit.to_file("chart_new.jpg")

    client.update_with_media('Hello World!', chart)
  end
end
