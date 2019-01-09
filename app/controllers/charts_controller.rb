# frozen_string_literal: true

class ChartsController < ApplicationController
  def index
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :gvt_invested)
    @entry = Entry.order(:created_at).last
  end
end
