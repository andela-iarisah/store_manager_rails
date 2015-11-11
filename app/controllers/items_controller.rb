class ItemsController < ApplicationController
  before_action :get_user

  def index
    @items = @user.admin_user.items
  end

  def sell
    @item = Item.find(params[:id])
  end

  def update_sale
    @item = Item.find(params[:id])

    qty_sold = (params[:item][:quantity_sold]).to_i

    if qty_sold >= 0

      @item.quantity = @item.quantity - qty_sold

      if @item.save
        if qty_sold == 0
          redirect_to items_path, notice: "No sale"
        else
          redirect_to items_path,
          notice: "You just sold #{qty_sold} piece(s) of #{@item.name}"
        end
      else
        redirect_to sell_item_path,
        notice: "Quantity sold should be less than the available stock"
      end
    else
      flash[:notice] = "Invalid Quantity"
      render :sell
    end
  end
end
