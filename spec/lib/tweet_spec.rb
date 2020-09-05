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
      expect(status).to include Tweet::REFERRAL_LINK
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
                        ['ARK Invest - FOREX', '8206.295928', 'forex'],
                        ['Bitkolik', '7474.9889201856', 'crypto'],
                        ['GMTrade II', '5952.4386406848', 'crypto'],
                        ['Accor Invest', '5523.1571185472', 'crypto']])
    end

    it 'includes all necessary info' do
      status = Tweet.managers
      expect(status).to include "GVT managers stats"
      expect(status).to include "🥇  ARK Invest - FOREX: $8,206 AUM (forex)\n"
      expect(status).to include "🥈  Bitkolik: $7,475 AUM (crypto)\n"
      expect(status).to include "🥉  GMTrade II: $5,952 AUM (crypto)\n"
      expect(status).to include "💸  $27,157 total AUM in 4 programs"
      expect(status).to include Tweet::REFERRAL_LINK
    end
  end

  describe '#funds' do
    before do
      @today = create(:entry,
                      funds: [
                        ['Lambo Fund', '55034.997720182524'],
                        ['DeFi Basket', '17437.57447819529'],
                        ['BlockTarioGrowth', '15640.085708927814'],
                        ['Oracle Basket', '12750.538709311439'],
                        ['ETH Centric', '6857.524555679148'],
                      ]
                     )
    end

    it 'includes all necessary info' do
      status = Tweet.funds
      expect(status).to include "GVT funds stats"
      expect(status).to include "🥇  Lambo Fund: $55,035 AUM\n"
      expect(status).to include "🥈  DeFi Basket: $17,438 AUM\n"
      expect(status).to include "🥉  BlockTarioGrowth: $15,640 AUM\n"
      expect(status).to include "💸  $107,721 total AUM in 5 funds"
      expect(status).to include Tweet::REFERRAL_LINK
    end
  end
end
