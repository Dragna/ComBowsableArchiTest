//
//  App.swift
//  ComposableArchitecture
//
//  Created by Sébastien Drode on 29/08/2019.
//  Copyright © 2019 Sébastien Drode. All rights reserved.
//

import Foundation

/// Global Enum Action of the app which is the composition of multiple subactions Enum
enum AppAction {
    case counter(CounterAction)
    case apiCall(APICallAction)
    
    var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }

    var apiCall: APICallAction? {
        get {
            guard case let .apiCall(value) = self else { return nil }
            return value
        }
        set {
            guard case .apiCall = self, let newValue = newValue else { return }
            self = .apiCall(newValue)
        }
    }
}

/// Global State of the app which is the composition of multiple substates
struct AppState {
    var count: CounterState = 0
    var apiCallFeature: APICallState = APICallState()
}

/// the App Environment aka Injection Container
struct AppEnvironment {
    let apiEnv: APICallEnv = APICallEnv()
}

/// Global reducer of the app, it's the composition of smaller reducers
let appReducer: EnvironmentContext<AppEnvironment, Reducer<AppState, AppAction>> = EnvironmentContext { env in
    combine(
            pullback(counterReducer,
                    value: \AppState.count,
                    action: \AppAction.counter),
            pullback(apiCallReducer.apply(env.apiEnv), // the apply method let us apply an env to a EnvReducer
                    value: \AppState.apiCallFeature,
                    action: \AppAction.apiCall)
    )
}

