class Admin::StudentsController < AdminController
  before_action :load_student, except: [:index]

  def index
    @students = Student.all

    respond_to do |format|
      format.html
    end
  end

  def approve
    @student.approve

    respond_to do |format|
      format.html { redirect_to admin_students_path, notice: 'Successfully approved student.' }
    end
  end

  def show
  end

  def add_comments
    student_params = params.require(:student).permit(:comments)

    if @student.update_attributes(student_params)
      flash[:notice] = 'Your comment has been added'
      redirect_to :back
    else
      flash[:error] = @student.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  private

  def load_student
    @student = Student.find(params[:id])
  end
end
