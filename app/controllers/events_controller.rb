class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_attendee!
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]
  #  before_action :validate_room_capacity, only: [:create, :update]
  # GET /events or /events.json
  # def index
  #   current_time = Time.now
  #   current_date = current_time.to_date
  #   current_time_of_day = current_time.strftime("%H:%M:%S")
  #   @events = Event.all
  #   if !is_admin
  #     @events = Event.where('(date > ? OR (date = ? AND start_time > ?)) AND seats_left > 0', current_date, current_date, current_time_of_day)
  #   end
  # end

  def index
    @events = Event.all

    # Search and filter logic
    if params[:category].present?
      @events = @events.where('category LIKE ?', "%#{params[:category]}%")
    end

    if params[:date].present?
      @events = @events.where(date: params[:date])
    end

    if params[:min_price].present?
      @events = @events.where('ticket_price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @events = @events.where('ticket_price <= ?', params[:max_price])
    end

    if params[:name].present?
      @events = @events.where('name LIKE ?', "%#{params[:name]}%")
    end

    # Ensure only future events with available seats are shown to non-admin users
    unless is_admin
      if params[:Attendee_id].present? && params[:Attendee_id].to_i != current_user.id
        # Redirect to a safe path with an alert, indicating unauthorized access
        redirect_to root_path, alert: "You are not authorized to access this section" and return
      end
      current_time = Time.now
      @events = @events.where(
        "(date > :current_date OR (date = :current_date AND strftime('%H:%M:%S', start_time) > :current_time)) AND seats_left > 0",
        current_date: current_time.to_date,
        current_time: current_time.strftime("%H:%M:%S")
      )

    end
  end

  # GET /events/1 or /events/1.json
  def show
    current_time = Time.now

    @events = Event.all
    if !is_admin
      @events = @events.where(
        "(date > :current_date OR (date = :current_date AND strftime('%H:%M:%S', start_time) > :current_time)) AND seats_left > 0",
        current_date: current_time.to_date,
        current_time: current_time.strftime("%H:%M:%S")
      )
    end
  end

  # GET /events/new
  def new
    @event = Event.new
    @room_locations = Room.pluck(:Room_location, :id)
    #@room = Room.new
    #@room_locations = Room.distinct.pluck(:Room_location)
  end

  # GET /events/1/edit
  def edit
    #@room_locations = Room.distinct.pluck(:Room_location)
  end

  # private
  #
  # def validate_room_capacity
  #   room = Room.find(event_params[:Room_id])
  #   if event_params[:seats_left].to_i > room.Room_capacity
  #     flash[:alert] = "The selected room does not have enough capacity."
  #     redirect_to new_event_path # or the appropriate path
  #   end
  # end

  # POST /events or /events.json
  def create
    puts(event_params)
    room = Room.find_by(Room_location: params[:event][:Room_location])

    # Check if room exists


    # Now that you have the room, create the event with the Room_id
    @event = Event.new(event_params)
    #room = Room.find_by(Room_location: event_params[:Room_location])

    # Set the Room_id for the event
    #@event.Room_id = room.id if room

    respond_to do |format|
      if @event.save
        # update_room_capacity(@event)
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        #@room_locations = Room.distinct.pluck(:Room_location)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update_room_capacity(event)
  #   room = Room.find(event.Room_id)
  #   room.update(Room_capacity: room.Room_capacity - event.seats_left)
  # end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def ticket_price
    # Find the event by the provided ID
    event = Event.find_by(id: params[:event_id])

    if event
      # If the event is found, return the ticket price as JSON
      render json: { ticket_price: event.ticket_price }
    else
      # If no event is found, return an error message
      render json: { error: "Event not found" }, status: :not_found
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # def authenticate_attendee!
  #   unless @current_user ||= Attendee.find(session[:user_id])
  #     flash[:alert] = "You must be signed in as an attendee to access this section."
  #   end
  # end

  def authenticate_admin!
    if @current_user and @current_user.Email.include? 'admin123@gmail.com'
      true
    else
      false
    end
  end
  # def authenticate_admin!
  #   unless @current_user && @current_user.name.include?('Admin User')
  #     flash[:alert] = "You are not authorized to perform this action."
  #     redirect_to events_path # or root_path
  #   end
  # end
  def authenticate_attendee!
    return if @current_user ||= Attendee.find_by(id: session[:user_id])

    flash[:alert] = "You must be signed in to access this section."
    # redirect_to login_path # Assuming you have a login path
  end


  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:Name, :Room_id, :category, :date, :start_time, :end_time, :ticket_price,  :event_capacity, :seats_left)
  end
end