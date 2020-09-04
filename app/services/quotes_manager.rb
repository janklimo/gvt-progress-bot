# frozen_string_literal: true

class QuotesManager
  attr_reader :quotes

  ENDPOINT = 'https://pro-api.coinmarketcap.com/v1/' \
    'cryptocurrency/quotes/latest?symbol=BTC,ETH'

  def initialize
    response = HTTParty.get(ENDPOINT, headers: {
      "X-CMC_PRO_API_KEY" => ENV.fetch('CMC_API_KEY')
    })

    data = JSON.parse(response.body)

    @quotes = {}

    %w[BTC ETH].each do |coin|
      @quotes[coin] = data.dig('data', coin, 'quote', 'USD', 'price')
    end
  end
end
