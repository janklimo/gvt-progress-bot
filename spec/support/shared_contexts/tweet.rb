# frozen_string_literal: true

shared_context "tweet" do
  before do
    create(:entry,
           usd_invested: 102_800,
           investments_count: 100,
           vehicles_count: 333,
           programs: [
             ["ARK Invest - FOREX", "8206.295928", "forex"],
             ["Bitkolik", "7474.9889201856", "crypto"],
             ["GMTrade II", "5952.4386406848", "crypto"],
           ],
           funds: [
             ['Lambo Fund', '55034.997720182524'],
             ['DeFi Basket', '17437.57447819529'],
             ['BlockTarioGrowth', '15640.085708927814'],
             ['Oracle Basket', '12750.538709311439'],
             ['ETH Centric', '6857.524555679148'],
           ]
          )
    create(:entry, usd_invested: 100_000, created_at: 1.day.ago)

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
end

