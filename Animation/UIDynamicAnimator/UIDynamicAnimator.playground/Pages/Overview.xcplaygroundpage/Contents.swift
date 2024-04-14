// overview

// What is UIDynmaicAnimator?
/// An object that provides physics-related capabilities and animations for its dynamic items, and provides the context for those animations.
/// Using this feature, we can experience the effect of Earth's gravity on objects, such as the downward fall of an object, or understanding how objects collide, and what behavior they should exhibit after the collision, along with other similar behaviors.
/// In short, it's a physics engine for executing physics relationships in animations.


// How can we use this feature?
/// To use it, you simply need to implement the UIDynamicItem protocol, which is already implemented by default by UIView and UICollectionViewLayoutAttributes.


// What is UIDynamicItem?
/// A set of methods that can make a custom object eligible to participate in UIKit Dynamics.
/// (Required) bounds: represent a view's location (x,y)and size (width, height) relative to its own coordinate system and called when a dynamic animator needs the bounds of the item.
/// (Required) center: The center point of the item and called when it has computed a new center point for the item.
/// (Required) transform: The rotation of the item and called this method when it has computed a new rotation value for the item.
/// (optional) collisionBoundsType: The type of collision bounds associated with the item. (It's of type UIDynamicItemCollisionBoundsType)
/// (optional) collisionBoundingPath (It's of type UIBezierPath)

/// UIDynamicItemCollisionBoundsType:
/// UIDynamicItemCollisionBoundsType provides us with three options: rectangle, ellipse, and path.
/// By default, it's set to rectangle. When it's set to rectangle or ellipse, the item uses the bounds property. If it's set to path, it uses collisionBoundingPath property.
/// If the value is set to path, then collisionBoundingPath must be implemented.


// How do we configure it?
/// In order to use the dynamicItem we created, we need to add one or more Dynamic behaviors to it. By default, classes UIDynamicBehavior, UICollisionBehavior,  UIDynamicItemBehavior, UIGravityBehavior, UIPushBehavior and UISnapBehavior are created for this purpose.
/// if we want to create a custom behavior, we need to inherit from the UIDynamicBehavior class. how to create a custom: https://developer.apple.com/documentation/uikit/uidynamicbehavior


// Dynamic animator interacts with dynamic items
/// Before adding an item to a behavior: The starting position, rotation and bounds should be determined before adding the item.
/// After you add the behavior to an animator, the animator takes over: it updates the item’s position and rotation as animation proceeds  (UIDynamicItem protocol)
/// During the animation, we can set the values ​​of the mentioned properties using function updateItem(usingCurrentState:), and then control it again by the animator.


/// https://developer.apple.com/documentation/uikit/uidynamicanimator
/// https://developer.apple.com/documentation/uikit/uidynamicitem
/// https://developer.apple.com/documentation/uikit/uidynamicbehavior
