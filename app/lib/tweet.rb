# frozen_string_literal: true

module Tweet
  extend ActionView::Helpers::NumberHelper

  REFERRAL_LINK = 'https://genesis.vision/?ref=228295'

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
      "👨‍💻  #{number_with_delimiter(entry.vehicles_count)} programs and funds\n\n" \
      "🚀  Invest now: #{REFERRAL_LINK}"
  end

  def daily_change(entry)
    yesterday = Entry.order(:created_at).second_to_last

    daily_change_usd =
      ((entry.usd_invested.to_f / yesterday.usd_invested.to_f) - 1) * 100

    emoji = daily_change_usd > 0 ?  "📈" : "📉"

    "#{emoji}  USD #{number_to_percentage(daily_change_usd, precision: 1)} 24h change\n"
  end

  def managers
    # $GVT managers stats Jan 11, 2019:
    #
    # 🥇  Bitkolik: $43,219 AUM (crypto)
    # 🥈  Manager 2: $33,219 AUM (forex)
    # 🥉  Manager 3: $13,219 AUM (crypto)
    # 💸  $402,626 total AUM in 123 programs
    #
    # 🚀  Invest now: https://genesis.vision/?ref=228295

    date = Date.today.strftime("%b %-d, %Y")
    entry = Entry.order(:created_at).last
    programs = entry.programs
    total = programs.sum { |e| e[1].to_f }

    "$GVT managers stats #{date}:\n\n" \
      "🥇  #{manager_line(programs[0])}\n" \
      "🥈  #{manager_line(programs[1])}\n" \
      "🥉  #{manager_line(programs[2])}\n" \
      "💸  #{number_to_currency(total, precision: 0)} total AUM " \
      "in #{programs.size} programs\n\n" \
      "🚀  Invest now: #{REFERRAL_LINK}"
  end

  def funds
    # $GVT funds stats Jan 11, 2019:
    #
    # 🥇  Bitkolik: $43,219 AUM
    # 🥈  Manager 2: $33,219 AUM
    # 🥉  Manager 3: $13,219 AUM
    # 💸  $402,626 total AUM in 212 funds
    #
    # 🚀  Invest now: https://genesis.vision/?ref=228295

    date = Date.today.strftime("%b %-d, %Y")
    entry = Entry.order(:created_at).last
    funds = entry.funds
    total = funds.sum { |e| e[1].to_f }

    "$GVT funds stats #{date}:\n\n" \
      "🥇  #{fund_line(funds[0])}\n" \
      "🥈  #{fund_line(funds[1])}\n" \
      "🥉  #{fund_line(funds[2])}\n" \
      "💸  #{number_to_currency(total, precision: 0)} total AUM " \
      "in #{funds.size} funds\n\n" \
      "🚀  Invest now: #{REFERRAL_LINK}"
  end

  def manager_line(program)
    # program: [title, amount, type]
    amount = number_to_currency(program[1].to_f, precision: 0)
    "#{program[0]}: #{amount} AUM (#{program[2]})"
  end

  def fund_line(fund)
    # fund: [title, amount]
    amount = number_to_currency(fund[1].to_f, precision: 0)
    "#{fund[0]}: #{amount} AUM"
  end
end
