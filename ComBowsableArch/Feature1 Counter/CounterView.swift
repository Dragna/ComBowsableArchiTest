//
// Created by Sébastien Drode on 25/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import SwiftUI

struct CounterView: View {
    @ObservedObject var store: Store<CounterState, CounterAction>

    public init(store: Store<CounterState, CounterAction>) {
        self.store = store
    }

    var body: some View {
        VStack {
            Text("\(store.value)")
                    .font(.largeTitle)
            HStack {
                Button(action: {
                    self.store.send(.decrTapped)
                }) {
                    Text("-")
                            .font(.largeTitle)
                }
                Button(action: {
                    self.store.send(.incrTapped)
                }) {
                    Text("+")
                            .font(.largeTitle)
                }
            }
        }
    }
}