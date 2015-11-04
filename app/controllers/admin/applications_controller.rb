class Admin::ApplicationsController < AdminController
  before_action :load_application, only: [:show, :approve_follow_up_call, :approve_intake_form, :reject]

  def index
    @applications = Application.all.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
    end
  end

  def show
    @intake_form = IntakeForm.from_application(@application)
    @follow_up_call_form = FollowUpCallForm.from_application(@application)
    @meeting_notes_form = MeetingNotesForm.from_application(@application)

    respond_to do |format|
      format.html
    end
  end

  def approve_follow_up_call
    if @application.followed_up?
      @application.accept_follow_up!
      redirect_to admin_application_path(@application), notice: 'Follow up call approved.'
    else
      redirect_to admin_application_path(@application), flash: { error: "Failed to approve follow up call. Application cannot transition from #{@application.state.humanize(capitalize: false)} to in progress" }
    end
  end

  def approve_intake_form
    if @application.intake?
      @application.intaken!
      redirect_to admin_application_path(@application), notice: 'Intake form approved.'
    else
      redirect_to admin_application_path(@application), flash: { error: "Failed to approve intake form. Application cannot transition from #{@application.state.humanize(capitalize: false)} to pending follow up" }
    end
  end

  def reject
    @application.reject

    redirect_to admin_application_path(@application), notice: 'Application rejected.'
  end

  private

  def load_application
    @application = Application.find(params[:id])
  end
end
