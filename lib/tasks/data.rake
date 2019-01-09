# frozen_string_literal: true

namespace :data do
  desc 'Fetch data from API'
  task fetch: :environment do
    programs_endpoint = 'https://genesis.vision/api/v1.0/programs'
    funds_endpoint = 'https://genesis.vision/api/v1.0/funds'
    quotes_endpoint = 'https://rest.coinapi.io/v1/exchangerate/GVT'

    gvt_invested = 0
    investors_count = 0
    trades_count = 0
    vehicles_count = 0

    # programs
    res = HTTParty.get(programs_endpoint)
    data = JSON.parse(res.body)

    programs = data['programs']

    programs.each do |program|
      gvt_invested += program['statistic']['balanceGVT']['amount']
      investors_count += program['statistic']['investorsCount']
      trades_count += program['statistic']['tradesCount']
    end

    vehicles_count += data['total']

    # funds
    res = HTTParty.get(funds_endpoint)
    data = JSON.parse(res.body)

    funds = data['funds']

    funds.each do |fund|
      gvt_invested += fund['statistic']['balanceGVT']['amount']
      investors_count += fund['statistic']['investorsCount']
    end

    vehicles_count += data['total']

    # quotes
    res = HTTParty.get(quotes_endpoint, headers: {
      "X-CoinAPI-Key" => ENV.fetch('COINAPI_KEY')
    })
    data = JSON.parse(res.body)

    btc = data['rates'].find { |r| r['asset_id_quote'] == 'BTC' }.dig('rate')
    usd = data['rates'].find { |r| r['asset_id_quote'] == 'USD' }.dig('rate')

    Entry.create(
      gvt_invested: gvt_invested,
      btc_invested: gvt_invested * btc,
      usd_invested: gvt_invested * usd,
      investors_count: investors_count,
      trades_count: trades_count,
      vehicles_count: vehicles_count,
    )
  end
end
