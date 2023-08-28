class CreateNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :numbers do |t|
      t.bigint :value, null: false
      t.bigint :cumulative_sum, null: false, index: true
      t.timestamps
    end
  end
end
