class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @table = Table.find(params[:table_id])
    @order = @table.orders.build(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy

    head :no_content
  end

  def add_item
    @order = Order.find params[:id]
    order_item = OrderItem.where(order_id: @order.id, item_id: params[:item_id].first.increment(:quantity) rescue
      order_item = @order_items.build(item_id: params[:id])

    if  order_item.save
      render json: order_item, status: 201
    else
      render json: order_item.errors, status: unprocessable_entity
    end
  end

  def pay
    @order = Order.find(params[:id])
      if @order.total_amount == params[:amount]
        @receipt = Receipt.new(order: @order, payment_method: params[:payment_method ])

        if @receipt.save
          render json: @receipt, status: 204
        else
          render json: @receipt.errors, status: 422
        end
      end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:name, :email, :table_id)
    end
end
