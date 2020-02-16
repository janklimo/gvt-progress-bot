# frozen_string_literal: true

describe 'tweet:post' do
  include_context 'rake'

  before do
    create(:entry, gvt_invested: 102_800, investments_count: 100,
           trades_count: 4_200, vehicles_count: 333)
    create(:entry, gvt_invested: 100_000, created_at: 1.day.ago)

    allow(IMGKit).to receive(:new).and_return(double(to_file: Tempfile.new))
    @tweet_url = 'https://twitter.com/janklimo/status/1098890150954754048'
    allow_any_instance_of(Twitter::REST::Client)
      .to receive(:update_with_media)
      .and_return(double(uri: Addressable::URI.parse(@tweet_url)))

    stub_request(:get, ENV.fetch('HOST'))
      .to_return(status: 200, body: file_fixture('programs.json'))

    allow_any_instance_of(Discordrb::Bot).to receive(:run)
    allow_any_instance_of(Discordrb::Bot).to receive(:stop)
  end

  it 'posts tweet with media' do
    expect_any_instance_of(Twitter::REST::Client)
      .to receive(:update_with_media).with(/102,800 GVT invested/, anything)
    expect_any_instance_of(Discordrb::Bot)
      .to receive(:send_message).with(String, @tweet_url)
    task.invoke
  end
end

