# frozen_string_literal: true

module Tweet
  extend ActionView::Helpers::NumberHelper

  def self.status
    date = Date.today.strftime("%b %-d, %Y")
    entry = Entry.order(:created_at).last
    entry_yesterday = Entry.order(:created_at).second_to_last

    daily_change =
      ((entry.gvt_invested.to_f / entry_yesterday.gvt_invested.to_f) - 1) * 100

    change_label = daily_change > 0 ?  "📈  Up" : "📉  Down"

    "$GVT stats #{date}:\n\n" \
      "💸  #{number_with_delimiter(entry.gvt_invested)} GVT invested\n" \
      "#{change_label} #{number_to_percentage(daily_change.abs, precision: 1)} since yesterday\n" \
      "👥  #{number_with_delimiter(entry.investors_count)} investors\n" \
      "📗  #{number_with_delimiter(entry.trades_count)} trades\n" \
      "👨‍💻  #{number_with_delimiter(entry.vehicles_count)} programs and funds"
  end
end
