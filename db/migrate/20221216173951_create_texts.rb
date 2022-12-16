class CreateTexts < ActiveRecord::Migration[7.0]
  def change
    create_table :texts do |t|
      t.bigint :user_id
      t.bigint :bank_id
      t.string :message
      t.string :message_hash
      t.json :data

      t.timestamps
    end

    add_index :texts, [:message_hash], unique: true
  end
end
