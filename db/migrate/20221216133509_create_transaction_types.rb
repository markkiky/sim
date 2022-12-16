class CreateTransactionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_types do |t|
      t.bigint :bank_id
      t.string :name

      t.timestamps
    end
  end
end
