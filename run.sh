#!/bin/bash

echo "Initializing Edu App..."
cd edu_app

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Check if iOS or Android device is connected
echo "Checking for connected devices..."
flutter devices

# Run the app
echo "Running the app..."
flutter run

echo "Done!" 