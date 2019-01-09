# frozen_string_literal: true

describe Tweet do
  describe '#body_text' do
    before do
      @today = create(:entry,
                      gvt_invested: 102_800,
                      investors_count: 100,
                      trades_count: 4_200,
                      vehicles_count: 333)
      # yesterday
      create(:entry, gvt_invested: 100_000, created_at: 1.day.ago)
    end

    it 'includes all necessary info' do
      status = Tweet.status
      expect(status).to include "💸  102,800 GVT invested\n"
      expect(status).to include "📈  Up 2.8% since yesterday\n"
      expect(status).to include "👥  100 investors\n"
      expect(status).to include "📗  4,200 trades\n"
      expect(status).to include "👨‍💻  333 programs and funds"
    end

    it 'shows daily change correctly when it goes down' do
      @today.update(gvt_invested: 85_000)
      status = Tweet.status
      expect(status).to include "📉  Down 15.0% since yesterday\n"
    end
  end
end
