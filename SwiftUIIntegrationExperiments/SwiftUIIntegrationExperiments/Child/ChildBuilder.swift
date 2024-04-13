//
//  Created by Alireza Asadi on 4/8/24.
//

import UIKit

enum ChildBuilder: BaseSceneBuilder {    
	typealias Config = Child.Configuration
	typealias SceneView = ChildViewController

    @MainActor
	static func build(with configuration: Config) -> SceneView {
		let viewModel = viewModelBuilder(configuration: configuration)
		let router = ChildRouter()
		let viewController = SceneView(viewModel: viewModel, router: router)

		router.viewController = viewController

		return viewController
	}

    @MainActor
	private static func viewModelBuilder(configuration: Config) -> some StatefulViewModel<Child.State, Child.Action, Child.Destination> {
		ChildViewModel(configuration: configuration)
	}
}
