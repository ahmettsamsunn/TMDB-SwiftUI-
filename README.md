# TMDB Movies App - NetworkingLibrary Implementation Example

This project serves as a practical example of implementing and utilizing the NetworkingLibrary in a real-world application. The TMDB (The Movie Database) API is used to demonstrate various features and capabilities of the NetworkingLibrary.

## NetworkingLibrary Implementation

### Key Components

1. **Request Adaptation (TMDBAuthAdapter)**
   - Implements `RequestAdaptation` protocol
   - Handles API authentication by automatically injecting the API key
   - Shows how to modify requests before they are sent

2. **Network Requests (TMDBEndpoint)**
   - Implements `NetworkRequestable` protocol
   - Demonstrates endpoint configuration:
     - Base URL management
     - Path construction
     - HTTP method specification
     - Query parameter handling

3. **Service Layer (MovieService)**
   - Shows how to create a service layer using NetworkingLibrary
   - Implements async/await pattern for network calls
   - Demonstrates error handling and response parsing
   - Examples of different request types:
     - GET requests with query parameters
     - Pagination handling
     - Response type mapping

4. **Response Handling**
   - Generic `PaginatedResponse` implementation
   - Type-safe response mapping
   - Error handling patterns

## Usage Examples

### Basic Request
```swift
let result = await networking.executeRequest(
    request: TMDBEndpoint.popular(page: page),
    responseType: MovieResponse.self
)
```

### Request with Authentication
```swift
struct TMDBAuthAdapter: RequestAdaptation {
    func adapt(request: URLRequest) -> URLRequest {
        // Adds API key to requests
    }
}
```

### Endpoint Definition
```swift
enum TMDBEndpoint: NetworkRequestable {
    case nowPlaying(page: Int)
    case popular(page: Int)
    case search(query: String, page: Int)
    case movieDetails(id: Int)
    
    var baseURL: String { "https://api.themoviedb.org/3" }
    var method: HTTPMethod { .get }
    var path: String {
        // Path construction based on case
    }
}
```

## Benefits Demonstrated

- Clean separation of networking concerns
- Type-safe request and response handling
- Easy request modification through adapters
- Centralized error handling
- Simplified response parsing
- Reusable networking patterns

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- NetworkingLibrary
- TMDB API Key

## Setup

1. Clone the repository
2. Open TMBD.xcodeproj in Xcode
3. Configure with your API key in TMDBAuthAdapter
4. Build and run the project

## Credits

- Movie data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- Built using NetworkingLibrary

