class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, default: ''
      t.decimal :price, default: 0.0
      t.boolean :published, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
