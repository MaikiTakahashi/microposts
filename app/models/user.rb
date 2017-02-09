class User < ActiveRecord::Base
    mount_uploader :avatar, AvatarUploader

    before_save { self.email = self.email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    
    has_many :following_relationships, class_name: "Relationship", 
                                    foreign_key: "follower_id", 
                                    dependent: :destroy
    has_many :following_users, through: :following_relationships, source: :followed 

    has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower

    has_many :loving_relationships, class_name: "RelationshipLove", foreign_key: "lover_id", dependent: :destroy
    has_many :loving_microposts, through: :loving_relationships, source: :loved

    # 他のユーザーをフォローする
    def follow(other_user)
      following_relationships.find_or_create_by(followed_id: other_user.id)
    end

    # フォローしているユーザーをアンフォローする
    def unfollow(other_user)
      following_relationship = following_relationships.find_by(followed_id: other_user.id)
      following_relationship.destroy if following_relationship
    end
     
    # あるユーザーをフォローしているかどうか
    def following?(other_user)
      following_users.include?(other_user)
    end

    # 投稿にラブする
    def love(micropost)
      loving_relationships.find_or_create_by(loved_id: micropost.id)
    end
    
    # ラブした投稿にアンラブする
    def unlove(micropost)
      loving_relationship = loving_relationships.find_by(loved_id: micropost.id)
      loving_relationship.destroy if loving_relationship
    end
    
    # ある投稿をラブしているかどうか？
    def loving?(micropost)
      loving_microposts.include?(micropost)
    end
    
    def feed_items
      Micropost.where(user_id: following_user_ids + [self.id])
    end
end