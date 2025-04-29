# MindEase

MindEase is a simple yet powerful iOS mental health tracking application designed to help users monitor, understand, and improve their mental wellbeing through an intuitive, affordable, and privacy-focused platform.

## Core Features

### Mood Tracking
- Quick daily mood check-in with visual slider and emotion indicators
- Visual scale uses both colors and emoji for accessibility
- Optional contextual factors can be added (sleep, stress, etc.)
- Previous mood entries are easily viewable

## Project Structure

The project follows a clean architecture with the following structure:

- **UI**: Contains all UI components and views
- **Models**: Contains data models and types
- **Services**: Contains services for data management and API interactions

## Implementation Details

### Data Model
- Uses CoreData for persistent storage
- MoodEntry entity with attributes for date, mood level, context factors, and notes

### UI Components
- MoodSlider: A custom slider for selecting mood levels with visual feedback
- ContextFactorSelector: A grid of selectable context factors
- MoodEntryRow: A row component for displaying a single mood entry
- MoodHistoryView: A view for displaying the history of mood entries
- AddMoodEntryView: A view for adding a new mood entry

### Services
- MoodService: Handles CRUD operations for mood entries

## Future Enhancements
- Insights Dashboard: Visual representation of mood trends and correlations
- Reminders & Check-ins: Customizable notifications for consistent tracking
- Apple Health Integration: Bidirectional data sharing with Apple Health
- Team Wellness Dashboard: Anonymous aggregated team wellness metrics

## Getting Started

1. Clone the repository
2. Open MindEase.xcodeproj in Xcode
3. Build and run the project on a simulator or device

## Requirements
- iOS 15.0+
- Xcode 15.0+
- Swift 5.0+
