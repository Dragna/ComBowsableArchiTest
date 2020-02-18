//
// Created by Sébastien Drode on 25/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import SwiftUI

struct APICallFeatureView: View {
    @ObservedObject var store: Store<APICallState, APICallAction>

    public init(store: Store<APICallState, APICallAction>) {
        self.store = store
    }

    var body: some View {
        VStack {
            Button(action: {
                self.store.send(.fetchPeople)
            }) {
                Text(store.value.people != nil
                        ? "Re-fetch" 
                        : "Fetch"
                )
            }
            // when value exists
            store.value.people.map { people in
                VStack {
                    Text("Name: \(people.name)")
                    Text("Gender: \(people.gender)")
                    Text("Height: \(people.height)")
                    Text("Mass: \(people.mass)")
                }
            }
        }
    }
}
