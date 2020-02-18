//
//  Store.swift
//  ComposableArchitecture
//
//  Created by Sébastien Drode on 29/08/2019.
//  Copyright © 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import BowEffects
import Bow


public final class Store<Value, Action>: ObservableObject {
    private let reducer: Reducer<Value, Action>
    @Published public private(set) var value: Value

    public init(initialValue: Value,
                reducer: @escaping Reducer<Value, Action>) {
        self.reducer = reducer
        self.value = initialValue
    }

    public func send(_ action: Action) {
        let effects = self.reducer(&self.value, action)
        print(effects)
        effects.forEach { effect in
//            let action = IO<Never, Action>.var()
//            let sendEffect = binding(
//                continueOn(.global(qos: .userInitiated)),
//                action <- effect,
//                |<-ConsoleIO.print("action is \(action.get)"),
//                continueOn(.main),
//                |<-IO.invoke { self.send(action.get) },
//                yield: ()
//            )^
//            sendEffect.unsafeRunAsync({ _ in
//
//            })
            
            effect.continueOn(.global(qos: .background))^.unsafeRunAsync(on: .main,
            { resultAction in
                print(resultAction)
                self.send(resultAction.rightValue) //Should never error out
            })
        }
    }

    public func view<LocalValue, LocalAction>(
            value toLocalValue: @escaping (Value) -> LocalValue,
            action toGlobalAction: @escaping (LocalAction) -> Action
    ) -> Store<LocalValue, LocalAction> {
        let localStore = Store<LocalValue, LocalAction>(
                initialValue: toLocalValue(self.value),
                reducer: { localValue, localAction in
                    self.send(toGlobalAction(localAction))
                    localValue = toLocalValue(self.value)
                    return []
                }
        )
//        localStore.viewCancellable = self.$value.sink { [weak localStore] newValue in
//            localStore?.value = toLocalValue(newValue)
//        }
        return localStore
    }
}
