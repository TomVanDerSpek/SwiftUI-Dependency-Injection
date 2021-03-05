//
//  RecursiveLock.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 01/03/2021.
//

import Foundation

final class RecursiveLock {
    private let lock = NSRecursiveLock()

    func sync<T>(action: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return action()
    }
}
