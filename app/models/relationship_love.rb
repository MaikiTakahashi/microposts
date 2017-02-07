class RelationshipLove < ActiveRecord::Base
  belongs_to :lover, class_name: "User"
  belongs_to :loved, class_name: "Micropost"
end
