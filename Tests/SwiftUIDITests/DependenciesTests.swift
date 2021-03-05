//
//  DependenciesTests.swift
//  Dependency InjectionDemo iOS
//
//  Created by Tom van der Spek on 25/02/2021.
//

import XCTest
@testable import SwiftUIDI

final class DependenciesTests: XCTestCase {

    func test_dependencies_onRegisterString_shouldReturnHelloWorld() {
        // Given
        let dependencies = Dependencies()
        let expectedResult = "Hello world"
        dependencies.register(expectedResult)
        
        // When
        let result: String? = dependencies.resolve()
        
        // Then
        XCTAssertEqual(result, expectedResult, "Resolve returned incorrect object")
    }
    
    func test_dependencies_onOverrideRegisteredString_shouldReturnNewString() {
        // Given
        let dependencies = Dependencies()
        let expectedResult = "New String"
        dependencies.register("Hello world")
        
        // When
        dependencies.register(expectedResult)
        let result: String? = dependencies.resolve()
        
        // Then
        XCTAssertEqual(result, expectedResult, "Resolve returned incorrect object")
    }
    
    func test_labeledDependencies_onLabeledRegister_shouldResolveCorrectObjects() {
        // Given
        let dependencies = Dependencies()
        let helloWorldExpectedResult = "Hello world"
        let apiKeyExpectedResult = "supersecret"
        
        // When
        dependencies.register(helloWorldExpectedResult, at: \.helloWorld)
        dependencies.register(apiKeyExpectedResult, at: \.apiKey)
        let helloWorld: String? = dependencies.resolve(for: \.helloWorld)
        let apiKey: String? = dependencies.resolve(for: \.apiKey)
        
        // Then
        XCTAssertEqual(helloWorld, helloWorldExpectedResult, "Resolve returned incorrect object")
        XCTAssertEqual(apiKey, apiKeyExpectedResult, "Resolve returned incorrect object")
    }
    
    func test_unregister_onUnregister_shouldNotResolveDependency() {
        // Given
        let dependencies = Dependencies()
        let helloWorldExpectedResult = "Hello world"

        // When
        dependencies.register(helloWorldExpectedResult)
        dependencies.unregister(String.self)
        let helloWorld: String? = dependencies.resolve()

        // Then
        XCTAssertNil(helloWorld)
    }
    
    func test_unregister_onUnregisterWithLabel_shouldNotResolveDependency() {
        // Given
        let dependencies = Dependencies()
        let helloWorldExpectedResult = "Hello world"

        // When
        dependencies.register(helloWorldExpectedResult, at: \.helloWorld)
        dependencies.unregister(String.self, at: \.helloWorld)
        let helloWorld: String? = dependencies.resolve(for: \.helloWorld)

        // Then
        XCTAssertNil(helloWorld)
    }
    
    func test_unregister_onUnregisterAll_shouldNotResolveAnyDependency() {
        // Given
        let dependencies = Dependencies()

        // When
        dependencies.register("Hello world", in: .app)
        dependencies.register(1)
        dependencies.register(true, at: \.someBool)
        dependencies.unregisterAll()
        
        // Then
        XCTAssertNil(dependencies.resolve() as String?)
        XCTAssertNil(dependencies.resolve() as Int?)
        XCTAssertNil(dependencies.resolve() as Bool?)
    }
}

private extension DependencyLabel {
    var helloWorld: String.Type { String.self }
    var apiKey: String.Type { String.self }
    var someBool: Bool.Type { Bool.self }
}
