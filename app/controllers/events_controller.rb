require 'webmock'

class EventsController < ApplicationController
  include WebMock::API
  WebMock.enable!

  before_action :authenticate_user!
  before_action :set_events, only: :index

  ITERABLE_EVENTS_TRACK_URL = "https://api.iterable.com/api/events/track".freeze
  ITERABLE_EMAIL_TARGET_URL = "https://api.iterable.com/api/email/target".freeze

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
      send_event_to_iterable(event.title, current_user)
      true
    else
      flash[:alert] = "#{message} Creation Unsuccessful"
      false
    end
  end

  def send_event_to_iterable(event_name, user)
    event_and_user_detail = { event_name: event_name, user_email: user.email }
    stub_request(:post, ITERABLE_EVENTS_TRACK_URL).
      with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).
      to_return(status: 200, body: event_and_user_detail.to_json, headers: {})
    HTTParty.post(ITERABLE_EVENTS_TRACK_URL)
  end

  def send_email_notification(user, event)
    email_data = {
      campaignId: event.id,
      recipientEmail: user.email,
      recipientUserId: user.id,
      dataFields: { event_name: event.title, event_description: event.description },
      sendAt: DateTime.now,
      allowRepeatMarketingSends: true,
      metadata: {}
    }
    stub_request(:post, ITERABLE_EMAIL_TARGET_URL).
      with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).
      to_return(status: 200, body: { msg: "Email Sent", code: "Success", params: email_data }.to_json, headers: {})
    HTTParty.post(ITERABLE_EMAIL_TARGET_URL, body: email_data.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end
