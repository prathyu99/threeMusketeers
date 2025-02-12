class AttendeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attendee, only: %i[ show edit update destroy ]
  before_action :check_edit_authorization, only: %i[ edit update ]
  before_action :check_destroy_authorization, only: %i[ destroy ]
  # GET /attendees or /attendees.json
  def index

    if is_admin
      @attendees = Attendee.all
    else
      @attendees = Attendee.where(id: current_user.id)
    end
  end


  def profile
    # This action will only be for showing the current user's profile.
    # We assume that the current_user method is available and returns the logged-in user.
    @attendee = current_user
    render :show
  end
  # GET /attendees/1 or /attendees/1.json
  def show

  end

  # GET /attendees/new
  def new
    @attendee = Attendee.new
  end

  # GET /attendees/1/edit
  def edit
  end

  # POST /attendees or /attendees.json
  def create
    @attendee = Attendee.new(attendee_params)

    respond_to do |format|
      #if @attendee.save
      #  format.html { redirect_to attendee_url(@attendee), notice: "Attendee was successfully created." }
      #  format.json { render :show, status: :created, location: @attendee }
      #else
      #  format.html { render :new, status: :unprocessable_entity }
      #  format.json { render json: @attendee.errors, status: :unprocessable_entity }
      #end
      if @attendee.save
        if is_admin
          # Admin is creating the attendee, so redirect to the attendee's details page
          format.html { redirect_to attendee_url(@attendee), notice: "Attendee was successfully created by admin." }
          format.json { render :show, status: :created, location: @attendee }
        else
          # Attendee created their own account, so redirect to the sign-in page
          format.html { redirect_to logout_path, notice: "Account created successfully. Please sign in." }
          format.json { render :show, status: :created, location: @attendee }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendees/1 or /attendees/1.json
  def update
    respond_to do |format|
      update_params = attendee_params.except(:id, :Email, :Password)

      if @attendee.update(update_params)
        format.html { redirect_to attendee_url(@attendee), notice: "Attendee was successfully updated." }
        format.json { render :show, status: :ok, location: @attendee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendees/1 or /attendees/1.json
  def destroy

    if @attendee.name.include? 'Admin User'
      flash[:alert] = "Admin cannot be deleted."
      redirect_to attendees_url
      # respond_to do |format|
      #   format.html { redirect_to @attendee }
      #   format.json { head :forbidden }
      # end
    else
      @attendee.destroy
      respond_to do |format|
        #format.html { redirect_to attendees_url, notice: "Attendee was successfully destroyed." }
        #format.json { head :no_content }

        if is_admin
          format.html { redirect_to attendees_url, notice: "Attendee was successfully destroyed." }
          format.json { head :no_content }
        else
          format.html { redirect_to logout_path, notice: "Your account was successfully deleted." }
          format.json { head :no_content }
        end
      end


    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.


  private

  def check_edit_authorization
    unless current_user == @attendee || is_admin
      redirect_to root_path, alert: "You are not authorized to edit this profile."
    end
  end

  def check_destroy_authorization
    #if is_admin
    #  redirect_to attendees_url, alert: "You are not authorized to delete this account."
    #end
    if current_user == @attendee && is_admin
      redirect_to attendees_url, alert: "You are not authorized to delete your own admin account."
    end
  end

  def attendee_params
    params.require(:attendee).permit(:Email, :Password,:name, :Phone_number, :Address, :Credit_card_info)
  end
  def authenticate_user!
    redirect_to login_path, alert: "You must be logged in to access this page." unless current_user
  end
end


