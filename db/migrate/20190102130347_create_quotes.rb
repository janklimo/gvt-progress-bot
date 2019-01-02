class CreateQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes do |t|
      t.float :btcusd
      t.float :gvtusd

      t.timestamps
    end
  end
end
