# frozen_string_literal: true

describe 'data:fetch' do
  include_context 'rake'

  before do
    stub_request(:get, 'https://genesis.vision/api/v1.0/programs')
      .to_return(status: 200, body: file_fixture('programs.json'))

    stub_request(:get, 'https://genesis.vision/api/v1.0/funds')
      .to_return(status: 200, body: file_fixture('funds.json'))

    stub_request(:get, 'https://rest.coinapi.io/v1/exchangerate/GVT')
      .with( headers: { 'X-CoinAPI-Key' => '123' })
      .to_return(status: 200, body: file_fixture('quotes.json'))

    allow(ENV).to receive(:fetch).with('COINAPI_KEY').and_return('123')
  end

  it 'loads data and creates records' do
    task.invoke

    expect(Entry.count).to eq 1
    expect(Entry.last.gvt_invested).to eq 3_624
    expect(Entry.last.btc_invested).to be_within(0.001).of(3.6689)
    expect(Entry.last.usd_invested).to eq 15_007
    expect(Entry.last.investors_count).to eq 201
    expect(Entry.last.trades_count).to eq 1_454
    expect(Entry.last.vehicles_count).to eq 164
  end
end

