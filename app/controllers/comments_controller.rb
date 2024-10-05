class CommentsController < ApplicationController
  def create
    #Comment.create(comment_params)
    @prototypes = Prototype.find(params[:prototype_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to prototype_path(@comment.prototype) # 今回の実装には関係ありませんが、このようにPrefixでパスを指定することが望ましいです。
    else
      @prototypes = @comment.prototype
      @comments = @prototypes.comments
      render "prototypes/show", status: :unprocessable_entity
    end
  end

  
  private
  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
