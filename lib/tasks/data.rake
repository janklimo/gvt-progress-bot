# frozen_string_literal: true

namespace :data do
  desc 'Fetch data from API'
  task fetch: :environment do
    programs_endpoint = 'https://genesis.vision/api/v2.0/programs'
    funds_endpoint = 'https://genesis.vision/api/v2.0/funds'

    quotes = QuotesManager.new.quotes

    investments_count = 0
    vehicles_count = 0
    usd_invested = 0

    ###### programs ######
    res = HTTParty.get(programs_endpoint)
    data = JSON.parse(res.body)

    programs = data['items']

    programs.each do |item|
      program = Vehicle.new(item, quotes)
      usd_invested += program.usd_invested
      investments_count += program.investors_count
    end

    vehicles_count += data['total']

    ###### programs by AUM ######

    programs_series = programs.map do |item|
      program = Vehicle.new(item, quotes)
      title = program.title
      type = program.type
      amount = program.usd_invested
      [title, amount, type]
    end.sort_by { |e| -e[1] }

    ###### funds ######
    res = HTTParty.get(funds_endpoint)
    data = JSON.parse(res.body)

    funds = data['items']

    funds.each do |item|
      fund = Vehicle.new(item, quotes)
      usd_invested += fund.usd_invested
      investments_count += fund.investors_count
    end

    vehicles_count += data['total']

    ###### funds by AUM ######

    funds_series = funds.map do |item|
      fund = Vehicle.new(item, quotes)
      title = fund.title
      amount = fund.usd_invested
      [title, amount]
    end.sort_by { |e| -e[1] }

    Entry.create(
      usd_invested: usd_invested,
      gvt_invested: usd_invested / quotes['GVT'],
      btc_invested: usd_invested / quotes['BTC'],
      eth_invested: usd_invested / quotes['ETH'],
      investments_count: investments_count,
      vehicles_count: vehicles_count,
      programs: programs_series,
      funds: funds_series,
    )
  end
end
