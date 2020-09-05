class AddFundsToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :funds, :text, array: true, default: []
  end
end
