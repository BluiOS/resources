import UIKit
import PlaygroundSupport

class GravityViewController: UIViewController {
 
    var animator: UIDynamicAnimator!
    var box: UIView!
    var gravity: UIGravityBehavior!
    var counter = 0
    var collision: UICollisionBehavior!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBox()
        setupAnimator()
        setupBehavior()
        setupCollision()
    }
    
    func setupBox() {
        box = UIView()
//        box = UIView(frame: .init(x: 200, y: 10, width: 100, height: 100))
        box.backgroundColor = .red
        box.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(box)

        NSLayoutConstraint.activate([
            box.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            box.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            box.heightAnchor.constraint(equalToConstant: 100),
            box.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupAnimator() {
        animator = .init(referenceView: view)
    }
    
    func setupBehavior() {
//        gravity = .init(items: [box]) // crash
        gravity = .init()
        animator.addBehavior(gravity)
        
//        gravity.addItem(box) // crash
        
        gravity.gravityDirection = .init(dx: 0.0, dy: 1.0) // default value
//        gravity.gravityDirection = .init(dx: 1.0, dy: 0.0)
//        gravity.gravityDirection = .init(dx: 0.1, dy: 0.5)
//        gravity.gravityDirection = .init(dx: 0.1, dy: -1.0)
        
//        gravity.magnitude = 1.0  default valaue 1000 points / second * second
//        gravity.magnitude = 0.1
//        gravity.magnitude = 0.0
//        gravity.action = { [weak self] in
//            guard let self else { return }
//            counter += 1
//            if counter == 50 {
//                gravity.gravityDirection = .init(dx: 0.0, dy: -1.0)
//            }
//        }
    }
    
    func setupCollision() {
        collision = .init()
        animator.addBehavior(collision)
        
        collision.translatesReferenceBoundsIntoBoundary = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        gravity.addItem(box)
        collision.addItem(box)
    }
}

PlaygroundPage.current.liveView = GravityViewController()
