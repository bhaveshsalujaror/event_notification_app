# Events Application

This repository contains the source code, assets, and documentation for the Events application.

## Setting Up and Running the Application

To set up and run the application, follow these steps:

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/bhaveshsalujaror/event_notification_app.git
    ```

2. Navigate to the project directory:

    ```bash
    cd events_notification_application
    ```

3. Install dependencies:

    ```bash
    bundle install
    ```

4. Set up the database:

    ```bash
    rails db:setup
    ```

5. Start the Rails server:

    ```bash
    rails server
    ```

6. Open your web browser and navigate to [http://localhost:3000](http://localhost:3000) to access the application.

## Over-the-Wire Mocks for Iterable.com API

The application includes over-the-wire mocks for interactions with the iterable.com API. These mocks are implemented using WebMock to simulate requests and responses from the Iterable API endpoints. By using mocks, we can test the application's behavior without actually making requests to the external API.

## Trade-offs and Decisions

While implementing the solution, several trade-offs and decisions were made:

- **Use of WebMock**: We chose to use WebMock for mocking interactions with the Iterable API. WebMock provides a simple and flexible way to mock HTTP requests and responses in Ruby applications.

- **Validation**: We added validations to the Event model to ensure that required fields such as title and description are present. These validations help maintain data integrity and prevent invalid data from being saved to the database.

- **Test Coverage**: We ensured thorough test coverage for the application, including controller and service tests. This ensures that the application behaves as expected and provides confidence when making changes or adding new features.

- **Documentation**: We provided clear and comprehensive documentation in the README file to guide users on setting up and running the application. Additionally, we discussed the use of over-the-wire mocks and explained the rationale behind certain decisions made during implementation.

Overall, these decisions were made to ensure the reliability, maintainability, and ease of use of the Events application.
