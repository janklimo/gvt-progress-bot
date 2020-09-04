# frozen_string_literal: true

class Vehicle
  attr_reader :vehicle, :quotes

  def initialize(vehicle, quotes)
    @vehicle = vehicle
    @quotes = quotes
  end

  def usd_invested
    currency = vehicle['balance']['currency']
    amount = vehicle['balance']['amount']

    case currency
    when 'ETH'
      amount * quotes['ETH']
    when 'BTC'
      amount * quotes['BTC']
    else
      # USD(T)
      amount
    end.to_i
  end

  def investors_count
    vehicle['investorsCount']
  end

  def title
    vehicle['title']
  end

  def type
    return 'crypto' unless vehicle['tags']

    vehicle['tags'].any? { |tag| tag['name'] == 'CRYPTO'} ?
      'crypto' : 'forex'
  end
end
