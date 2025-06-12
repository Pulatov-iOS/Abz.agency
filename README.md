# README

## abz.agency

An iOS application built with SwiftUI that enables users to sign up for an agency and view a list of registered users. It includes form validation, image upload, pagination, and persistent caching using Core Data.

---

### Configuration

The app is preconfigured to work with the official ABZ test API.
If needed, you can modify the base URL in `APIManager.swift`:

```swift
private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
```

Ensure the API endpoints remain consistent with your backend requirements.

---

### Customization

You can customize:

* **Positions dropdown**: Adjust logic in `SignUpViewModel` or modify how positions are loaded in `fetchPositions()`.
* **Validation rules**: Update `signUp()` method to enforce different validation conditions.
* **Success view behavior**: Modify the response handling inside `signUp()` to change how success/failure is presented.

---

### Dependencies

* **Alamofire**: Used for network requests and image uploading with multipart/form-data.

  * Install via Swift Package Manager:

    ```swift
    https://github.com/Alamofire/Alamofire.git
    ```
* **Core Data**: Used for persistent user caching and offline access.

---

### Troubleshooting

* **Image compression error**: Make sure the uploaded image can be converted to JPEG format using `UIImage.jpegData()`.
* **Token error**: Ensure token is correctly fetched from `/token` endpoint before making POST requests.
* **Photo upload fails**: Check if the image is selected and not nil before calling the API.

---

### Build Instructions

1. Clone this repository.
2. Open the project in Xcode.
3. Make sure your deployment target is iOS 15.0 or higher.
4. Install dependencies via Swift Package Manager.
5. Build and run on simulator or device.

---

# Documentation

## External Libraries

### Alamofire

**Purpose**: Network communication, including multipart form uploads.
**Why**: Simplifies networking code, supports async callbacks, and robust error handling.

### Core Data

**Purpose**: Persistent storage for offline use.
**Why**: Native Apple framework with good performance and integration for caching user data.

---

## Code Structure Overview

### ViewModels

* `SignUpViewModel.swift`

  * Manages sign-up form state, validation, API interactions.
  * Handles photo selection, error states, and UI visibility toggles.
* `MainViewModel.swift`

  * Fetches user list from API and persists via Core Data.
  * Handles pagination and initial offline load.

### Networking

* `APIManager.swift`

  * Central hub for all API interactions:

    * `fetchUsers`: GET users with pagination
    * `fetchPositions`: GET available positions
    * `fetchToken`: GET authorization token
    * `submitUser`: POST sign-up data with image as multipart

### Models

* `User`, `Position`, `UsersResponse`, etc. conform to `Codable` for easy parsing.
* Error messages and field errors parsed and displayed accordingly.

### Core Data

* `CoreDataManager.swift`

  * Saves, fetches, and deletes cached user entities.
  * Converts between `UserEntity` (Core Data) and `User` model.

---

## App Flow

1. **Home Screen**:

   * Lists users with pagination.
   * Loads from Core Data if available.

2. **Sign-Up Screen**:

   * Form fields: Name, Email, Phone, Position (dropdown), Photo.
   * Validates data and uploads via multipart/form-data.
   * Displays success or field-level errors.

3. **Data Storage**:

   * Saved users in Core Data on first load.
   * Avoids redundant API calls.

---

## Notes

* The API requires a token before submission. It is automatically retrieved and used in `submitUser()`.
* Error messages from the server are parsed and shown to the user.
* UI states such as `showSuccess`, `isLoading`, and `fieldErrors` are handled via `@Published`.
