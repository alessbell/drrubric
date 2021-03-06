class GradesController < ApplicationController
  before_action :load_eval, only:[:new]
  before_action :load_student

  def new
    @grade = Grade.new

    @eval.categories.each do |category|
      @grade.scores.build(category_id: category.id)
    end



  end

  def create
    @grade = Grade.new(grades_params)
    @grade.student = @student
    @grade.user = current_user
    if @grade.save

      redirect_to roster_path(@student.roster), notice: "#{@grade.title} successfully graded for #{@student.first_name} #{@student.last_name}!"
    else
      render :new
    end
  end

  def edit
    @grade = Grade.find(params[:id])
  end

  def update
    @grade = Grade.find(params[:id])
    @grade.update(grades_params)

    if @grade.save
      redirect_to roster_path(@grade.student.roster), notice: "Changes to #{@grade.student.first_name}'s grade were svaed!"
    else
      flash.now[:alert] = "Changes were not saved..."
      render :edit
    end
  end

  def destroy
    @grade = Grade.find(params[:id])
    @grade.destroy
    redirect_to user_path(current_user)
  end

  private
  def grades_params
    params.require(:grade).permit(:title, :eval_id, :template, :max_score, scores_attributes: [:id, :score, :category_id, :_delete, :comment_ids => []])
  end

  def load_eval
    @eval = Eval.find(params[:eval_id])
  end

  def load_student
    @student = Student.find(params[:student_id])
  end
end
