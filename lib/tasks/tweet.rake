# frozen_string_literal: true

# wkhtmlimage only seems to work with Heroku cedar-14/heroku-16 stack so
# don't change it - see https://devcenter.heroku.com/articles/stack-packages
# the required library is libpng12-0

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

    gvt_url = "#{ENV.fetch('HOST')}#{charts_gvt_path}"
    kit = IMGKit.new(gvt_url, zoom: 2, width: 2048, height: 1024)
    gvt_chart = kit.to_file("chart_gvt.jpg")

    btc_url = "#{ENV.fetch('HOST')}#{charts_btc_path}"
    kit = IMGKit.new(btc_url, zoom: 2, width: 2048, height: 1024)
    btc_chart = kit.to_file("chart_btc.jpg")

    usd_url = "#{ENV.fetch('HOST')}#{charts_usd_path}"
    kit = IMGKit.new(usd_url, zoom: 2, width: 2048, height: 1024)
    usd_chart = kit.to_file("chart_usd.jpg")

    client.update_with_media(Tweet.status, [gvt_chart, btc_chart, usd_chart])
  end
end
