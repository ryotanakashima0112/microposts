class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                    # format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\z/i },
                    uniqueness: {case_sensitive: false}
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  has_many :favorites
  has_many :likings, through: :favorites, source: :micropost
  has_many :reverses_of_favorite, class_name: "Favorite", foreign_key: 'micropost_id'
  has_many :likers, through: :reverses_of_favorite, source: :user
  
  def like(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unlike(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def liking?(micropost)
    self.likings.include?(micropost)
  end
end