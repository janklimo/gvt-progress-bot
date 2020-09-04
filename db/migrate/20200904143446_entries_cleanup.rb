class EntriesCleanup < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :eth_invested, :float
    remove_column :entries, :trades_count
    remove_column :entries, :gvt_usd
  end
end
