class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  # before_action :authorize_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_index, only: [:index]


  # GET /reviews or /reviews.json
  # def index
  #   @reviews = Review.all
  # end

  # def index
  #   if params[:attendee_id]
  #     # @reviews = Review.where(attendee_id: params[:attendee_id])
  #     if params[:event_event_name].present?
  #       event_event_name = params[:event_event_name].downcase.strip
  #       event = Event.find_by('lower(name) = ?',event_event_name)
  #       if event
  #         @reviews = Review.where(event_id:event.id, attendee_id:params[:attendee_id] )
  #       else
  #         @reviews = Review.none
  #         flash.now[:alert] = "No attendee found with the provided event name"
  #       end
  #     else
  #       @reviews = Review.where(attendee_id: params[:attendee_id])
  #     end
  #   else
  #     if params[:attendee_email].present?
  #       attendee_email = params[:attendee_email].downcase.strip
  #       attendee = Attendee.find_by('lower(email) = ?', attendee_email)
  #       if attendee
  #         @reviews = Review.where(attendee_id: attendee.id)
  #       else
  #         @reviews = Review.none
  #         flash.now[:alert] = "No attendee found with the provided email"
  #       end
  #     else
  #       @reviews = Review.all
  #     end
  #   end
  # end
  #
  #
  def index
    # if !is_admin && params[:attendee_id].to_i != get_user_id
    #   redirect_to root_path, alert: "You are not authorized to access these reviews."
    #   return
    # end
    if params[:attendee_id]
      # Filter by current user's reviews, with optional event name filter
      @reviews = Review.where(attendee_id: params[:attendee_id])
      if params[:event_event_name].present?
        event = Event.find_by('lower(name) = ?', params[:event_event_name].downcase.strip)
        @reviews = event ? @reviews.where(event_id: event.id) : Review.none
      end
    else
      # General search by attendee email or event name
      @reviews = Review.all
      if params[:attendee_email].present?
        attendee = Attendee.find_by('lower(email) = ?', params[:attendee_email].downcase.strip)
        @reviews = attendee ? @reviews.where(attendee_id: attendee.id) : Review.none
      end

      if params[:event_event_name].present?
        event = Event.find_by('lower(name) = ?', params[:event_event_name].downcase.strip)
        @reviews = event ? @reviews.where(event_id: event.id) : Review.none
      end
    end
  end
  # def index
  #   if params[:attendee_email].present?
  #     attendee_email = params[:attendee_email].downcase.strip
  #     attendee = Attendee.find_by('lower(email) = ?', attendee_email)
  #     if attendee
  #       @reviews = Review.where(attendee_id: attendee.id)
  #     else
  #       @reviews = Review.none
  #       flash.now[:alert] = "No attendee found with the provided email"
  #     end
  #   else
  #     @reviews = Review.all
  #   end
  # end


  # GET /reviews/1 or /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    # if !is_admin && params[:attendee_id].to_i != get_user_id
    #   redirect_to root_path, alert: "You are not authorized to access these reviews." and return
    # end
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    # if !is_admin && params[:attendee_id].to_i != get_user_id
    #   redirect_to root_path, alert: "You are not authorized to access these reviews." and return
    # end
  end

  # POST /reviews or /reviews.json
  def create

    @review = Review.new(review_params)
    @review.Attendee_id = get_user_id
    respond_to do |format|
      if @review.save
        format.html { redirect_to review_url(@review), notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to review_url(@review), notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end


  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:attendee_id, :Event_id, :rating, :feedback)
  end
  private

  # def authorize_review
  #   @review = Review.find(params[:id])
  #   unless current_user == @review.Attendee_id || is_admin
  #     redirect_to root_path, alert: "You are not authorized to view or modify this review."
  #   end
  # end
  private

  # def authorize_index
  #   if current_user
  #     unless is_admin
  #       # If the user is not an admin, restrict reviews to their own.
  #       @reviews = current_user.Reviews
  #     end
  #     # If the user is an admin, @reviews will contain all reviews.
  #   else
  #     # If there is no current user, redirect them to the login page or home page with an error message.
  #     redirect_to login_path, alert: "You must be logged in to view reviews."
  #   end
  # end
  private

  def authorize_index
    redirect_to login_path, alert: "You must be logged in to view reviews." unless current_user
  end

end