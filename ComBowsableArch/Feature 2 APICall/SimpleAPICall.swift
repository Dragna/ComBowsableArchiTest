//
// Created by Sébastien Drode on 25/11/2019.
// Copyright (c) 2019 Sébastien Drode. All rights reserved.
//

import Foundation
import Combine
import BowEffects

public struct SWAPIPeopleResponse: Decodable {
    let name: String
    let height: String
    let mass: String
    let gender: String
}

extension IO {
 func replaceError(_ f: @escaping (E) -> A) -> IO<Never, A> {
    self.handleError(f)^
            .mapLeft({ _ in fatalError() })
 }
}

func getPeopleAPI(id: Int) -> IO<Never, SWAPIPeopleResponse?> {
    var components = URLComponents(string: "https://swapi.co/api/people/\(id)")!

    return  URLSession.shared
        .dataTaskIO(with: components.url(relativeTo: nil)!)
            .map { _, data in data }
            .map { data in
                try? JSONDecoder().decode(SWAPIPeopleResponse?.self, from: data)
            }^
            .replaceError({ _ in nil })
}
