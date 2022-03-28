class AddUuidToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :uuid, :string
  end
end
