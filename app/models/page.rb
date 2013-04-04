# encoding: utf-8

class Page < ActiveRecord::Base
  # Relation ship
  belongs_to :author,
    class_name: 'User',
    foreign_key: :author_id
  belongs_to :category,
    class_name: 'PageCategory',
    foreign_key: :category_id

  # ページのツリー構造
  # 親ページ
  belongs_to :parent,
    class_name: 'Page',
    foreign_key: :parent_id
  # 子ページ
  has_many :children,
    class_name: 'Page',
    foreign_key: :parent_id


  # Validation
  # 必須項目
  validates :published, :author_id,
    presence: true

  validates :name,
    presence: true,
    uniqueness: true,
    format: { with: /[a-zA-Z0-9_\-]+/ }

  # 関連先の存在チェック
  validate :author_exists?
  validate :category_exists?
  validate :parent_exists?


  private

  def author_exists?
    errors.add(:author_id, 'はDBに存在しません．') unless User.exists?(author_id)
  end

  def category_exists?
    # 空欄は許可
    # 空欄じゃ無いときカテゴリが存在するかチェック
    errors.add(:category_id, 'はDBに存在しません．') unless category_id.nil? || PageCategory.exists?(category_id)
  end

  def parent_exists?
    # 親ページが存在するかチェック
    # parent_id無しは許可（親無し）
    errors.add(:parent_id, 'ページはDBに存在しません．') unless parent_id.nil? || Page.exists?(parent_id)
  end
end