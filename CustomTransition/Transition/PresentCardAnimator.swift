
import UIKit
import SnapKit

final class PresentCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let params: Params

    struct Params {
        let fromCardFrame: CGRect
        let fromView: UIView
        let wrapFrame: CGRect?
    }

    private let presentAnimationDuration: TimeInterval
    private let springAnimator: UIViewPropertyAnimator
    private var transitionDriver: PresentCardTransitionDriver?

    init(params: Params) {
        self.params = params
        self.springAnimator = PresentCardAnimator.createBaseSpringAnimator(params: params)
        self.presentAnimationDuration = springAnimator.duration
        super.init()
    }

    private static func createBaseSpringAnimator(params: PresentCardAnimator.Params) -> UIViewPropertyAnimator {

        let damping: CGFloat = 1.0
        let duration: TimeInterval = CardTransitionConstants.animationDuration
        let springTiming = UISpringTimingParameters(dampingRatio: damping, initialVelocity: .init(dx: 0, dy: 0))

        return UIViewPropertyAnimator(duration: duration, timingParameters: springTiming)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        transitionDriver = PresentCardTransitionDriver(params: params,
                                                       transitionContext: transitionContext,
                                                       baseAnimator: springAnimator)
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return transitionDriver!.animator
    }
}

final class PresentCardTransitionDriver {

    public let animator: UIViewPropertyAnimator

    typealias FromVC = MainTabBarController
    typealias ToVC = HeroDetailViewController

    public init(params: PresentCardAnimator.Params, transitionContext: UIViewControllerContextTransitioning, baseAnimator: UIViewPropertyAnimator) {

        let ctx = transitionContext
        let container = ctx.containerView
        let screens: (fromVC: FromVC, toVC: ToVC) = (
            ctx.viewController(forKey: .from)! as! FromVC,
            ctx.viewController(forKey: .to)! as! ToVC
        )
        let cardDetailView = ctx.view(forKey: .to)!
        var cardDetailViewTopConstraint: Constraint?
        var cardDetailViewHeightConstraint: Constraint?
        container.addSubview(cardDetailView)
        cardDetailView.snp.makeConstraints { make in
            cardDetailViewTopConstraint = make.top.equalToSuperview().offset(params.wrapFrame?.minY ?? 0.0).constraint
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            cardDetailViewHeightConstraint = make.height.equalTo(params.wrapFrame?.height ?? container.bounds.height).constraint
        }
        let fromCardFrame = params.fromCardFrame
        params.fromView.alpha = 0.0
        screens.toVC.presentTransitionFromBehavior(cardRect: fromCardFrame, wrapFrame: params.wrapFrame)
        container.layoutIfNeeded()

        baseAnimator.addAnimations {
            cardDetailViewTopConstraint?.update(offset: 0.0)
            cardDetailViewHeightConstraint?.update(offset: container.bounds.height)
            screens.toVC.presentTransitionToBehavior()
            container.layoutIfNeeded()
        }
        baseAnimator.addCompletion { _ in
            let success = !ctx.transitionWasCancelled
            ctx.completeTransition(success)
        }
        self.animator = baseAnimator
    }
}
