[![xcode-version](https://img.shields.io/badge/xcode-11-brightgreen)](https://developer.apple.com/xcode/)
[![swift-version](https://img.shields.io/badge/swift-5-orange)](https://github.com/apple/swift)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) <br>


# Hydrate App (iOS)

Hydrate is a simple app that helps you track your water consumption per day. The water consumption is measured by cups, and the consumption goal everyday is customizable. The goal completion and consumption history can also be seen in a calendar view.

Watch the demo video:    
[![Link to App Demo](http://img.youtube.com/vi/Axu7xvnobP8/0.jpg)](http://www.youtube.com/watch?v=Axu7xvnobP8 "Hydrate App Demo")    
[Link to YouTube Video](https://youtu.be/Axu7xvnobP8)

## Purpose 
The purpose of this app is to provide a way of manually keeping track of your daily water consumption with a simple user interface that can be used by anyone. 

## Key Features
- Secure authentication
- Set daily goals for water consumption
- Opt in for daily reminders in the form of a notification to remember to complete your goal
- View your consumption and goal completion history using a calendar to select the dates 

## Technologies used
The app uses Firebase and Firestore for authentication and data storage. [CLTypingLabel](https://cocoapods.org/pods/CLTypingLabel) is used in the login screen, to give the text a typing animation when the view loads up. [FSCalendar](https://cocoapods.org/pods/FSCalendar) is used for the calendar view on the calendar tab, which lets the user select a certain date and view the stats for the selected date.    
**Note** - To run this project on your local machine, you need to create a Firebase project and place the *GoogleService-Info.plist* into the *Hydrate* folder.

## App Screenshots 
<p float="left">
  <img src="screenshots/ss1.png" width="280" />
  <img src="screenshots/ss2.png" width="280" /> 
  <img src="screenshots/ss3.png" width="280" />
  <img src="screenshots/ss4.png" width="280" />
  <img src="screenshots/ss5.png" width="280" />
  <img src="screenshots/ss6.png" width="280" />
</p>
