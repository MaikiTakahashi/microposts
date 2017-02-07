class CreateRelationshipLoves < ActiveRecord::Migration
  def change
    create_table :relationship_loves do |t|
      t.references :lover, index: true
      t.references :loved, index: true

      t.timestamps null: false
      
      t.index [:lover_id, :loved_id], unique: true
    end
  end
end
