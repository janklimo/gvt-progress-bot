# frozen_string_literal: true

describe 'data:fetch' do
  include_context 'rake'

  before do
    stub_request(:get, 'https://genesis.vision/api/v2.0/programs')
      .to_return(status: 200, body: file_fixture('programs.json'))

    stub_request(:get, 'https://genesis.vision/api/v2.0/funds')
      .to_return(status: 200, body: file_fixture('funds.json'))

    stub_request(:get, 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=BTC,ETH,GVT')
      .with( headers: { 'X-CMC_PRO_API_KEY' => '123' })
      .to_return(status: 200, body: file_fixture('quotes.json'))

    allow(ENV).to receive(:fetch).with('CMC_API_KEY').and_return('123')
  end

  it 'loads data and creates records' do
    task.invoke

    expect(Entry.count).to eq 1

    entry = Entry.last
    expect(entry.usd_invested).to eq 7_422
    expect(entry.investments_count).to eq 56
    expect(entry.vehicles_count).to eq 280
    expect(entry.programs.first)
      .to eq ['All Asset Strategy', '3262.69', 'forex']
    expect(entry.funds.first).to eq ['100x Fund', '1397.8881233093812']
  end
end
