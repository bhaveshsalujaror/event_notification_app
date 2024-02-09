class EventsController < ApplicationController
  def index
  end

  def event_a
    # Implement logic to create Event A
    # This could involve making a request to Iterable's API
    # For now, just render a message

    render plain: "Event A created"
  end

  def event_b
    render plain: "Event B created"
  end

end
