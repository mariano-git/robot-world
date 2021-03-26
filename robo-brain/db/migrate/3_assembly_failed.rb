class AssemblyFailed < ActiveRecord::Migration[6.1]
  def change
    add_column :assembly, :failed, :boolean
  end
end
