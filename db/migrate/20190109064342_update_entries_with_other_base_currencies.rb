class UpdateEntriesWithOtherBaseCurrencies < ActiveRecord::Migration[5.2]
  def change
    drop_table :quotes

    add_column :entries, :usd_invested, :integer
    add_column :entries, :btc_invested, :float
  end
end
