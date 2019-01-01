class CreateEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :entries do |t|
      t.integer :gvt_invested
      t.integer :investors_count
      t.integer :trades_count
      t.integer :vehicles_count

      t.timestamps
    end
  end
end
