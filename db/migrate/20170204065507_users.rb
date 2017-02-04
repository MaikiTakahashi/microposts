class Users < ActiveRecord::Migration
  def change
    change_column :users, :live, :string
    change_column :users, :introduction, :string 
  end
end
