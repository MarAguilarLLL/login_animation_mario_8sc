# 🐻 Flutter Login Animation with Rive

An interactive login screen with an animated bear that reacts to user interactions, built with Flutter and Rive.

## ✨ Features

- **Interactive Animations**: The bear follows the email text and covers its eyes in the password field
- **Visual Feedback**: Success and error animations when attempting to login
- **Responsive Design**: Adapts to different screen sizes
- **Enhanced User Experience**: Focus management and debounce for smooth transitions

## 🛠️ Technologies Used

- **Flutter**: UI framework for cross-platform applications
- **Rive**: Tool for interactive animations
- **Dart**: Programming language

## 📋 Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart (version 2.17 or higher)
- A code editor (VS Code recommended with Flutter extension)

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/flutter-login-animation.git
cd flutter-login-animation
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── login_screen.dart         # Login screen with animations
assets/
├── animated_login_character.riv  # Rive animation file
```

## 🎨 How It Works

### Bear Animations
- **Watching the email**: The bear follows the text as you type in the email field
- **Covering eyes**: The bear covers its eyes when you interact with the password field
- **Celebration**: Success animation when credentials are valid
- **Sadness**: Error animation when credentials are incorrect

### Animation Controls
- `isChecking`: Activates the bear's curious look
- `isHandsUp`: Controls when the bear covers its eyes
- `numLook`: Controls how much the bear looks at the email text
- `trigSuccess`: Triggers success animation
- `trigFail`: Triggers error animation

## 🔧 Customization

You can adjust the following parameters in the code:

- **Debounce duration**: Modify `Duration(seconds: 1)` in `_debounceTimer`
- **Look sensitivity**: Adjust the divisor in `(_emailController.text.length / 15)`
- **Credentials validation**: Modify the logic in `_simulateLogin()`

## 📝 Important Notes

1. Make sure you have the Rive file (`animated_login_character.riv`) in the `assets` folder
2. The Rive file must contain a state machine named "Login Machine" with the parameters:
   - `isChecking` (bool)
   - `isHandsUp` (bool)
   - `numLook` (number)
   - `trigSuccess` (trigger)
   - `trigFail` (trigger)

## 👨‍💻 Author

[Mario Alberto Aguilar Jiménez] - [marioaguilarj@hotmail.com]

## 🙌 Acknowledgments

- [dexterc on Rive](https://rive.app/marketplace/3645-7621-remix-of-login-machine/) for the animations
- [Rive](https://rive.app/) for the amazing animation tool
- [Flutter](https://flutter.dev/) for the UI framework
![2025-09-18 16-07-11](https://github.com/user-attachments/assets/cd83b809-b0cf-45c5-90dd-08e5c7fb8971)
