class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :status, default: 'offline'
      t.timestamps
    end
  end
end
