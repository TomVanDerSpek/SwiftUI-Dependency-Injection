//
//  DependencyScopeTests.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 26/02/2021.
//

import XCTest
@testable import SwiftUIDI

final class DependencyScopeTests: XCTestCase {
    
    struct SomeStruct {
        static var timesInstantiated: Int = 0
        var identifier: String
        init(identifier: String = "") {
            SomeStruct.timesInstantiated += 1
            self.identifier = identifier
        }
    }
    
    override func setUp() {
        super.setUp()
        SomeStruct.timesInstantiated = 0
    }
    
    func test_scope_onDependencyInAppScope_shouldBeInstantiatedOnce() {
        // Given
        let dependencies = Dependencies()
        dependencies.register(SomeStruct(), in: .app)
        
        // When
        _ = dependencies.resolve() as SomeStruct?
        _ = dependencies.resolve() as SomeStruct?
        
        // Then
        XCTAssertEqual(SomeStruct.timesInstantiated, 1)
    }
    
    func test_scope_onDependencyInNoScope_shouldBeInstantiatedTwice() {
        // Given
        let dependencies = Dependencies()
        dependencies.register(SomeStruct(), in: .none)
        
        // When
        _ = dependencies.resolve() as SomeStruct?
        _ = dependencies.resolve() as SomeStruct?
        
        // Then
        XCTAssertEqual(SomeStruct.timesInstantiated, 2)
    }
    
    func test_scope_onDependencyInAppScopeAndResettingScopeAfterSecondResolve_shouldBeInstantiatedTwice() {
        // Given
        let dependencies = Dependencies()
        dependencies.register(SomeStruct(), in: .app)
        
        // When
        _ = dependencies.resolve() as SomeStruct?
        _ = dependencies.resolve() as SomeStruct?
        dependencies.reset(.app)
        _ = dependencies.resolve() as SomeStruct?
        
        // Then
        XCTAssertEqual(SomeStruct.timesInstantiated, 2)
    }
    
    func test_scope_onRegisterSameTypeInSameScope_shouldRemoveOldInstanceFromScope() {
        // Given
        let dependencies = Dependencies()
        let expectedResult = "NewAppScope"
        
        // When
        dependencies.register(SomeStruct(identifier: "AppScope"), in: .app)
        _ = dependencies.resolve() as SomeStruct?
        dependencies.register(SomeStruct(identifier: expectedResult), in: .app)
        let result = dependencies.resolve() as SomeStruct?
        
        // Then
        XCTAssertEqual(result?.identifier, expectedResult)
    }
    
    func test_scope_onRegisterSameTypeInDifferentScope_shouldRemoveOldInstancesFromPreviousScope() {
        // Given
        let dependencies = Dependencies()
        let expectedResult = "SecondAuthenticatedScope"
        
        // When
        dependencies.register(SomeStruct(identifier: "FirstAuthenticatedScope"), in: .app)
        _ = dependencies.resolve() as SomeStruct?
        dependencies.register(SomeStruct(identifier: "AppScope"), in: .app)
        _ = dependencies.resolve() as SomeStruct?
        dependencies.register(SomeStruct(identifier: expectedResult), in: .app)
        let result = dependencies.resolve() as SomeStruct?
        
        // Then
        XCTAssertEqual(result?.identifier, expectedResult)
    }
    
    func test_threadSafety_onResolveOnDifferentQueues_shouldNotCrashAndOnlyInstantiateOneObject() {
        // Given
        let dependencies = Dependencies()
        dependencies.register(SomeStruct(), in: .app)
        
        // When
        var expectations: [XCTestExpectation] = []
        
        for index in (0..<20) {
            let expectation = self.expectation(description: "queue-\(index)")
            expectations.append(expectation)
            
            let queue = DispatchQueue(label: "queue-\(index)", qos: .background)
            queue.async {
                _ = dependencies.resolve() as SomeStruct?
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 2) { _ in
            XCTAssertEqual(SomeStruct.timesInstantiated, 1)
        }
    }
}
