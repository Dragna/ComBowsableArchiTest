//
// Created by Sébastien Drode on 22/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import BowEffects

public typealias Reducer<Value, Action> = (inout Value, Action) -> [IO<Never, Action>]

//public typealias EnvReducer<Value, Action, Environment> = (Environment) -> Reducer<Value, Action>

public class EnvironmentContext<EnvironmentType, Value> {
    let envToValueClosure: (EnvironmentType) -> Value

    init(envToValueClosure: @escaping (EnvironmentType) -> Value) {
        self.envToValueClosure = envToValueClosure
    }

    func apply(_ environment: EnvironmentType) -> Value {
        envToValueClosure(environment)
    }
}