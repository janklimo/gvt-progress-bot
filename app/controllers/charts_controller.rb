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

  def managers
    entry = Entry.order(:created_at).last
    @chart_data = entry.programs
    # [title, amount, currency]
    @total = (entry.programs.sum { |e| e[1].to_f } * entry.gvt_usd).to_i

    # show top 10
    # -> greater than amount of 11th element
    @cutoff = @chart_data[10][1]
  end
end
