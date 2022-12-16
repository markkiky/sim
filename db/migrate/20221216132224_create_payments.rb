class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.bigint :user_id
      t.integer :payment_type, default: 0
      t.string :payment_id, limit: 30
      t.bigint :bank_id
      t.bigint :party_id
      t.decimal :amount
      t.decimal :transaction_cost
      t.datetime :transaction_date

      t.timestamps
    end

    add_index :payments, %i[user_id payment_id], unique: true
  end
end
