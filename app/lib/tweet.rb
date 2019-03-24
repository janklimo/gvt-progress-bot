# frozen_string_literal: true

module Tweet
  extend ActionView::Helpers::NumberHelper

  module_function

  def status
    date = Date.today.strftime("%b %-d, %Y")
    entry = Entry.order(:created_at).last

    # $GVT stats Jan 11, 2019:
    #
    # 💸  402,626 USD / 110.6 BTC / 115,036 GVT invested
    # 📈  USD 1.2% / BTC 2.1% / GVT -1.8% 24h change
    # 👥  2,662 investments
    # 📗  60,915 trades
    # 👨‍💻  192 programs and funds

    "$GVT stats #{date}:\n\n" \
      "#{aum(entry)}" \
      "#{daily_change(entry)}" \
      "👥  #{number_with_delimiter(entry.investments_count)} investments\n" \
      "📗  #{number_with_delimiter(entry.trades_count)} trades\n" \
      "👨‍💻  #{number_with_delimiter(entry.vehicles_count)} programs and funds"
  end

  def aum(entry)
    "💸  #{number_with_delimiter(entry.usd_invested)} USD / " \
      "#{number_with_precision(entry.btc_invested, precision: 1, delimiter: ',')} BTC / " \
      "#{number_with_delimiter(entry.gvt_invested)} GVT invested\n" \
  end

  def daily_change(entry)
    yesterday = Entry.order(:created_at).second_to_last

    daily_change_btc =
      ((entry.btc_invested.to_f / yesterday.btc_invested.to_f) - 1) * 100

    daily_change_usd =
      ((entry.usd_invested.to_f / yesterday.usd_invested.to_f) - 1) * 100

    daily_change_gvt =
      ((entry.gvt_invested.to_f / yesterday.gvt_invested.to_f) - 1) * 100

    emoji = daily_change_usd > 0 ?  "📈" : "📉"

    "#{emoji}  USD #{number_to_percentage(daily_change_usd, precision: 1)} / " \
      "BTC #{number_to_percentage(daily_change_btc, precision: 1)} / " \
      "GVT #{number_to_percentage(daily_change_gvt, precision: 1)} 24h change\n"
  end

  def managers
    # $GVT manager stats Jan 11, 2019:
    #
    # 🥇  Bitkolik: $43,219 AUM (crypto)
    # 🥈  Manager 2: $33,219 AUM (forex)
    # 🥉  Manager 3: $13,219 AUM (crypto)
    # 💸  $402,626 total AUM in programs

    date = Date.today.strftime("%b %-d, %Y")
    entry = Entry.order(:created_at).last
    programs = entry.programs
    gvt_usd = entry.gvt_usd
    total = (programs.sum { |e| e[1].to_f } * gvt_usd)

    "$GVT manager stats #{date}:\n\n" \
      "🥇  #{manager_line(programs[0], gvt_usd)}\n" \
      "🥈  #{manager_line(programs[1], gvt_usd)}\n" \
      "🥉  #{manager_line(programs[2], gvt_usd)}\n" \
      "💸  #{number_to_currency(total, precision: 0)} total AUM in programs"
  end

  def manager_line(program, gvt_usd)
    # program: [title, amount, currency]
    amount = number_to_currency(program[1].to_f * gvt_usd, precision: 0)
    "#{program[0]}: #{amount} AUM (#{program[2]})"
  end
end
