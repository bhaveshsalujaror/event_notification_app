require 'webmock'

class EventsController < ApplicationController
  include WebMock::API
  WebMock.enable!
  
  # before_action :authenticate_user!

  def index
    @events = Event.all

    @event_a = Event.new
    @event_b = Event.new
  end

  def event_a
    @user = current_user
    @event = @user.events.build(event_params)

    if @event.save
      flash[:notice] = "Event A Created Successfully"
      send_event_to_iterable(@event.title, @user)
      
      response = HTTParty.post("https://api.iterable.com/api/events/track")
    else
      flash[:alert] = "Event B Creation Unsuccessfull"
    end
    
    redirect_to root_path
  end

  def event_b
    @user = current_user
    @event = @user.events.build(event_params)

    if @event.save
      flash[:notice] = "Event B Created Successfully"
      send_event_to_iterable(@event.title, @user)

      # Make a request to the mocked endpoint
      response = HTTParty.post("https://api.iterable.com/api/events/track")
    else
      flash[:alert] = "Event B Creation Unsuccessfull"
    end
    
    redirect_to root_path
  end

  def send_notifications_for_event_b
    # Logic to send email notifications for Event B using the Iterable API
    # This could include making requests to the Iterable API
    # Not implemented as per your requirement
    flash[:notice] = "Email notifications sent for Event B!"
    redirect_to root_path
  end

  private

  def event_params
    params.require(:event).permit(:title, :description)
  end

  def send_event_to_iterable(event_name, user)
    # Mocking the API request to iterable.com for testing purposes
    event_and_user_detail = { event_name: event_name, user_email: user.email}

    stub_request(:post, "https://api.iterable.com/api/events/track").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: event_and_user_detail.to_json, headers: {})
  end

end
