class AddManagersToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :programs, :text, array: true, default: []
  end
end
