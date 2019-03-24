# frozen_string_literal: true

describe Tweet do
  describe '#status' do
    before do
      @today = create(:entry,
                      gvt_invested: 102_800,
                      btc_invested: 25.1298,
                      usd_invested: 420_123,
                      investments_count: 100,
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
      expect(status).to include "👥  100 investments\n"
      expect(status).to include "📗  4,200 trades\n"
      expect(status).to include "👨‍💻  333 programs and funds"
    end

    it 'shows daily change correctly when it goes down' do
      @today.update(usd_invested: 385_000)
      status = Tweet.status
      expect(status).to include "📉  USD -3.7% / BTC 14.2% / GVT 2.8% 24h change\n"
    end
  end

  describe '#managers' do
    before do
      @today = create(:entry, gvt_usd: 4.05546952253,
                     programs: [
                       ["ARK Invest - FOREX", "8206.295928", "forex"],
                       ["Bitkolik", "7474.9889201856", "crypto"],
                       ["GMTrade II", "5952.4386406848", "crypto"],
                       ["Accor Invest", "5523.1571185472", "crypto"]])
    end

    it 'includes all necessary info' do
      status = Tweet.managers
      expect(status).to include "GVT manager stats"
      expect(status).to include "🥇  ARK Invest - FOREX: $33,280 AUM (forex)\n"
      expect(status).to include "🥈  Bitkolik: $30,315 AUM (crypto)\n"
      expect(status).to include "🥉  GMTrade II: $24,140 AUM (crypto)\n"
      expect(status).to include "💸  $110,134 total AUM in programs"
    end
  end
end
