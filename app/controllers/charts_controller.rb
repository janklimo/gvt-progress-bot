# frozen_string_literal: true

class ChartsController < ApplicationController
  def gvt
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :gvt_invested)
    @entry = Entry.order(:created_at).last
  end

  def btc
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :btc_invested)
    @entry = Entry.order(:created_at).last
  end

  def usd
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :usd_invested)
    @entry = Entry.order(:created_at).last
  end
end
