# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts

  root 'charts#gvt'

  get 'charts/btc', to: 'charts#btc'
  get 'charts/gvt', to: 'charts#gvt'
  get 'charts/usd', to: 'charts#usd'

  get 'charts/managers', to: 'charts#managers'
end
