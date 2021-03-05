//
//  EnvironmentValues+DIContainer.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 24/02/2021.
//

import SwiftUI

public struct DependencyKey: EnvironmentKey {
    
    public static let defaultValue: Dependencies = Dependencies()
}

public extension EnvironmentValues {
    
    var dependencies: Dependencies {
        get { return self[DependencyKey.self] }
    }
}
