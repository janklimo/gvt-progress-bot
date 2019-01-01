# frozen_string_literal: true

namespace :data do
  desc 'Fetch data from API'
  task fetch: :environment do
    programs_endpoint = 'https://genesis.vision/api/v1.0/programs'
    funds_endpoint = 'https://genesis.vision/api/v1.0/funds'

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

    Entry.create(
      gvt_invested: gvt_invested,
      investors_count: investors_count,
      trades_count: trades_count,
      vehicles_count: vehicles_count,
    )
  end
end
