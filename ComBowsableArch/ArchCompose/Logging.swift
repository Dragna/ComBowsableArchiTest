//
// Created by Sébastien Drode on 22/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import BowEffects

//public func logging<Value, Action>(
//        _ reducer: @escaping Reducer<Value, Action>
//) -> Reducer<Value, Action> {
//    return { value, action in
//        let effects = reducer(&value, action)
//        let newValue = value
//        return [IO<Never, Action>.fireAndForget(work: {
//            print("Action: \(action)")
//            print("Value:")
//            dump(newValue)
//            print("---")
//        })] + effects
//    }
//}
//
//extension IO where E == Never {
//    public static func fireAndForget<Action>(work: @escaping () -> Void) -> IO<E, Action> {
//        return IO<E, Action>.invoke {
//            work()
//        }
//    }
//}
