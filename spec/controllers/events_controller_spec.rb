require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:event_a_params) { { event: attributes_for(:event, user: user, title: "Test Event A") } }
  let(:event_b_params) { { event: attributes_for(:event, user: user, title: "Test Event B") } }

  before { sign_in user }

  describe "GET #index" do
    it "assigns @events and renders the index template" do
      get :index
      expect(assigns(:events)).to eq(Event.all)
      expect(response).to render_template("index")
    end
  end

  describe "POST #event_a" do
    it "creates Event A and sends data to Iterable" do
      allow(controller).to receive(:send_event_to_iterable)
      expect {
        post :event_a, params: event_a_params
      }.to change(Event, :count).by(1)

      expect(flash[:notice]).to eq("Event A Created Successfully")
      expect(controller).to have_received(:send_event_to_iterable).with("Test Event A", user)
    end
  end

  describe "POST #event_b" do
    it "creates Event B, sends data to Iterable, and sends email notification" do
      allow(controller).to receive(:send_event_to_iterable)
      allow(controller).to receive(:send_email_notification)

      expect {
        post :event_b, params: event_b_params
      }.to change(Event, :count).by(1)

      expect(flash[:notice]).to eq("Event B Created Successfully")
      expect(flash[:alert]).to match(/Email For Event B Sent Successfully to #{user.email}/)

      expect(controller).to have_received(:send_event_to_iterable).with("Test Event B", user)
      expect(controller).to have_received(:send_email_notification).with(user, instance_of(Event))
    end
  end

  describe "#send_event_to_iterable" do
    it "sends event data to Iterable" do
      allow(HTTParty).to receive(:post)
      subject.send(:send_event_to_iterable, "Test Event", user)
      expect(HTTParty).to have_received(:post).with(EventsController::ITERABLE_EVENTS_TRACK_URL)
    end
  end

  describe "#send_email_notification" do
    it "sends email notification using Iterable" do
      event = create(:event)
      allow(event).to receive(:id).and_return(123)

      expect(HTTParty).to receive(:post).with(EventsController::ITERABLE_EMAIL_TARGET_URL, any_args)
      subject.send(:send_email_notification, user, event)
    end
  end
end
