class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorited_books, through: :favorites, source: :book
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_one_attached :profile_image

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: {maximum: 50}
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(other_user)
    relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def today_posts
    books.where(created_at: Time.zone.now.all_day).count
  end

  # 昨日の投稿数
  def yesterday_posts
    books.where(created_at: 1.day.ago.all_day).count
  end

  # 前日比（昨日と今日の比率）
  def daily_comparison
    return 0 if yesterday_posts == 0
    (today_posts.to_f / yesterday_posts.to_f * 100).round
  end

  # 今週の投稿数（例：土曜〜金曜を1週間とする場合）
  def this_week_posts
    books.where(created_at: Time.zone.now.all_week(:saturday)).count
  end

  # 先週の投稿数
  def last_week_posts
    books.where(created_at: 1.week.ago.all_week(:saturday)).count
  end

  # 前週比
  def weekly_comparison
    return 0 if last_week_posts == 0
    (this_week_posts.to_f / last_week_posts.to_f * 100).round
  end
end
