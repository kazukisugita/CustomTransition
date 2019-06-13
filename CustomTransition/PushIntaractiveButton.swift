import UIKit

class PushIntaractiveButton: UIButton {}

extension PushIntaractiveButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
