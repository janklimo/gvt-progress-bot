# frozen_string_literal: true

class ChartsController < ApplicationController
  def index
    @chart_data = Entry.order(:created_at).all.pluck(:created_at, :gvt_invested)
  end
end
