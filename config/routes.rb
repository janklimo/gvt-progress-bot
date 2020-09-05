# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts

  root 'charts#usd'

  get 'charts/managers', to: 'charts#managers'
  get 'charts/funds', to: 'charts#funds'
end
