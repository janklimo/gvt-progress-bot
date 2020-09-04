# frozen_string_literal: true

module Tweet
  extend ActionView::Helpers::NumberHelper

  module_function

  def status
    date = Date.today.strftime("%b %-d, %Y")
    entry = Entry.order(:created_at).last

    # $GVT stats Jan 11, 2019:
    #
    # 💸  402,626 USD invested
    # 📈  USD 1.2% 24h change
    # 👥  2,662 investments
    # 👨‍💻  192 programs and funds
    #
    # 🚀  Invest now: https://genesis.vision/?ref=228295

    "$GVT stats #{date}:\n\n" \
      "💸  #{number_with_delimiter(entry.usd_invested)} USD invested\n" \
      "#{daily_change(entry)}" \
      "👥  #{number_with_delimiter(entry.investments_count)} investments\n" \
      "👨‍💻  #{number_with_delimiter(entry.vehicles_count)} programs and funds"
  end

  def daily_change(entry)
    yesterday = Entry.order(:created_at).second_to_last

    daily_change_usd =
      ((entry.usd_invested.to_f / yesterday.usd_invested.to_f) - 1) * 100

    emoji = daily_change_usd > 0 ?  "📈" : "📉"

    "#{emoji}  USD #{number_to_percentage(daily_change_usd, precision: 1)} 24h change\n"
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
    total = programs.sum { |e| e[1].to_f }

    "$GVT manager stats #{date}:\n\n" \
      "🥇  #{manager_line(programs[0])}\n" \
      "🥈  #{manager_line(programs[1])}\n" \
      "🥉  #{manager_line(programs[2])}\n" \
      "💸  #{number_to_currency(total, precision: 0)} total AUM in programs"
  end

  def manager_line(program)
    # program: [title, amount, type]
    amount = number_to_currency(program[1].to_f, precision: 0)
    "#{program[0]}: #{amount} AUM (#{program[2]})"
  end
end
