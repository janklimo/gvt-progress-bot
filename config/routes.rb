# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts

  root 'charts#index'

  get 'charts/btc', to: 'charts#index'
  get 'charts/gvt', to: 'charts#index'
  get 'charts/usd', to: 'charts#index'
end
