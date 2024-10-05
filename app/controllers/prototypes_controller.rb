class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :update, :destroy]
  before_action :set_prototype, only: [:edit]
  before_action :check_authorization, only: [:edit]
  def index
    @prototypes = Prototype.all
  end
  def new
    @prototypes = Prototype.new
  end
  def create
    @prototypes = Prototype.new(prototype_params)
    if @prototypes.save
      redirect_to '/'
    else
      render :new
    end
  end
  def show
    Rails.logger.debug("Prototype: #{@prototypes.inspect}")
    Rails.logger.debug("Comment: #{@comment.inspect}")
    Rails.logger.debug("Comments: #{@comments.inspect}")
    @prototypes = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototypes.comments.includes(:user) 

  end
  def edit
    unless user_signed_in?
      redirect_to action: :index
    end
    @prototypes = Prototype.find(params[:id])
  end
  def update
    prototypes = Prototype.find(params[:id])
    if prototypes.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end
  def destroy
    prototypes = Prototype.find(params[:id])
    prototypes.destroy
    redirect_to root_path
  end
  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  def set_prototype
    @prototypes = Prototype.find(params[:id])
  end
  def check_authorization
    unless @prototypes.user == current_user
      redirect_to action: :index
    end
  end

end
