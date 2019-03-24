# frozen_string_literal: true

namespace :data do
  desc 'Fetch data from API'
  task fetch: :environment do
    programs_endpoint = 'https://genesis.vision/api/v1.0/programs'
    funds_endpoint = 'https://genesis.vision/api/v1.0/funds'
    quotes_endpoint = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=GVT'

    gvt_invested = 0
    investments_count = 0
    trades_count = 0
    vehicles_count = 0

    # programs
    res = HTTParty.get(programs_endpoint)
    data = JSON.parse(res.body)

    programs = data['programs']

    programs.each do |program|
      gvt_invested += program['statistic']['balanceGVT']['amount']
      investments_count += program['statistic']['investorsCount']
      trades_count += program['statistic']['tradesCount']
    end

    vehicles_count += data['total']

    ###### programs by AUM ######

    programs_series = programs.map do |program|
      title = program['title']
      currency = program['currency'] == 'USD' ? 'forex' : 'crypto'
      amount = program['statistic']['balanceGVT']['amount']
      [title, amount, currency]
    end.sort_by { |e| e[1] }.reverse

    # funds
    res = HTTParty.get(funds_endpoint)
    data = JSON.parse(res.body)

    funds = data['funds']

    funds.each do |fund|
      gvt_invested += fund['statistic']['balanceGVT']['amount']
      investments_count += fund['statistic']['investorsCount']
    end

    vehicles_count += data['total']

    # quotes
    res = HTTParty.get(quotes_endpoint, headers: {
      "X-CMC_PRO_API_KEY" => ENV.fetch('CMC_API_KEY')
    })
    data = JSON.parse(res.body)

    gvt_usd = data.dig('data', 'GVT', 'quote', 'USD', 'price')

    res = HTTParty.get("#{quotes_endpoint}&convert=BTC", headers: {
      "X-CMC_PRO_API_KEY" => ENV.fetch('CMC_API_KEY')
    })
    data = JSON.parse(res.body)

    gvt_btc = data.dig('data', 'GVT', 'quote', 'BTC', 'price')

    Entry.create(
      gvt_invested: gvt_invested,
      btc_invested: gvt_invested * gvt_btc,
      usd_invested: gvt_invested * gvt_usd,
      investments_count: investments_count,
      trades_count: trades_count,
      vehicles_count: vehicles_count,
      programs: programs_series,
      gvt_usd: gvt_usd,
    )
  end
end
