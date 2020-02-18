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

extension DispatchQueue {
  class var currentLabel: String {
    return String(validatingUTF8: __dispatch_queue_get_label(nil)) ?? ""
  }
}

public final class Store<Value, Action>: ObservableObject {
    private let reducer: Reducer<Value, Action>
    @Published public private(set) var value: Value

    public init(initialValue: Value,
                reducer: @escaping Reducer<Value, Action>) {
        self.reducer = reducer
        self.value = initialValue
    }

    public func send(_ action: Action) {
        DispatchQueue.main.async {
            print("send method called on \(DispatchQueue.currentLabel)")
            let effects = self.reducer(&self.value, action)
            print(effects)
            effects.forEach { effect in
//                let action = IO<Never, Action>.var()
//                let sendEffect = binding(
//                    |<-ConsoleIO.print("starting work ! \(DispatchQueue.currentLabel)"),
//                    continueOn(.global(qos: .userInitiated)),
//                    action <- effect,
//                    |<-ConsoleIO.print("action is \(action.get) on \(DispatchQueue.currentLabel)"),
//                    continueOn(.main),
//                    |<-ConsoleIO.print("will call send method on \(DispatchQueue.currentLabel)"),
//                    |<-IO.invoke { self.send(action.get) },
//                    yield: ()
//                )^
//                sendEffect.unsafeRunAsync({ _ in
//    
//                })
                
                effect.unsafeRunAsync(on: .global(qos: .userInitiated),
                { resultAction in
                    print("Resulting action : \(resultAction) on \(DispatchQueue.currentLabel)")
                    self.send(resultAction.rightValue) //Should never error out
                })
            }
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
