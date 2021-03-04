//
//  DependencyScope.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 26/02/2021.
//

import Foundation

/// You can use and add scopes if you want to retain an object for the lifetime of that scope.
/// This means that the object will only be created once and stored inside the scope. On every injection of the object, the same object instance will be injected.
/// For example, if you want to share a token while the user is logged in, you could create an authenticated scope.
/// As soon as the user logs out, you can reset the scope, so the token will be recreated the next time it is requested.
///
/// CODE EXAMPLES:
/// Add a new scope in the extension below:
///     static let authenticated: DependencyScope = DependencyScope(name: "Authenticated")
///
/// And then, register the object in the scope:
///     dependencies.register(Token(), in: .authenticated)
///
/// Reseting the scope:
///     dependencies.reset(.authenticated)
///
public struct DependencyScope: Hashable {
    let uuid: UUID = UUID()
}

public extension DependencyScope {
    static let none: DependencyScope = DependencyScope()
    static let app: DependencyScope = DependencyScope()
}
