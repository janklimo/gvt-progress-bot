# frozen_string_literal: true

class Quote < ApplicationRecord
  def usd_amount_for(gvt_amount)
    gvtusd * gvt_amount
  end

  def btc_amount_for(gvt_amount)
    usd_amount_for(gvt_amount) / btcusd
  end
end
