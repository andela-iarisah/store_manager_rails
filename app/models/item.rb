class Item < ActiveRecord::Base
  before_save :capitalize, :add_brand

  belongs_to :admin_user
  has_many :transactions

  validate :min_qty_is_not_zero
  validates :category, presence: true
  validates :name,
            uniqueness: { case_sensitive: false,
                          message: "This item already exists",
                          scope: :admin_user_id }
  validates :quantity, :quantity_sold, :min_qty, :new_stock,
            numericality: { greater_than_or_equal_to: 0,
                            only_integer: true }

  scope :search_items, -> (q) {
    where('LOWER(category) like ? OR LOWER(brand) like ? OR LOWER(name) like ?',
          *(["%#{q.downcase}%"] * 3)) # LOWER and Downcase make the query case-insensitive
  }

  scope :filtered_categories, -> (cat) {
    where(category: cat)
  }

  CATEGORY_LIST = [
      "Books",
      "Fashion",
      "Mobile Phones",
      "Computing",
      "Electronics",
      "Games",
      "Home",
      "Health & Beauty",
      "Movies",
      "Music",
      "Office",
      "Watches",
      "Sunglasses",
      "Toys for Kids",
      "Other Categories"
  ]

  def validate_min_quantity?
    min_qty < quantity
  end

  def send_min_qty_notice
    MinQtyMailer.notice(admin_user, self).deliver_now if min_qty_reached?
  end

  private

  def min_qty_reached?
    quantity <= min_qty
  end

  def min_qty_is_not_zero
    unless valid_values?
      errors.add(:min_qty, "should not be 0") if min_qty == 0
    end
  end

  def valid_values?
    quantity == nil || min_qty == nil
  end

  def capitalize
    self.name = name.titleize unless name == name.upcase
    self.brand = brand.titleize unless brand == brand.upcase
  end

  def add_brand
    self.brand = '--' if brand.blank?
  end
end
