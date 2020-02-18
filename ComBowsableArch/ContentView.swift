//
//  ContentView.swift
//  ComposableArchitecture
//
//  Created by Sébastien Drode on 29/08/2019.
//  Copyright © 2019 Sébastien Drode. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    @State var selectedView = 2
    @State var shouldPUshEmptyView = false
//    @ObservedObject var navStore = Store<NavigationState, NavigationActions>(
//            initialValue: NavigationState(),
//            reducer: with(
//                    navigationTestReducer,
//                    logging
//            )
//    )

    var body: some View {
        TabView {
            CounterView(store: store.view(
                    value: { $0.count },
                    action: { .counter($0) })
            ).tabItem {
                Image(systemName: "1.circle")
                Text("Counter")
            }.tag(0)
            APICallFeatureView(store: store.view(
                    value: { $0.apiCallFeature },
                    action: { .apiCall($0) })
            ).tabItem {
                Image(systemName: "2.circle")
                Text("Simple API Call")
            }.tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(
                initialValue: AppState(),
                reducer: appReducer.apply(AppEnvironment())
//                with(
//                        appReducer.apply(AppEnvironment()),
//                        logging
//                )
        )

        return ContentView(store: store)
    }
}
