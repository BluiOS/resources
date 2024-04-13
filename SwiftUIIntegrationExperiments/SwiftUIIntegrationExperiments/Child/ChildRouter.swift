//
//  Created by Alireza Asadi on 4/8/24.
//

import UIKit

protocol ChildRouterProtocol: AnyObject {

}

final class ChildRouter: ChildRouterProtocol {
    weak var viewController: ChildViewController?
}
