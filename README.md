### Orkestria mobile app 
![orkestria](https://impulsecctv.com/wp-content/uploads/2024/03/Video-Surveillance-Can-Improve-Industrial-Security-Measures.webp)

Orkestria is a mobile application designed for monitoring industrial areas. It works in conjunction with a network of cameras and sensors installed on-site, capable of detecting and reporting events in real time. These devices are connected to a motherboard (board) that transmits the collected information to the Orkestria platform.

The mobile app provides users with a simplified and accessible way to track and manage events from anywhere. It complements the web platform by delivering key data and notifications directly to users’ devices, offering centralized event tracking and management.

### Flutter and Technical Details

Orkestria is developed using **Flutter**, an open-source UI software development kit by Google. The app is designed to be cross-platform, running smoothly on both iOS and Android devices.

- **Flutter Version:** [3.24.0]
- **Dart Version:** [>=3.5.4]
- **Target Platforms:** iOS, Android

### Architecture

The app follows **Clean Architecture**, ensuring a clear separation of concerns and maintainability. The primary components of this architecture include:

- **Presentation Layer (UI):** Handles the user interface and user interactions. This layer uses Flutter widgets to display data and respond to user actions.
- **Domain Layer:** Contains business logic and use cases. It is independent of external frameworks, allowing easy testing and maintenance.
- **Data Layer:** Responsible for data management and communication with external sources, such as APIs or local storage. This layer handles the transmission of data to and from the platform and ensures the app's functionality.

By using Clean Architecture, the app remains scalable, testable, and maintainable, even as new features are added.

### Data Organization and Use Cases

Data in Orkestria is structured around projects, zones, and connected equipment:

- **Project:** Represents the collection of zones within a locality or industrial site.
- **Zones:** Each project can include several distinct zones. For example, a project based in Algiers might include the zones of Dar El Beïda and Baraki.
- **Equipment:** Within each zone, motherboards (featuring USB 32 ports for event transmission) handle the connection and transmission of data to the platform.

### Additional Technical Details

- **State Management:** We use **Provider** for state management, ensuring smooth and reactive UI updates based on changes in the app's state.
- **Dependencies:** The app relies on several important packages, including `http` for API communication, `flutter_local_notifications` for notifications, and `shared_preferences` for local data storage.