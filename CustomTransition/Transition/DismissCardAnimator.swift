
import UIKit

final class DismissCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    typealias ToVC = MainTabBarController
    typealias FromVC = HeroDetailViewController

    struct Params {
        let fromCardFrame: CGRect
        let fromCardFrameWithoutTransform: CGRect
        let fromView: UIView
        let wrapFrame: CGRect?
    }
    private let params: Params

    init(params: Params) {
        self.params = params
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return CardTransitionConstants.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (fromVC: FromVC, toVC: ToVC) = (
            ctx.viewController(forKey: .from)! as! FromVC,
            ctx.viewController(forKey: .to)! as! ToVC
        )
        let cardDetailView = ctx.view(forKey: .from)!

        func animateCardViewBackToPlace() {
            cardDetailView.snp.remakeConstraints { make in
                make.top.equalTo(self.params.wrapFrame?.minY ?? 0.0)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(self.params.wrapFrame?.height ?? container.bounds.height)
            }

            screens.fromVC.dismissTransitionBehavior(cardRect: self.params.fromCardFrameWithoutTransform, wrapFrame: self.params.wrapFrame)
            container.layoutIfNeeded()
        }

        UIView.animate(withDuration: transitionDuration(using: ctx), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
            animateCardViewBackToPlace()
            screens.fromVC.scrollView.contentOffset = .zero
        }) { _ in
            self.params.fromView.alpha = 1.0
            let success = !ctx.transitionWasCancelled
            ctx.completeTransition(success)
        }
    }
}
