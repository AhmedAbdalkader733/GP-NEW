# Event Management System

A full-stack application for managing events with different user roles (Usher, Creator, and Company).

## Project Structure

- `/gp` - Flutter mobile application
- `/server` - Node.js backend server

## Features

- Authentication for multiple user roles
- Field validation and error handling
- Profile management
- Event creation and management
- API integration with proper error handling

## Tech Stack

### Frontend (Flutter)
- Flutter for cross-platform mobile development
- Provider for state management
- Dio for API calls
- SharedPreferences for data persistence

### Backend (Node.js)
- Express.js framework
- MongoDB database
- JWT authentication
- File upload handling

## Getting Started

1. Clone the repository
2. Set up the backend:
   ```bash
   cd server
   npm install
   npm start
   ```
3. Set up the Flutter app:
   ```bash
   cd gp
   flutter pub get
   flutter run
   ```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
