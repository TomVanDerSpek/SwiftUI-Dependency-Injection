//
//  Dependencies.swift
//  Dependency InjectionDemo
//
//  Created by Tom van der Spek on 24/02/2021.
//

import Foundation

public final class Dependencies {
    private var serviceRecords: [ServiceKey: Record] = [:]
    private var scopedServices: [DependencyScope: [ServiceKey: Any]] = [:]
    private let lock = RecursiveLock()
    
    /// Creates an object for the given type. This method is thread safe.
    /// - Parameter keyPath: The `KeyPath` with which the registered factory is labeled with.
    /// - Returns: The object created from the registered factory or fetched from scope.
    public func resolve<T>(for keyPath: KeyPath<DependencyLabel, T.Type>? = nil) -> T? {
        let serviceKey = ServiceKey(serviceType: T.self, keyPath: keyPath)
        
        return lock.sync {
            guard let record = serviceRecords[serviceKey] else {
                print("Trying to resolve \(T.self), but no factory registered at keyPath \(String(describing: keyPath))")
                return nil
            }
        
            if let storedService = scopedServices[record.scope]?[serviceKey] as? T {
                return storedService
            }
            
            guard let service = record.factory() as? T else {
                print("Resolved object \(record.factory().self) not of type \(T.self)")
                return nil
            }
            
            retainService(service, in: record.scope, with: serviceKey)
            
            return service
        }
    }
    
    /// Register a factory for resolving an object. This method is thread safe.
    /// - Parameters:
    ///   - factory: A closure that creates an object of the given type.
    ///   - keyPath: The `KeyPath` under which the factory will be registered.
    ///   - scope: The `Scope` in which the object will be retained after the first resolve.
    public func register<T>(_ factory: @escaping @autoclosure () -> T, at keyPath: KeyPath<DependencyLabel, T.Type>? = nil, in scope: DependencyScope = .none) {
        lock.sync {
            let serviceKey = ServiceKey(serviceType: T.self, keyPath: keyPath)
            let record = Record(factory: factory, scope: scope)
            serviceRecords[serviceKey] = record
            removeScopedServices(for: serviceKey)
        }
    }
    
    /// Remove all factories and removes in scope retained object for the given type (and keyPath). This method is thread safe.
    /// - Parameter keyPath: the `KeyPath` the registration is associated with.
    public func unregister<T>(_ type: T.Type, at keyPath: KeyPath<DependencyLabel, T.Type>? = nil) {
        lock.sync {
            let serviceKey = ServiceKey(serviceType: type, keyPath: keyPath)
            serviceRecords.removeValue(forKey: serviceKey)
            removeScopedServices(for: serviceKey)
        }
    }
    
    /// Remove all registered factories and removes in scope retained objects.  This method is thread safe.
    public func unregisterAll() {
        lock.sync {
            serviceRecords = [:]
            scopedServices = [:]
        }
    }
    
    /// Remove all references to retained objects in the specified scope. This method is thread safe.
    /// - Parameter scope: The `Scope` that should clear its retained objects.
    public func reset(_ scope: DependencyScope) {
        lock.sync {
            scopedServices[scope] = [:]
        }
    }
    
    private func retainService(_ service: Any, in scope: DependencyScope, with serviceKey: ServiceKey) {
        guard scope != .none else { return }
        if var existingScopeBucket = scopedServices[scope] {
            existingScopeBucket[serviceKey] = service
            scopedServices[scope] = existingScopeBucket
        } else {
            scopedServices[scope] = [serviceKey: service]
        }
    }
    
    private func removeScopedServices(for serviceKey: ServiceKey) {
        scopedServices.forEach { (scope, values) in
            var values = values
            values.removeValue(forKey: serviceKey)
            scopedServices[scope] = values
        }
    }
}

private struct Record {
    let factory: () -> Any
    var scope: DependencyScope
}

private struct ServiceKey: Hashable {
    let serviceType: Any.Type
    let keyPath: AnyKeyPath?
    
    init(serviceType: Any.Type,
         keyPath: AnyKeyPath? = nil) {
        self.serviceType = serviceType
        self.keyPath = keyPath;
    }
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
        keyPath.hash(into: &hasher)
    }
    
    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.serviceType == rhs.serviceType
            && lhs.keyPath == rhs.keyPath
    }
}
