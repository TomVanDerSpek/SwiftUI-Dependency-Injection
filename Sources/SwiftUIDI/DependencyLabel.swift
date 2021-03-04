//
//  DependencyLabel.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 26/02/2021.
//

import Foundation

/// You can use labels when you need multiple dependencies of the same type.
/// For example, if you need to inject an ApiKey and the name of the app
/// Because they are both of type String, without a label, one would override the other.
///
/// CODE EXAMPLE:
/// Add The following to this file:
///     extension DependencyLabel {
///         var apiKey: String.Type { String.self }
///         var appName: String.Type { String.self }
///     }
///
/// And then register them
///     dependencies.register("12sdf23gsDg", for: \.apiKey)
///     dependencies.register("DemoApp", for: \.appName)
///
public struct DependencyLabel { }
