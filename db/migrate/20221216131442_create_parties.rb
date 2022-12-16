class CreateParties < ActiveRecord::Migration[7.0]
  def change
    create_table :parties do |t|
      t.bigint :user_id
      t.string :name
      t.string :account_no

      t.timestamps
    end
  end
end
