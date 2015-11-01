class Admin::HomeController < AdminController
  def index
    @applications_requiring_action = Application.where(state: ['intake', 'pending_lawyer_match']).paginate(:page => params[:page], :per_page => 10)
    @unapproved_student_count      = Student.where(approved: false).count
    @unapproved_lawyer_count       = Lawyer.where(approved: false).count
  end
end