class Api::CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories
  end

  def show
    category = select_category
    render json: category
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: category
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def select_category
    category = Category.find(params[:id])
  end
end