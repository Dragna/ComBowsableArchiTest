//
//  Counter.swift
//  ComposableArchitecture
//
//  Created by Sébastien Drode on 29/08/2019.
//  Copyright © 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import BowEffects

typealias CounterState = Int

enum CounterAction {
    case decrTapped
    case incrTapped
}

let counterReducer: Reducer<CounterState, CounterAction> = { state, action in
    switch action {
        case .decrTapped:
            state -= 1
            return []
        
        case .incrTapped:
            state += 1
            return []
    }
}
