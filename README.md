# Native SwiftUI News App with SQLite Database Integration

This project is a Native News App developed in Swift and SwiftUI, following the MVVM and Singleton design patterns. The initial setup and basic functionalities were implemented following TundsDev's tutorial on YouTube, with additional features and enhancements added independently.

## Features

- **News API Integration**: Fetches the latest news from Lil Software's News API.
- **User Authentication**: Sign up and login functionalities allowing users to create accounts and login.
- **SQLite Database Integration**: Stores user data, articles, and favorites using SQLite.
- **Favorites Management**: Users can add and remove favorite articles, with favorites stored and fetched from the database.
- **MVVM and Singleton Design Patterns**: Ensures a clean, maintainable, and scalable codebase.

## Screenshots
<img width="355" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/62132abc-4883-46cf-874a-086ecb975f4f">
<img width="359" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/b2c360cc-eed2-475c-86ca-99bac0a6864e">
<img width="348" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/04d1f32d-cf83-4b67-8d83-5c68885f7155">
<img width="349" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/bc0543c7-929d-40b7-86f4-7e57ee3f94c1">
<img width="355" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/4294767d-7d6c-48c6-b91b-03058da0d446">
<img width="347" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/bd83df80-38f9-4f74-9eef-25e2497a6d2d">
<img width="355" alt="image" src="https://github.com/aarijimam/NewsAppSwift/assets/35100854/8ec17de0-ef48-4bdc-b741-b9698566f26d">




## Project Structure

The project is organized into different parts and folders, following the MVVM design pattern.


## API

The app uses Lil Software's News API to fetch news articles. The API endpoint is:

```
https://api.lil.software/news
```

## Database

The app uses SQLite for database management, with the following entities:

- **User**: Stores user information.
- **Articles**: Stores articles that users have favorited.
- **Favorites**: Stores the primary key (URL) of the articles and the username of the user who favorited them.

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/native-news-app.git
```

2. Open the project in Xcode:

```bash
cd native-news-app
open NativeNewsApp.xcodeproj
```

3. Install dependencies (if any).

4. Build and run the project on your preferred iOS simulator or device.

## Usage

- **Sign Up**: Create a new account by providing a username and password.
- **Login**: Login with your credentials.
- **Browse News**: View the latest news fetched from the API.
- **Favorite Articles**: Add articles to your favorites by tapping the favorite button.
- **Manage Favorites**: View and manage your favorite articles from the favorites section.

## Design Patterns

### MVVM (Model-View-ViewModel)

The MVVM pattern is used to separate concerns within the app:

- **Model**: Represents the data and business logic.
- **View**: Displays the UI components and is bound to the ViewModel.
- **ViewModel**: Handles the presentation logic and communicates between the Model and the View.

### Singleton

The Singleton pattern is used to ensure a single instance of the database manager throughout the app, providing a global point of access.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [TundsDev YouTube Tutorial](https://www.youtube.com/c/TundsDev)
- [Lil Software's News API](https://api.lil.software/news)
- SQLite Documentation

