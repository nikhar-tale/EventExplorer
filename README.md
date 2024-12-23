# Event Explorer

Event Explorer is a cross-platform mobile app built using Flutter that allows users to explore and discover events across various categories. The app features mandatory Google login for authentication and provides a seamless user experience with responsive and mobile-friendly views.

## Features

- **Google Social Login**: Users must log in with their Google accounts to access the app securely.
- **Firebase Authentication**: Utilizes Firebase Authentication for secure login with Google accounts.
- **Event Categories**: The Home Screen displays a menu of event categories fetched from an API.
- **Listing Screen**: Users can view events from the selected category, with options to toggle between List view and Grid view.
- **Remote Data Fetching**: The app makes remote requests to fetch event data from an API.
- **WebView Integration**: Tapping on an event item opens its event URL in a WebView within the app.
- **MVVM Architecture**: The app follows the MVVM (Model-View-ViewModel) architecture for organized code structure and separation of concerns.
- **Bloc State Management**: BloC package is used for efficient state management, ensuring a smooth user experience.

## Installation

1. Clone the repository to your local machine:

```bash
git clone https://github.com/nikhar-tale/EventExplorer.git
