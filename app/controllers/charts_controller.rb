# frozen_string_literal: true

class ChartsController < ApplicationController
  def usd
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :usd_invested)
    @entry = Entry.order(:created_at).last
  end

  def managers
    entry = Entry.order(:created_at).last
    @chart_data = entry.programs
    # [title, amount, type]
    @total = (entry.programs.sum { |e| e[1].to_f }).to_i

    # show top 10
    # -> greater than amount of 11th element
    @cutoff = @chart_data[10][1]
  end

  def funds
    entry = Entry.order(:created_at).last
    # Already sorted in desc order
    @chart_data = entry.funds
    # [title, amount]
    @total = (entry.funds.sum { |e| e[1].to_f }).to_i

    # show top 10
    # -> greater than amount of 11th element
    @cutoff = @chart_data[10][1]
  end
end
