# frozen_string_literal: true

describe Tweet do
  describe '#body_text' do
    before do
      @today = create(:entry,
                      gvt_invested: 102_800,
                      btc_invested: 25.1298,
                      usd_invested: 420_123,
                      investors_count: 100,
                      trades_count: 4_200,
                      vehicles_count: 333)
      # yesterday
      create(:entry, gvt_invested: 100_000, btc_invested: 22,
             usd_invested: 400_000, created_at: 1.day.ago)
    end

    it 'includes all necessary info' do
      status = Tweet.status
      expect(status).to include "💸  420,123 USD / 25.1 BTC / 102,800 GVT invested\n"
      expect(status).to include "📈  USD 5.0% / BTC 14.2% / GVT 2.8% 24h change\n"
      expect(status).to include "👥  100 investors\n"
      expect(status).to include "📗  4,200 trades\n"
      expect(status).to include "👨‍💻  333 programs and funds"
    end

    it 'shows daily change correctly when it goes down' do
      @today.update(usd_invested: 385_000)
      status = Tweet.status
      expect(status).to include "📉  USD -3.7% / BTC 14.2% / GVT 2.8% 24h change\n"
    end
  end
end
