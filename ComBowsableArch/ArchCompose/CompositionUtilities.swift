//
//  CompositionUtilities.swift
//  ComposableArchitecture
//
//  Created by Sébastien Drode on 29/08/2019.
//  Copyright © 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import BowEffects
import Bow

public struct EmptyEnvironment {}

public func combine<Value, Action>(
        _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    return { value, action in
        // let's get an array of effects of our different reducers
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
//        // reduce it to a single Effect
//        let combinedEffects: IO<Never, Action> = effects.reduce(into: IO<Never, Action>()) { (combinedIO, currentIO) in
//            IO.zip(combinedIO, currentIO)
//        }
        return effects
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
        _ reducer: @escaping Reducer<LocalValue, LocalAction>,
        value: WritableKeyPath<GlobalValue, LocalValue>,
        action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    return { globalValue, globalAction in
        // get the local action and local env or return an empty Effect
        guard let localAction = globalAction[keyPath: action]
                else {
            return []
        }
        let localEffects = reducer(&globalValue[keyPath: value], localAction)

        return localEffects.map { localEffect in
                    localEffect.map { localAction -> GlobalAction in
                        var globalAction = globalAction
                        globalAction[keyPath: action] = localAction
                        return globalAction
                    }^
                }
               // .eraseToEffect()
    }
}

public func compose<A, B, C>(
        _ f: @escaping (B) -> C,
        _ g: @escaping (A) -> B
)
                -> (A) -> C {

    return { (a: A) -> C in
        f(g(a))
    }
}

public func with<A, B>(_ a: A, _ f: (A) throws -> B) rethrows -> B {
    return try f(a)
}
