//
//  Created by Alireza Asadi on 4/8/24.
//

import Foundation

enum Child {
    struct Configuration {}

    struct State: StateProtocol {
        var count: Int = 0
    }

    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case questionButtonTapped
        case setText(String)
    }

    enum Destination {
        
    }
}
