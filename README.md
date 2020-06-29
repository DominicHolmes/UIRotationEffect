# UIRotationEffect

As of iOS 13.5, SwiftUI's `rotationEffect` modifier takes the "long way around" when animating changes in rotation. For example, a rotation from 350° to 20° will cover 330° of rotation, even though those angles have only 30° of separation.

UIKit's animation libraries handle this situation correctly. This Swift Package is a simple wrapper, accessible by modifier, that adds this UIKit rotation behavior to your UIKit view.

#### Known Issues (Ideas Welcome)
* Using this modifier with a very large (~1200x1200) SwiftUI view produces visual glitches.
* Explicit frames are required, otherwise the view takes up all available space.