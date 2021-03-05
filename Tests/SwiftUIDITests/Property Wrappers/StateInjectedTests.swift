//
//  StateInjectedTests.swift
//  
//
//  Created by Tom van der Spek on 05/03/2021.
//

import XCTest
import SwiftUI
@testable import SwiftUIDI

final class StateInjectedTests: XCTestCase {
    
    func test_propertyWrapper_onAnonymousRegistration_shouldResolveAnonymousObject() {
        // Given
        let expectedResult = "Hello world"
        DependencyKey.defaultValue.register(expectedResult)
        
        // When
        let result: String = StateInjected().wrappedValue
        
        // Then
        XCTAssertEqual(result, expectedResult, "Resolve returned incorrect object")
    }
    
    func test_propertyWrapper_onLabelTest_shouldObjectWithLabelTest() {
        // Given
        let expectedResult = "Hello world"
        
        // When
        DependencyKey.defaultValue.register(expectedResult, at: \.helloWorld)
        let result: String = StateInjected().wrappedValue
        
        // Then
        XCTAssertEqual(result, expectedResult, "Resolve returned incorrect object")
    }
}

private extension DependencyLabel {
    var helloWorld: String.Type { String.self }
}
