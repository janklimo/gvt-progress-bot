# frozen_string_literal: true

class ChartsController < ApplicationController
  def index
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :gvt_invested)
    @entry = Entry.order(:created_at).last

    quote = Quote.order(:created_at).last
    @usd_amount = quote.usd_amount_for(@entry.gvt_invested).to_i
    @btc_amount = quote.btc_amount_for(@entry.gvt_invested).to_i
  end
end
