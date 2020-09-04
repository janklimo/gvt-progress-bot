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
             ["Other #4", "5523.1571185472", "crypto"],
             ["Other #5", "5423.9889201856", "crypto"],
             ["Other #6", "4952.4386406848", "crypto"],
             ["Other #7", "3523.1571185472", "crypto"],
             ["Other #8", "2523.1571185472", "crypto"],
             ["Other #9", "1523.1571185472", "crypto"],
             ["Other #10", "523.1571185472", "crypto"],
             ["Other #11", "23.1571185472", "crypto"],
           ])
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

