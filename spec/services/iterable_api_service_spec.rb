# spec/services/iterable_api_service_spec.rb

require 'rails_helper'
require 'webmock'

RSpec.describe IterableApiService, type: :service do
  
  describe '.send_event_to_iterable' do
    # Define necessary test data
    let(:user) { create(:user) }
    let(:event_name) { "Test Event" }
    let(:event_and_user_detail) { { event_name: event_name, user_email: user.email } }

    it "sends event data to Iterable" do
      # Expectation: HTTParty should be called with the correct arguments
      expect(HTTParty).to receive(:post).with(
        IterableApiService::ITERABLE_EVENTS_TRACK_URL,
        body: event_and_user_detail.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      # Invoke the method under test
      IterableApiService.send_event_to_iterable(event_name, user)
    end
  end

  describe '.send_email_notification' do
    # Define necessary test data
    let(:user) { create(:user) }
    let(:event) { create(:event) }
    let(:email_data) do
      {
        campaignId: event.id,
        recipientEmail: user.email,
        recipientUserId: user.id,
        dataFields: { event_name: event.title, event_description: event.description },
        allowRepeatMarketingSends: true,
        metadata: {}
      }
    end

    it "sends email notification using Iterable" do
      # Stub the request to Iterable's email target endpoint
      WebMock.stub_request(:post, IterableApiService::ITERABLE_EMAIL_TARGET_URL)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: { msg: "Email Sent", code: "Success", params: email_data }.to_json, headers: {})

      # Expectation: HTTParty should be called with the correct arguments
      expect(HTTParty).to receive(:post).with(
        IterableApiService::ITERABLE_EMAIL_TARGET_URL,
        body: email_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      # Invoke the method under test
      IterableApiService.send_email_notification(user, event)
    end
  end
end
