class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :public_id, limit: 18, null: false
      t.string :name
      t.string :country

      t.timestamps
    end
    add_index :customers, :public_id, unique: true
  end
end
