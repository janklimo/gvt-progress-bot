# frozen_string_literal: true

describe 'data:fetch' do
  include_context 'rake'

  before do
    stub_request(:get, 'https://genesis.vision/api/v1.0/programs')
      .to_return(status: 200, body: file_fixture('programs.json'))

    stub_request(:get, 'https://genesis.vision/api/v1.0/funds')
      .to_return(status: 200, body: file_fixture('funds.json'))
  end

  it 'loads data and creates records' do
    task.invoke

    expect(Entry.count).to eq 1
    expect(Entry.last.gvt_invested).to eq 3_624
    expect(Entry.last.investors_count).to eq 201
    expect(Entry.last.trades_count).to eq 1_454
    expect(Entry.last.vehicles_count).to eq 164
  end
end

