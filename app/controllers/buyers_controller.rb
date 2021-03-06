class BuyersController < ApplicationController
  require 'payjp'
  before_action :authenticate_user!
  before_action :set_card,:set_item

  def index
    @address = Address.where(user_id: current_user.id).first
    if @card.present?
      Payjp.api_key = Rails.application.credentials.dig(:payjp, :secret_key)
      customer = Payjp::Customer.retrieve(@card.customer_id) 
      @default_card_information = customer.cards.retrieve(@card.card_id)
      @card_brand = @default_card_information.brand
      case @card_brand
      when "Visa"
        @card_src = "visa.png"
      when "JCB"
        @card_src = "jcb.jpeg"
      when "MasterCard"
        @card_src = "master.png"
      when "American Express"
        @card_src = "amex.png"
      when "Diners Club"
        @card_src = "diners.gif"
      when "Discover"
        @card_src = "discover.jpg"
      end
    else
      redirect_to new_card_path
    end
  end

  def pay
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :secret_key)
    Payjp::Charge.create(
      :amount => @items.price, 
      :customer => @card.customer_id,
      :currency => 'jpy',
    )
    @item_buyer= Item.find(params[:item_id])
    @item_buyer.update( buyer_id: current_user.id)

    redirect_to done_item_buyers_path
  end

  def done
  end


  private

  def set_card
    @card = CreditCard.find_by(user_id: current_user.id)
  end

  def set_item
    @items = Item.find(params[:item_id])
  end

end