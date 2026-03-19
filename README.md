# iOS Networking Playground (URLSession + async/await)

Small, focused iPhone app to demonstrate production-grade networking fundamentals in Swift.

## What this repo demonstrates
- URLSession with async/await
- Robust error handling (offline, timeout, 4xx/5xx, decoding)
- Typed request/response models and decoding strategy
- Unit tests with URLProtocol mocking
- Clean, readable structure and documentation

## Scope (intentionally minimal)
- Minimal SwiftUI UI focused on networking correctness (not a full product app).

## App feature (minimal)
- Search a GitHub username
- Show profile + public repositories
- Loading / empty / error UI states

## Next milestones
- Define an APIClient with typed endpoints
- Implement URLProtocol-based mocks
- Add unit tests for error mapping and decoding failures