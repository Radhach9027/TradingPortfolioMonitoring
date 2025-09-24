# 📈 Portfolio Trading iOS App

A simplified **trading portfolio monitoring** application for iOS. This app displays the user's investment portfolio with **real-time price updates**, showcasing balance and individual positions with detailed metrics.

---

## 🚀 Features

- ✅ Display **portfolio balance**: net value, profit & loss (PnL), and PnL percentage.
- ✅ Show detailed **position data**: ticker, company name, quantity, price, cost, market value, and live PnL.
- ✅ **Live price simulation** every second to mimic open market behavior.
- ✅ **Reactive UI updates** using Combine.
- ✅ Clean, **programmatic UI** with reusable UICollectionView cells.
- ✅ Comprehensive **JSON decoding error handling**.
- ✅ Architecture following **Clean Architecture** with **MVVM** pattern.

---

## 🧱 Architecture Overview

### ✅ Clean Architecture

The app is structured following **Clean Architecture** principles, separating concerns into distinct layers:

---

### 📦 Data Layer

Responsible for fetching and decoding raw data from the API.

- Contains DTOs such as `PortfolioWrapper`, which maps the API response.
- Implements network logic in:
  - `PortfolioRepository`
  - `LivePricesRepository`
- Contains API configurations like:
  - `PortfolioEndpoint`
- Handles JSON decoding and error transformations.

---

### 🧠 Domain Layer

Defines business rules and core logic.

- Pure Swift models:
  - `Portfolio`, `Balance`, `Position`, `Instrument`
- Defines abstraction protocols:
  - `PortfolioRepositoryProtocol`
  - `LivePricesRepositoryProtocol`
- Implements:
  - **Live price simulation** logic
  - **Portfolio balance and PnL aggregation**

---

### 🎨 Presentation Layer

Handles UI rendering and state presentation.

#### 📊 ViewModel

- `PortfolioViewModel`:
  - Coordinates data fetching.
  - Subscribes to live prices.
  - Exposes state using Combine publishers.
  - Computes real-time updates for positions and balance.

#### 🖼 View

- `PortfolioViewController`:
  - Implements a **compositional layout UICollectionView**.
  - Uses `GenericCollectionViewController` for modular rendering.
- `PositionCell`:
  - Displays ticker, company, price, quantity, and live PnL.
  - Built programmatically using reusable `BaseLabel` styles.

---

## 🔄 Live Price Simulation

A background service simulates **live prices** for each instrument by updating values every second.

### Mechanics:

- Each `lastTradedPrice` is updated within a **±10% range** from the original price.
- The following values are recalculated every second:

#### 📈 Per Position:
- `marketValue = quantity * lastTradedPrice`
- `pnl = marketValue - cost`
- `pnlPercentage = (pnl * 100) / cost`

#### 💼 Portfolio Balance:
- `netValue = sum of all marketValues`
- `pnl = sum of all pnls`
- `pnlPercentage = (pnl * 100) / total cost`

> These updates are published via Combine and reflected in the UI in real time.

---

## 🎨 Design System

This project uses a **modular, programmatic design system** for UI components to promote reusability and consistency.

### 🔤 BaseLabel

A custom `UILabel` subclass with predefined styles:

- `.title`: Bold font, larger size for key data like tickers or PnL.
- `.subtitle`: Secondary text style for descriptive values.

> Used throughout the app for consistency in `PositionCell` and elsewhere.

---

### 📚 GenericCollectionViewController

A reusable, abstracted controller built on top of `UICollectionViewController`.

#### Features:
- Supports dynamic and grouped data models.
- Fully programmatic.
- Easy cell registration and updates.
- Injects configuration via:
  - `GroupedModel`
  - `ConfigureCollectionsModel`

#### Example:
```swift
GenericCollectionViewController(
    grouped: yourGroupedModel,
    layout: yourCompositionalLayout,
    cellForItem: { cell, indexPath in
        // Configure cell
    },
    didSelectItem: { cell, indexPath in
        // Handle tap
    }
)

# 🛰️ Networking Layer

A **modular and scalable networking layer** built with **Combine**, following **SOLID principles**.  
It abstracts network communication using protocols and extensions, ensuring **testability, flexibility, and maintainability**.

---

## 📦 Components

### ✅ NetworkClient
- Central class responsible for executing network requests.
- Uses **dependency injection** with `URLSessionProtocol` for flexibility and test mocking.
- Decodes JSON into `Codable` models using `JSONDecoder`.
- Returns responses as `AnyPublisher<T, Error>` with Combine.

### ✅ NetworkClientProtocol
- Defines an abstraction over `NetworkClient`.
- Enables mocking and testability in unit tests.

### ✅ NetworkRequestProtocol
- Describes how requests are constructed (URL, headers, method, timeout).
- Provides `makeRequest()` to safely build a `URLRequest`.

### ✅ URLSessionProtocol
- Abstracts the system `URLSession`.
- Allows mocking with `MockURLSession`.
- Makes `NetworkClient` fully testable.

### ✅ Supporting Types
- `NetworkRequestMethod`: Enum for HTTP methods (`GET`, `POST`, etc.)
- `NetworkHTTPHeaderField`: Type-safe representation of HTTP headers.
- `NetworkRequestProtocolError`: Custom error types for invalid request construction.

---

## 🛠 Features & Benefits

| Feature            | Description                                                                |
| ------------------ | -------------------------------------------------------------------------- |
| 🔄 Loosely Coupled | Logic abstracted into protocols, reducing tight coupling across layers.     |
| 🧪 Testable        | Mock protocols enable injecting fake responses for unit testing.           |
| 📦 Scalable        | Easily extend to new endpoints without touching core logic.                |
| ♻️ Maintainable    | Centralized decoding & error handling improves clarity and safety.          |
| 🧱 Flexible        | Supports custom timeouts, HTTP methods, and headers per endpoint.          |

---

## 📝 Example Usage

```swift
// Define a request
struct PortfolioRequest: NetworkRequestProtocol {
    var path: String { "/portfolio" }
    var method: NetworkRequestMethod { .get }
    var headers: [NetworkHTTPHeaderField: String]? { nil }
}

// Execute with NetworkClient
let client: NetworkClientProtocol = NetworkClient(session: URLSession.shared)

let cancellable = client.execute(PortfolioRequest())
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            print("❌ Error: \(error)")
        case .finished:
            break
        }
    }, receiveValue: { (portfolio: Portfolio) in
        print("✅ Portfolio received: \(portfolio)")
    })
