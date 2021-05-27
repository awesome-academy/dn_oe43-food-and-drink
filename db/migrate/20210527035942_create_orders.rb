class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :string
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
