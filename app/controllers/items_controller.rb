class ItemsController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index

    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, except: [:created_at, :updated_at], include: {user: {except: [:created_at, :updated_at]}}
  end

  def show
    item = Item.find(params[:id])
    render json: item, except: [:created_at, :updated_at], include: {user: {except: [:created_at, :updated_at]}}
  end

  def create
    user = User.find(params[:user_id])
    new_item = user.items.create(item_params)
    render json: new_item, status: :created
  end


  private 

  def item_params
    params.permit(:name, :description, :price)
  end


  def render_not_found_response
    render json: { error: 'User not found' }, status: :not_found
  end

end
