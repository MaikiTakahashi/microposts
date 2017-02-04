class AddLiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :live, :integer
    add_column :users, :introduction, :integer    
  end
end
