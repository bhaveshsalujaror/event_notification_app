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
      expect(IterableApiService).to receive(:send_event_to_iterable).with("Test Event A", user)
      post :event_a, params: event_a_params
      expect(flash[:notice]).to eq("Event A Created Successfully")
    end
  end

  describe "POST #event_b" do
    it "creates Event B, sends data to Iterable, and sends email notification" do
      expect(IterableApiService).to receive(:send_event_to_iterable).with("Test Event B", user)
      expect(IterableApiService).to receive(:send_email_notification).with(user, instance_of(Event))
     
      post :event_b, params: event_b_params
     
      expect(flash[:notice]).to eq("Event B Created Successfully")
      expect(flash[:alert]).to match(/Email For Event B Sent Successfully to #{user.email}/)
    end
  end
end
