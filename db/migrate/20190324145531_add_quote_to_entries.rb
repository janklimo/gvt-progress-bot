class AddQuoteToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :gvt_usd, :float
  end
end
