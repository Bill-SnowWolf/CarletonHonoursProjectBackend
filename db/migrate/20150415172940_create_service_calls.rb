class CreateServiceCalls < ActiveRecord::Migration
  def change
    create_table :service_calls do |t|
      t.string :device_token
      t.string :status
      t.belongs_to :user
      t.timestamps
    end
  end
end
