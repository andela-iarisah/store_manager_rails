class Item < ActiveRecord::Base
  belongs_to :admin_user

  validate :min_qty_is_less_than_quantity
  validates :category, presence: true
  validates :name,
            uniqueness: { case_sensitive: false,
                          message: "This item already exists",
                          scope: :admin_user_id }
  validates :quantity, :quantity_sold, :min_qty, :new_stock,
            numericality: { greater_than_or_equal_to: 0,
                            only_integer: true }
  ITEM_LIST = [
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

  private

  def min_qty_is_less_than_quantity
    unless valid_values?
      errors.add(:min_qty, "should not be 0") if min_qty == 0
    end
  end

  def valid_values?
    quantity == nil || min_qty == nil
  end
end
