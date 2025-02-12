# WolfEvents - Event Management System

WolfEvents is an event management system designed for NCSU to facilitate event exploration, ticket purchasing, and event review by attendees. With admin capabilities to manage events, attendees, and reviews, WolfEvents offers a comprehensive platform for event handling.

### Admin Account

- **Email**: admin123@gmail.com
- **Password**: admin123
- **URL**: http://152.7.177.251:8080/

## Features

- **Admin**: Single preconfigured admin account to manage the system.
- **Attendee**: Users can register, view events, book tickets, and write reviews.
- **Room**: Admin can book events in rooms for specified time slots.
- **Event**: Admin-created events that attendees can book.
- **Event Ticket**: Tickets generated upon booking an event.
- **Review**: Attendees can provide feedback for attended events.

### Admin Features
- Single preconfigured admin account.
- Ability to create/view/edit/delete events, attendees, tickets,rooms and reviews.
- View all events and filter by category, date, price, and name.
- Search functionality to find attendees by event name.
- Admin profile edit (excluding ID, email, and password).
- View all signed-up attendees and their reviews.

### Attendee Features
- New account registration.
- Profile management, including deletion of accounts.
- Event browsing with filters for category, date, and price.
- Ticket booking with auto-calculation of price.
- Event booking history view.
- Event review submission and editing post-event.
- Option to buy tickets for another attendee.

### Technical Features
- Secure login and access controls.
- Consistency between event room capacity and seats left.
- Cascading deletes for attendee accounts and event cancellations.
- Clean and readable code, following best practices.
- Comprehensive testing for one model and one controller.

## Getting Started

### Prerequisites

- Ruby version 3.3.0 or above
- Rails version 7.0.4 or above

### Installation

1. Clone the repository:
git clone https://github.ncsu.edu/sgarlap/threeMusketeers.git
2. Navigate to the project directory:
cd threeMusketeers
3. Install dependencies:
bundle install
4. Setup the database: rails db:create db:migrate db:seed
5. Run server: rails s

## Usage

This section provides guidance on how to use the WolfEvents application.

### Accessing the Application

WolfEvents is deployed and accessible at the following URL: [WolfEvents System](http://152.7.177.251:8080/).

### Attendee Functions

#### Sign Up
- To sign up as an attendee, navigate to the [Sign Up](http://152.7.177.251:8080/sign_up) page from the homepage.
- Fill out the registration form with your details and submit.

#### Log In
- Access the [Log In](http://152.7.177.251:8080/login) page and enter your registered email and password to log in.

#### View and Book Events
- After logging in, go to the [Events](http://152.7.177.251:8080/events) section to view all available events.
- Click on the 'Book Ticket' button for the event you wish to attend and follow the booking process.

#### Write Reviews
- Visit your [Booking History](http://152.7.177.251:8080/booking_history) to review events you've attended.
- Click the Review button next to the relevant event to submit your feedback.

### Admin Functions

#### Manage System
- As an admin, log in using your admin credentials to reach the admin dashboard.
- Use the management links provided to create, view, edit, or delete attendees, events, tickets, and reviews.

### Navigating the Application

- Use the navigation bar or the provided links on the homepage to access different sections of the application.
- At any point, you can return to the homepage by clicking the logo or the 'Home' link.

### Buying Tickets for Others

- When buying a ticket, you have the option to purchase it for another attendee. Click 'Buy for someone else' and select the attendee from the dropdown.

### Editing Profiles

- You can edit your profile information by accessing the Edit Profile section from your dashboard.

Please note that you must be logged in to access the above links.

## Testing
1. Open terminal
2. Navigate to the project folder using cd threeMusketeers
3. Run the following command to run the test cases:
bundle exec rspec spec/controllers/sessions_controller_spec.rb

## Deployment Instructions

The application can be deployed using services like Heroku, AWS, or on the NCSU VCL.

## Frequently Asked Questions (FAQs)

- **How do I book a ticket?**
  - Navigate to 'Events', choose an event, and click 'Book Ticket'.
- **How do I edit a review?**
  - Go to your 'Booking History', find the event, and click 'Edit Review'.
- **How can an admin delete a user?**
  - From the admin dashboard, click 'Attendees', select a user, and choose 'Delete'.

## License

This project is licensed under the [MIT License](LICENSE.md).

## Contact

- please contact sgarlap@ncsu.edu, pkodali@ncsu.edu, yseela@ncsu.edu in case of any issues or concerns.
