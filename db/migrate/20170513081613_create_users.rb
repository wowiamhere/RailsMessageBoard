class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :firstName
      t.string :lastName
      t.text :about

      t.timestamps
    end
  end
end
