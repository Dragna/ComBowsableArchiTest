//
// Created by Sébastien Drode on 25/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import BowEffects

//typealias APICallState = SWAPIPeopleResponse?

struct APICallState {
    var people: SWAPIPeopleResponse? = nil
}

typealias GetPeopleService = (Int) -> IO<Never, SWAPIPeopleResponse?>

struct APICallEnv {
    let getPeople: GetPeopleService =
            { id in
                getPeopleAPI(id: id)
            }
}

enum APICallAction {
    case fetchPeople
    case peopleResponse(response: SWAPIPeopleResponse?)
}

let apiCallReducer: EnvironmentContext<APICallEnv, Reducer<APICallState, APICallAction>> = EnvironmentContext { env in
    { state, action in
        switch action {
        case .fetchPeople:
            return [env.getPeople(1)
                    .map {
                        APICallAction.peopleResponse(response: $0)
                    }^]
                    //.receive(on: DispatchQueue.main)


        case .peopleResponse(let response):
            state.people = response
            return []
        }
    }
}
