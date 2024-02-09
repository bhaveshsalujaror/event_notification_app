# app/services/iterable_api_service.rb
require 'webmock'

class IterableApiService
  # Include WebMock and enable it
  include WebMock::API
  WebMock.enable!

  # Define constants for Iterable API endpoints
  ITERABLE_EVENTS_TRACK_URL = "https://api.iterable.com/api/events/track".freeze
  ITERABLE_EMAIL_TARGET_URL = "https://api.iterable.com/api/email/target".freeze

  # Method to send event data to Iterable
  def self.send_event_to_iterable(event_name, user)
    # Construct event data
    event_and_user_detail = { event_name: event_name, user_email: user.email }
    
    # Stub the request to Iterable's events track endpoint
    WebMock.stub_request(:post, ITERABLE_EVENTS_TRACK_URL).
      with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).
      to_return(status: 200, body: event_and_user_detail.to_json, headers: {})
    
    # Send the event data to Iterable using HTTParty
    HTTParty.post(ITERABLE_EVENTS_TRACK_URL, body: event_and_user_detail.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  # Method to send email notification using Iterable
  def self.send_email_notification(user, event)
    # Construct email data
    email_data = {
      campaignId: event.id,
      recipientEmail: user.email,
      recipientUserId: user.id,
      dataFields: { event_name: event.title, event_description: event.description },
      allowRepeatMarketingSends: true,
      metadata: {}
    }
    
    # Stub the request to Iterable's email target endpoint
    WebMock.stub_request(:post, ITERABLE_EMAIL_TARGET_URL).
      with(headers: { 'Accept'=>'*/*', 'User-Agent'=>'Ruby' }).
      to_return(status: 200, body: { msg: "Email Sent", code: "Success", params: email_data }.to_json, headers: {})
    
    # Send the email notification to Iterable using HTTParty
    HTTParty.post(ITERABLE_EMAIL_TARGET_URL, body: email_data.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end
