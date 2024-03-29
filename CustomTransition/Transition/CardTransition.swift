
import UIKit

final class CardTransition: NSObject, UIViewControllerTransitioningDelegate {

    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromView: UIView
        let wrapFrame: CGRect?
    }
    let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let params = PresentCardAnimator.Params.init(
            fromCardFrame: self.params.fromCardFrame,
            fromView: self.params.fromView,
            wrapFrame: self.params.wrapFrame
        )
        return PresentCardAnimator(params: params)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        let params = DismissCardAnimator.Params.init(
            fromCardFrame: self.params.fromCardFrame,
            fromCardFrameWithoutTransform: self.params.fromCardFrameWithoutTransform,
            fromView: self.params.fromView,
            wrapFrame: self.params.wrapFrame
        )
        return DismissCardAnimator(params: params)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension CardTransition {

    static func start(from fromView: UIView, wrapFrame: CGRect? = nil, presented: UIViewController) -> CardTransition {

        let currentCellFrame = fromView.layer.presentation()!.frame
        let cardPresentationFrameOnScreen = fromView.superview!.convert(currentCellFrame, to: nil)

        let cardFrameWithoutTransform = { () -> CGRect in
            let center = fromView.center
            let size = fromView.bounds.size
            let rect = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return fromView.superview!.convert(rect, to: nil)
        }()

        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromView: fromView,
                                           wrapFrame: wrapFrame)
        let transition = CardTransition(params: params)

        presented.transitioningDelegate = transition
        presented.modalPresentationCapturesStatusBarAppearance = true
        presented.modalPresentationStyle = .custom

        fromView.parentViewController?.present(presented, animated: true)

        return transition
    }
}
