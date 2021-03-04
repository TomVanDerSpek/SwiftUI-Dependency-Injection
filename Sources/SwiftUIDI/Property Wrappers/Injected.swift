//
//  Injected.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 24/02/2021.
//

import SwiftUI

@propertyWrapper
public final class Injected<Value> {
    
    @Environment(\.dependencies) private var dependencies: Dependencies
    private let keyPath: KeyPath<DependencyLabel, Value.Type>?
    private lazy var _wrappedValue: Value = {
        guard let service: Value = dependencies.resolve(for: keyPath) else {
            fatalError("Service \(Value.self) not registered! See logs for more information")
        }
        return service
    }()
    
    public var wrappedValue: Value { get { return _wrappedValue } }
    
    public init(_ keyPath: KeyPath<DependencyLabel, Value.Type>? = nil) {
        self.keyPath = keyPath
    }
}
