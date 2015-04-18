class AddCustomerDataToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :name, :string
    add_column :service_calls, :phone, :string
    add_column :service_calls, :email, :string
  end
end
