# frozen_string_literal: true

describe Tweet do
  describe '#status' do
    before do
      @today = create(:entry,
                      usd_invested: 420_123,
                      investments_count: 100,
                      vehicles_count: 333)
      # yesterday
      create(:entry, usd_invested: 400_000, created_at: 1.day.ago)
    end

    it 'includes all necessary info' do
      status = Tweet.status
      expect(status).to include "💸  420,123 USD invested\n"
      expect(status).to include "📈  USD 5.0% 24h change\n"
      expect(status).to include "👥  100 investments\n"
      expect(status).to include "👨‍💻  333 programs and funds"
    end

    it 'shows daily change correctly when it goes down' do
      @today.update(usd_invested: 385_000)
      status = Tweet.status
      expect(status).to include "📉  USD -3.7% 24h change\n"
    end
  end

  describe '#managers' do
    before do
      @today = create(:entry,
                      programs: [
                        ["ARK Invest - FOREX", "8206.295928", "forex"],
                        ["Bitkolik", "7474.9889201856", "crypto"],
                        ["GMTrade II", "5952.4386406848", "crypto"],
                        ["Accor Invest", "5523.1571185472", "crypto"]])
    end

    it 'includes all necessary info' do
      status = Tweet.managers
      expect(status).to include "GVT manager stats"
      expect(status).to include "🥇  ARK Invest - FOREX: $8,206 AUM (forex)\n"
      expect(status).to include "🥈  Bitkolik: $7,475 AUM (crypto)\n"
      expect(status).to include "🥉  GMTrade II: $5,952 AUM (crypto)\n"
      expect(status).to include "💸  $27,157 total AUM in programs"
    end
  end
end
