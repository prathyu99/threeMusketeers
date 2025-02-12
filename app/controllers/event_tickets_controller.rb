  class EventTicketsController < ApplicationController
    before_action :set_event_ticket, only: %i[ show edit update destroy ]
    before_action :authenticate_user!
    before_action :authenticate_admin!, only: [:admin_search]
    before_action :check_ownership, only: %i[show edit update destroy]
    # GET /event_tickets or /event_tickets.json
    def index
      @event_tickets = EventTicket.includes(:Attendee, :Event, :Room, :recipient).all
      @event = Event.all
      unless is_admin
        if params[:Attendee_id].present? && params[:Attendee_id].to_i != current_user.id
          # Redirect to a safe path with an alert, indicating unauthorized access
          redirect_to root_path, alert: "You are not authorized to access this section." and return
        end
        @event_tickets = EventTicket.where(Attendee_id: params[:Attendee_id])
        @event = Event.where(Event_id: params[:Event_id])
        #@event_tick = EventTicket.where(Attendee_id: params[:Attendee_id])
        #if @event_tick.Attendee_id != current_user.id
        # redirect_to event_tickets_path, alert: "You are not authorized to view this page."
        #end
      end
      # puts @event_tickets
    end


    # GET /event_tickets/1 or /event_tickets/1.json
    def show

    end

    # GET /event_tickets/new
    def new
      # Redirect to sign-in page if no user is logged in
      unless current_user
        redirect_to new_session_path, alert: "You must be logged in to book an event." # new_session_path should be replaced with your sign-in route
        return # Prevent the rest of the action
      end

      @event_ticket = EventTicket.new
      # ... rest of your new action ...
    end

    # GET /event_tickets/1/edit
    def edit
      # Assuming @event_ticket is set by the set_event_ticket before_action
      @editing = true
    end

    # POST /event_tickets or /event_tickets.json
    def create
      puts(event_ticket_params)
      @event_ticket = EventTicket.new(event_ticket_params)
      # Set the buyer as the current user
      @event_ticket.Attendee_id = get_user_id

      # If no recipient is selected, make the buyer the recipient
      # @event_ticket.recipient_id = params[:event_ticket][:recipient_id].present? ? params[:event_ticket][:recipient_id] : current_user.id

      @event_ticket.recipient = Attendee.find_by_id(params[:event_ticket][:recipient_id].presence) || current_user
      # if params[:event_ticket][:recipient_id].present?
      #   @event_ticket.recipient_id = params[:event_ticket][:recipient_id]
      # else
      #   @event_ticket.recipient_id = get_user_id
      # end


      # # Find the attendee by email and set the Attendee_id
      # attendee = Attendee.find_by(email: params[:event_ticket][:Attendee_email])
      # if attendee.present?
      #   @event_ticket.Attendee_id = attendee.id
      # else
      #   @event_ticket.errors.add(:Attendee_email, 'does not exist')
      # end


      event = Event.find_by(id: @event_ticket.Event_id)
      if event
        @event_ticket.Room_id = event.Room_id # Here we set the Room_id from the Event
      else
        @event_ticket.errors.add(:Event_id, 'is not valid')
      end

      # Generate a random confirmation number and assign it before saving
      @event_ticket.confirmation_number = SecureRandom.alphanumeric(10)+@event_ticket.Event_id.to_s

      respond_to do |format|
        if @event_ticket.errors.empty? && @event_ticket.save
          event = Event.find(@event_ticket.Event_id)
          if event.seats_left >= @event_ticket.no_of_tickets
            # Decrement the seats_left by the number of tickets booked
            event.decrement!(:seats_left, @event_ticket.no_of_tickets)

            ticket_price = event.ticket_price * @event_ticket.no_of_tickets
            # @ticket_price = ticket_price
            flash[:notice] = "Event ticket was successfully created. Total price: $#{ticket_price}"


            format.html { redirect_to event_ticket_url(@event_ticket), notice: "Event ticket was successfully created." }
            format.json { render :show, status: :created, location: @event_ticket }

            # event.decrement!(:seats_left)
            # format.html { redirect_to event_ticket_url(@event_ticket), notice: "Event ticket was successfully created." }
            # format.json { render :show, status: :created, location: @event_ticket }
          else
            @event_ticket.destroy # Roll back ticket creation if no seats are left

            format.html { redirect_to event_tickets_url, alert: "No more seats left for this event." }
            format.json { render json: { error: "No more seats left for this event" }, status: :unprocessable_entity }
          end
        else
          # If there are any errors, render the new template with the status unprocessable_entity
          format.html { render :new, status: :unprocessable_entity, locals: { event_ticket: @event_ticket } }
          format.json { render json: @event_ticket.errors, status: :unprocessable_entity }

        end
      end
    end



    def booking_history
      current_time = Time.zone.now
      current_time = current_time.utc
      # @events = Event.all

      # @completed_event_tickets = EventTicket.includes(:event, :recipient).where(Attendee_id: get_user_id)

      @tickets_as_buyer = EventTicket.includes(:event, :room).where(Attendee_id: get_user_id)
      @tickets_as_recipient = EventTicket.includes(:event, :room).where(recipient_id: get_user_id)
      # @all_tickets = @tickets_as_buyer.or(@tickets_as_recipient)

      @all_tickets = EventTicket.where("Attendee_id = :user_id OR recipient_id = :user_id", user_id: get_user_id)
                                .order(created_at: :desc)



      # Assuming you want to filter completed events, you can do something like:
      # @completed_event_tickets = @completed_event_tickets.filter do |ticket|
      #   ticket.event.end_time < current_time
      # end

      # @completed_event_tickets = EventTicket.joins(:Event)
      #                                       .where(Attendee_id: current_user.id)
      #                                       .where('events.end_time < ?', current_time)
      #                                       .where('events.date < ? OR (events.date = ? AND events.end_time < ?)',
      #                                           current_time.to_date, current_time.to_date, current_time.strftime("%H:%M:%S"))
      @completed_event_tickets = EventTicket.joins(:Event)
                                            .where("Attendee_id = :user_id OR recipient_id = :user_id", user_id: get_user_id)
                                            .where.not(events: { category: "Miscellaneous/Family – Private" })
                                            .where(
                                              "(date < :current_date OR (date = :current_date AND strftime('%H:%M:%S', end_time) < :current_time)) ",
                                              current_date: current_time.to_date,
                                              current_time: current_time.strftime("%H:%M:%S")
                                            )
      @ongoing_event_tickets = EventTicket.joins(:Event)
                                          .where(Attendee_id: current_user.id)
                                          .where(
                                            "(date > :current_date OR (date = :current_date AND strftime('%H:%M:%S', end_time) >= :current_time)) ",
                                            current_date: current_time.to_date,
                                            current_time: current_time.strftime("%H:%M:%S")
                                          )

      @unwanted_review = EventTicket.joins(:Event)
                                    .where(Attendee_id: current_user.id)
                                    .where(events: { category: "Miscellaneous/Family – Private" })
                                    .where(
                                      "(date < :current_date OR (date = :current_date AND strftime('%H:%M:%S', end_time) < :current_time)) ",
                                      current_date: current_time.to_date,
                                      current_time: current_time.strftime("%H:%M:%S")
                                    )
      @completed_events1 = @completed_event_tickets.map(&:Event)
      @completed_events = @ongoing_event_tickets.map(&:Event)
      @completed_events2 = @unwanted_review.map(&:Event)

      # @events = @events.where(
      #   "(date < :current_date OR (date = :current_date AND strftime('%H:%M:%S', start_time) < :current_time)) AND seats_left > 0",
      #   current_date: current_time.to_date,
      #   current_time: current_time.strftime("%H:%M:%S")
      # )


    end

    # PATCH/PUT /event_tickets/1 or /event_tickets/1.json
    # def update
    #   original_event_id = @event_ticket.Event_id
    #   respond_to do |format|
    #     #if @event_ticket.update(event_ticket_params)
    #     #  format.html { redirect_to event_ticket_url(@event_ticket), notice: "Event ticket was successfully updated." }
    #     #  format.json { render :show, status: :ok, location: @event_ticket }
    #     #else
    #     #  format.html { render :edit, status: :unprocessable_entity }
    #     #  format.json { render json: @event_ticket.errors, status: :unprocessable_entity }
    #     #end
    #     # Check if the event ID was changed
    #     if @event_ticket.update(event_ticket_params)
    #       if original_event_id != @event_ticket.Event_id
    #         original_event = Event.find(original_event_id)
    #         original_event.increment!(:seats_left,) if original_event.seats_left.present?
    #
    #         # Decrement seats_left for the new event
    #         new_event = Event.find(@event_ticket.Event_id)
    #         if new_event.seats_left.present? && new_event.seats_left > 0
    #           new_event.decrement!(:seats_left)
    #         else
    #           # Handle the case where there are no seats left for the new event
    #           format.html { redirect_to edit_event_ticket_url(@event_ticket), alert: "No more seats left for the new event." } and return
    #           format.json { render json: { error: "No more seats left for the new event" }, status: :unprocessable_entity } and return
    #         end
    #       end
    #       format.html { redirect_to event_ticket_url(@event_ticket), notice: "Event ticket was successfully updated." }
    #       format.json { render :show, status: :ok, location: @event_ticket }
    #     else
    #       format.html { render :edit, status: :unprocessable_entity }
    #       format.json { render json: @event_ticket.errors, status: :unprocessable_entity }
    #     end
    #     # Increment seats_left for the original event
    #   end
    # end
    # PATCH/PUT /event_tickets/1 or /event_tickets/1.json
    # def update
    #   original_event_id = @event_ticket.Event_id
    #   original_number_of_tickets = @event_ticket.no_of_tickets
    #   new_number_of_tickets = event_ticket_params[:no_of_tickets].to_i
    #
    #   respond_to do |format|
    #     if @event_ticket.update(event_ticket_params)
    #       if original_event_id != @event_ticket.Event_id
    #         # Handle changing to a different event
    #         original_event = Event.find(original_event_id)
    #         original_event.increment!(:seats_left, original_number_of_tickets) if original_event.seats_left.present?
    #
    #         new_event = Event.find(@event_ticket.Event_id)
    #         if new_event.seats_left.present? && new_event.seats_left >= new_number_of_tickets
    #           new_event.decrement!(:seats_left, new_number_of_tickets)
    #         else
    #           # Handle no seats left for the new event
    #           format.html { redirect_to edit_event_ticket_url(@event_ticket), alert: "No more seats left for the new event." } and return
    #           format.json { render json: { error: "No more seats left for the new event" }, status: :unprocessable_entity } and return
    #         end
    #       elsif new_number_of_tickets != original_number_of_tickets
    #         # Handle changing the number of tickets for the same event
    #         event = Event.find(@event_ticket.Event_id)
    #         difference = new_number_of_tickets - original_number_of_tickets
    #         if event.seats_left - difference >= 0
    #           event.seats_left -= difference
    #           event.save
    #         else
    #           # Handle not enough seats left after increasing the number of tickets
    #           format.html { redirect_to edit_event_ticket_url(@event_ticket), alert: "Not enough seats left." } and return
    #           format.json { render json: { error: "Not enough seats left." }, status: :unprocessable_entity } and return
    #         end
    #       end
    #
    #       format.html { redirect_to event_ticket_url(@event_ticket), notice: "Event ticket was successfully updated." }
    #       format.json { render :show, status: :ok, location: @event_ticket }
    #     else
    #       format.html { render :edit, status: :unprocessable_entity }
    #       format.json { render json: @event_ticket.errors, status: :unprocessable_entity }
    #     end
    #   end
    # end

    # PATCH/PUT /event_tickets/1 or /event_tickets/1.json
    def update
      original_event_id = @event_ticket.Event_id
      original_number_of_tickets = @event_ticket.no_of_tickets
      new_number_of_tickets = event_ticket_params[:no_of_tickets].to_i

      respond_to do |format|
        # Find the event based on the original event ID
        event = Event.find(original_event_id)

        # Calculate the total available seats for the update
        total_available_seats = event.seats_left + original_number_of_tickets

        # Proceed only if the new number of tickets is less than or equal to total available seats
        if new_number_of_tickets <= total_available_seats
          if @event_ticket.update(event_ticket_params)
            if original_event_id != @event_ticket.Event_id
              # Handle changing to a different event
              original_event.increment!(:seats_left, original_number_of_tickets) if original_event.seats_left.present?

              new_event = Event.find(@event_ticket.Event_id)
              if new_event.seats_left.present? && new_event.seats_left >= new_number_of_tickets
                new_event.decrement!(:seats_left, new_number_of_tickets)
              else
                # Handle no seats left for the new event
                format.html { redirect_to edit_event_ticket_url(@event_ticket), alert: "No more seats left for the new event." } and return
                format.json { render json: { error: "No more seats left for the new event" }, status: :unprocessable_entity } and return
              end
            elsif new_number_of_tickets != original_number_of_tickets
              # Handle changing the number of tickets for the same event
              difference = new_number_of_tickets - original_number_of_tickets
              if event.seats_left - difference >= 0
                event.seats_left -= difference
                event.save
              else
                # Handle not enough seats left after increasing the number of tickets
                format.html { redirect_to edit_event_ticket_url(@event_ticket), alert: "Not enough seats left." } and return
                format.json { render json: { error: "Not enough seats left." }, status: :unprocessable_entity } and return
              end
            end

            format.html { redirect_to event_ticket_url(@event_ticket), notice: "Event ticket was successfully updated." }
            format.json { render :show, status: :ok, location: @event_ticket }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @event_ticket.errors, status: :unprocessable_entity }
          end
        else
          # If the new number of tickets exceeds the available seats
          format.html { redirect_to edit_event_ticket_url(@event_ticket), alert: "Number of tickets exceeds the available seats." }
          format.json { render json: { error: "Number of tickets exceeds the available seats." }, status: :unprocessable_entity }
        end
      end
    end



    # DELETE /event_tickets/1 or /event_tickets/1.json
    def destroy
      event = Event.find(@event_ticket.Event_id)
      original_number_of_tickets = @event_ticket.no_of_tickets
      event.increment!(:seats_left,original_number_of_tickets) if event && event.seats_left.present?

      @event_ticket.destroy

      respond_to do |format|
        format.html { redirect_to event_tickets_url, notice: "Event ticket was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def admin_search
      @event_ticket = EventTicket.all
      @show = params[:event_name].present?
      if is_admin
        if params[:event_name].present?
          event = Event.find_by('lower(name) = ?', params[:event_name].downcase.strip)
          @event_ticket = event ? @event_ticket.where(event_id: event.id) : EventTicket.none
        end
      else
        format.html { redirect_to event_tickets_url, notice: "You cannot view this." }
      end

    end

    def get_event_id
      event_ticket = EventTicket.find_by(id: params[:id])

      if event_ticket
        # If the event is found, return the ticket price as JSON
        render json: { Event_id: event_ticket.Event_id }
      else
        # If no event is found, return an error message
        render json: { error: "Event not found" }, status: :not_found
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_ticket
      @event_ticket = EventTicket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_ticket_params
      # Ensure you include :Attendee_email if it's a form field
      params.require(:event_ticket).permit(:Attendee_email, :Event_id, :confirmation_number, :no_of_tickets, :recipient_id)
    end
    def authenticate_admin!
      redirect_to root_path, alert: "You are not authorized to access this section." unless is_admin
    end
    def authenticate_user!
      redirect_to new_session_path, alert: "You must be signed in to access this section." unless current_user
    end

    def check_ownership
      unless is_admin || @event_ticket.Attendee_id == current_user.id
        redirect_to root_path, alert: "You are not authorized to access this section."
      end
    end
  end