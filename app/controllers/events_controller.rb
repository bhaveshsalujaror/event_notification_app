class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_events, only: :index

  def index
  end

  def event_a
    @event = build_event(current_user)
    save_event_and_handle_response(@event, "Event A")
    redirect_to root_path
  end

  def event_b
    @event = build_event(current_user)
    if save_event_and_handle_response(@event, "Event B")
      send_email_notification(current_user, @event)
      flash[:alert] = "Email For Event B Sent Successfully to #{current_user.email}"
    end
    redirect_to root_path
  end

  private

  def set_events
    @events = Event.all
    @event_a = Event.new
    @event_b = Event.new
  end

  def event_params
    params.require(:event).permit(:title, :description)
  end

  def build_event(user)
    user.events.build(event_params)
  end

  def save_event_and_handle_response(event, message)
    if event.save
      flash[:notice] = "#{message} Created Successfully"
      IterableApiService.send_event_to_iterable(event.title, current_user)
      true
    else
      flash[:alert] = "#{message} Creation Unsuccessful"
      false
    end
  end

  def send_email_notification(user, event)
    IterableApiService.send_email_notification(user, event)
  end
end
