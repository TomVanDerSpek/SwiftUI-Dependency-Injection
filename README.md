# SwiftUIDI

SwiftUIDI is a dependency injection framework. It includes a propertyWrapper to easily get dependencies in your objects.

## Swift Package Manager
`https://github.com/TomVanDerSpek/SwiftUI-Dependency-Injection`

## Setup

```swift
import SwiftUIDI
```

### Register a dependency

Before you can get a dependency, you will need to register it in the Dependencies.swift class. To get an instance of this class you'll have to make you of the @Environment(.\) property wrapper. 

```swift
@Environment(\.dependencies) var dependencies: Dependencies
```

Now we have a reference to the class that contains all dependencies we can start adding dependencies. 

```swift
dependencies.register({
    return UserDefaults()
})
```

Because the register method supports auto closure, we can shorten the syntax:
```swift
dependencies.register(UserDefaults())
```

The factory block we registered above will be triggered every time the dependency is being.

### Scope
If you don't want a new dependency on every resolve, you can register a dependency in a specific scope. 

```swift
dependencies.register(UserDefaults(), in: .app)
```

Now we have registering the dependency in the predefined scope `.app`. Every time this dependency is resolved, you will get the same instance. 
This instance is created on the first time the dependency is resolved and stored in the specified scope.

You might want to reset the scope if you want to get a newly created instance of a dependency the next time it is being resolved. For instance, if a user logs out, you might want to clear stored instances that contain sensitive data. 

To clear all stored instances of a certain scope you can reset the scope:

```swift
dependencies.reset(.app)
```

### Custom scope
It is also possible to define a custom scope. All you have to do is add an extension to the `DependencyScope.swift`:

```swift
extension DependencyScope {
    static let login: DependencyScope = DependencyScope()
}
```

### Dependency Conflict
There are cases where you want to register multiple objects of the same type. 
For example, you want to inject the color of a background and the color of a text.
If you would just register both, one will override the other, because they are both from the same type (Color). 

To make this possible, you can register a dependency with an unique label. 
First let's define the labels by adding them in an extension of `DependencyLabel.swift`:

```swift
extension DependencyLabel {
    var backgroundColor: Color.Type { Color.self }
    var textColor: Color.Type { Color.self }
}
```

Now we can use these to register the dependencies to the specific label:

```swift
dependencies.register(Color.red, at: \.backgroundColor)
dependencies.register(Color.blue, at: \.textColor)
```

### Resolve Dependencies

After you have registered your dependencies, you can get them form anywhere you like by using the property wrapper `@Injected`:

```swift
@Injected var userDefaults: UserDefaults
```

And for labeled dependencies:

```swift
@Injected(\.backgroundColor) var backgroundColor: Color
```

If you can't use the property wrapper, you can always resolve a dependency yourself by calling the .resolve method on the Dependencies instance:

```swift
let userDefaults = dependencies.resolve() as UserDefaults? 
```
