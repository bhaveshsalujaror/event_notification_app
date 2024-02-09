# EventsController

The EventsController handles the creation of events and the display of all events in the system. It integrates with an external service, Iterable, for event tracking and email notifications.

## Controller Details

### Actions

- **index**: Displays all events.
- **event_a**: Creates Event A and sends event data to Iterable.
- **event_b**: Creates Event B, sends data to Iterable, and sends email notification.

### Before Actions

- **authenticate_user!**: Ensures that the user is authenticated before accessing any actions.
- **set_events**: Sets up instance variables for displaying events in the index view.

### Private Methods

- **event_params**: Permits title and description parameters for event creation.
- **build_event(user)**: Builds a new event object associated with the given user.
- **save_event_and_handle_response(event, message)**: Saves the event and handles success or failure flash messages.
- **send_event_to_iterable(event_name, user)**: Sends event data to Iterable for tracking.
- **send_email_notification(user, event)**: Sends email notification using Iterable.

### Constants

- **ITERABLE_EVENTS_TRACK_URL**: Endpoint for tracking events in Iterable.
- **ITERABLE_EMAIL_TARGET_URL**: Endpoint for sending email notifications via Iterable.

## Test Cases

The EventsController is thoroughly tested with RSpec to ensure its functionality.

### Description of Test Cases

1. **GET #index**: Verifies that the index action assigns all events and renders the index template.
2. **POST #event_a**: Tests the creation of Event A and verifies that data is sent to Iterable.
3. **POST #event_b**: Tests the creation of Event B, verifies data is sent to Iterable, and checks email notification.
4. **#send_event_to_iterable**: Ensures that event data is sent to Iterable.
5. **#send_email_notification**: Verifies that email notification is sent using Iterable.

## Running Tests

To run the tests:

```bash
rspec spec/controllers/events_controller_spec.rb
