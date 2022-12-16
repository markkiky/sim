class CreateTransactionJoins < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_joins do |t|
      t.bigint :payment_id
      t.bigint :transaction_type_id

      t.timestamps
    end
  end
end
