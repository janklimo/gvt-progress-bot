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
    @entry = Entry.order(:created_at).last
    programs_endpoint = 'https://genesis.vision/api/v1.0/programs'

    # programs
    res = HTTParty.get(programs_endpoint)
    data = JSON.parse(res.body)

    programs = data['programs']

    entries = programs.map do |program|
      title = program['title']
      amount = program['statistic']['balanceGVT']['amount']
      [title, amount, 'crypto']
    end

    # sort by amount
    @chart_data = entries.sort_by { |e| e[1] }.reverse

    # show top 10
    # -> greater than amount of 11th element
    @cutoff = @chart_data[10][1]
  end
end
