# Movie Database App

A comprehensive Flutter application showcasing trending and now playing movies using The Movie Database (TMDB) API. Built with clean architecture principles, offline support, and modern UI design.

## Features

### Core Features
- **Home Page**: Browse trending movies and now playing movies
- **Movie Details**: Comprehensive movie information with ratings, overview, and metadata
- **Search**: Real-time search with debounced input for optimal performance
- **Bookmarks**: Save and manage favorite movies locally
- **Offline Support**: Local database caching for seamless offline experience

### Bonus Features
- **Smart Search**: Debounced search with live results as you type
- **Deep Linking**: Share movies with custom deep links that open directly in the app
- **Cross-Platform**: Fully compatible with Android and iOS

## Architecture

This app follows clean architecture principles with:

- **MVVM Pattern**: Clear separation of business logic and UI
- **Repository Pattern**: Centralized data management
- **Provider State Management**: Reactive UI updates
- **Offline-First**: Local database with network fallback

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Networking**: Dio + Retrofit
- **Local Database**: SQLite (sqflite)
- **Navigation**: GoRouter
- **Image Caching**: CachedNetworkImage
- **Architecture**: MVVM + Repository Pattern

## Getting Started

### Prerequisites
- Flutter 3.8.1 or higher
- Dart 3.8.0 or higher
- Android Studio / Xcode for device deployment
- TMDB API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd movie-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build
   ```

4. **Get TMDB API Key**
   - Visit [TMDB API Settings](https://www.themoviedb.org/settings/api)
   - Create an account if you don't have one
   - Generate an API key

5. **Configure Environment Variables**
   - Copy the example environment file:
     ```bash
     cp .env.example .env
     ```
   - Open `.env` file and replace `your_tmdb_api_key_here` with your actual TMDB API key:
     ```
     TMDB_API_KEY=your_actual_api_key_here
     ```

6. **Run the app**
   ```bash
   flutter run
   ```

## Key Features Implementation

### 1. Offline-First Architecture
- All API responses are cached locally
- UI loads from local database first
- Network requests update local cache
- Seamless experience with or without internet

### 2. Smart Search
- 500ms debounce delay for optimal performance
- Live results as user types
- Local search fallback when offline
- Clean, intuitive search interface

### 3. Deep Linking
- Custom URL scheme for movie sharing
- Direct navigation to shared movies
- Handles app state restoration
- Social sharing integration with personal domain

### 4. Modern UI Design
- Dark theme with gradient backgrounds
- Smooth animations and transitions
- Responsive design for all screen sizes
- Card-based layout with shadows and effects

## Environment Configuration

The app uses environment variables to keep sensitive information like API keys secure and out of version control.

### Environment Variables

- `TMDB_API_KEY`: Your The Movie Database API key

### Setup

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit the `.env` file with your actual values:
   ```env
   TMDB_API_KEY=your_actual_tmdb_api_key_here
   ```
