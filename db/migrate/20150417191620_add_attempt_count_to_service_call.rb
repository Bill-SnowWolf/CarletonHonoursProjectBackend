class AddAttemptCountToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :attempt_count, :integer, default: 0
  end
end
