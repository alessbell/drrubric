class CoursesController < ApplicationController
  def index
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.professor = current_user
    if @course.save
      redirect_to @course, notice: "#{@course.name} was created!"
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])

    if @course.update(course_params)
      redirect_to @course, notice: "Change to #{@course.name} were successfully saved!"
    else
      flash.now[:alert] = "Changes to #{@course.name} were not saved..."
      render :edit
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
  end

    private

  def course_params
    params.require(:course).permit(:name, :description)
  end
end
