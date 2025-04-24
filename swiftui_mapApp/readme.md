# 🗺️ SwiftUI Map App

A beautiful and interactive Map application built using **SwiftUI** and **MapKit**, allowing users to explore annotated locations, view Look Around previews, and test navigation routes. It offers a seamless and modern iOS experience powered by live location, route rendering, and smooth UI transitions.

## 📱 Features

- 📍 Display custom map annotations for locations
- 👤 Show the user’s current location with permission handling
- 🗺 View location cards with images, city name, and quick actions
- 🔍 Tap pins to preview street-level Look Around scenes
- 🧾 View a full-screen detail page with images, description, and Wikipedia link
- 🧭 Simulate navigation routes with `MapPolyline` rendering
- 📜 Expandable header to reveal a location list with tap-to-navigate behavior
- 💡 Smooth animations and transitions for a polished user experience

## 🧱 Project Structure

- `Location.swift`: Model for each location with name, coordinates, images, and more.
- `LocationViewModel.swift`: Handles state, current location selection, Look Around scene loading, and sheet toggling.
- `LocationView.swift`: Main map interface with annotations, user location, card footer, Look Around preview, and routing.
- `LocationCardView.swift`: Card displaying the current location with “Learn More” and “Next” options.
- `LocationDetailsView.swift`: Full details view with tabbed image gallery, descriptions, and embedded map.
- `LocationListView.swift`: Expandable list view to pick a location.
- `LocationsDataService.swift`: Provides static list of location data.
