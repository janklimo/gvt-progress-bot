class RenameInvestorsToInvestments < ActiveRecord::Migration[5.2]
  def change
    rename_column :entries, :investors_count, :investments_count
  end
end
