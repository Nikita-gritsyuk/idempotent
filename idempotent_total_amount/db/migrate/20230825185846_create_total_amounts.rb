class CreateTotalAmounts < ActiveRecord::Migration[7.0]
  def change
    create_table "total_amounts", id: { type: :integer, as: 1, stored: true, default: nil }, force: :cascade do |t|
      t.integer "value", default: 0, null: false
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
    end
  end
end
