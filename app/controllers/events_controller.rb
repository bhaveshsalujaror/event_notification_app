class EventsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @event_a = Event.new
    @event_b = Event.new
  end

  def event_a
    @user = current_user
    @event = @user.events.build(event_params)

    if @event.save
      flash[:notice] = "Event A Created Successfully"
      redirect_to root_path
    else
      render :new # Render the new form again if validation fails
    end
  end

  def event_b
    @user = current_user
    @event = @user.events.build(event_params)

    if @event.save
      flash[:notice] = "Event B Created Successfully"
      redirect_to root_path
    else
      render :new # Render the new form again if validation fails
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description)
  end

end
