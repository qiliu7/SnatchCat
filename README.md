## About
SnatchCat communicates with the Petfinder API to return adoptable cats from shelters that is near a user.

A user can initiate a new search by entering a location (or use the current location), check the details of returned cat results, move cats to "Favorites" list, and contact shelters for more info.

## Installation
1. Get your API Key and Secret at https://www.petfinder.com/developers/
2. Clone the repo
```
git clone https://github.com/qiliu7/SnatchCat.git
```
3. Open SnatchCat.xcodeproj with Xcode
4. Enter your API Key and Secret in `Models/Helpers/Secrets.swift`
```swift
static let apiKey = "INSERT APIKEY HERE"
static let clientSecret = "INSERT SECRET HERE"
```
5. Your are good to go!


## Supports
iOS 13.4,
Xcode 12.1,
swift 5
