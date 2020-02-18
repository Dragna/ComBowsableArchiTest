//
// Created by Sébastien Drode on 22/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import Combine

public struct Effect<Output>: Publisher {
    public typealias Failure = Never

    let publisher: AnyPublisher<Output, Failure>

    public func receive<S>(
            subscriber: S
    ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        self.publisher.receive(subscriber: subscriber)
    }
}

extension Publisher where Failure == Never {
    public func eraseToEffect() -> Effect<Output> {
        return Effect(publisher: self.eraseToAnyPublisher())
    }

    static func empty() -> Effect<Output> {
        Empty().eraseToEffect()
    }

    static func mergeMany(_ outputs: [Effect<Output>]) -> Effect<Output> {
//        Publishers
//                .Sequence<[Effect<Output>], Never>(sequence: outputs)
//                .flatMap({ $0 })
//                .eraseToEffect()
        Publishers
                .MergeMany(outputs)
                .eraseToEffect()
    }
}

extension Effect {
    public static func fireAndForget(work: @escaping () -> Void) -> Effect {
        return Deferred { () -> Empty<Output, Never> in
            work()
            return Empty(completeImmediately: true)
        }.eraseToEffect()
    }
}

extension Effect {
    static func sync(work: @escaping () -> Output) -> Effect {
        return Deferred {
            Just(work())
        }.eraseToEffect()
    }
}
