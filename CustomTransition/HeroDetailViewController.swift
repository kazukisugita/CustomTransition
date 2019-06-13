
import UIKit
import SnapKit

class HeroDetailViewController: UIViewController, ScrollViewProtocol {

    var scrollView: UIScrollView!
    var contentView: UIView!

    public let heroImageHeight: CGFloat = 350.0

    private lazy var heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.groupTableViewBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var heroImageTopConstraint: Constraint?
    private var heroImageWidthConstraint: Constraint?
    private var heroImageHeightConstraint: Constraint?

    private lazy var belowContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.bottom.equalToSuperview().offset(-20.0)
            make.left.equalToSuperview().offset(20.0)
        }
        return view
    }()
    private var belowContainerTopConstraint: Constraint?

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private lazy var closeButton: PushIntaractiveButton = {
        let button = PushIntaractiveButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(self.view.tintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 20.0
        button.layer.masksToBounds = true
        return button
    }()
    private var closeButtonBottomMarginConstraint: Constraint?

    required init(by hero: Hero) {
        super.init(nibName: nil, bundle: nil)

        self.heroImage.image = hero.image
        self.textLabel.text = hero.text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        if self.view.safeAreaInsets.top > 0.0 {
            self.heroImageTopConstraint?.update(offset: -self.view.safeAreaInsets.top)
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear

        initScrollView()
        configureLayouts()
    }

    private func configureLayouts() {

        contentView.addSubview(heroImage)
        heroImage.snp.makeConstraints { make in
            heroImageTopConstraint = make.top.equalToSuperview().constraint
            make.centerX.equalToSuperview()
            heroImageWidthConstraint = make.width.equalTo(0.0).constraint
            heroImageHeightConstraint = make.height.equalTo(0.0).constraint
        }
        contentView.addSubview(belowContainerView)
        belowContainerView.snp.makeConstraints { make in
            belowContainerTopConstraint = make.top.equalTo(heroImage.snp.bottom).constraint
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            closeButtonBottomMarginConstraint = make.bottomMargin.equalToSuperview().offset(0.0).constraint
            make.width.equalTo(300.0)
            make.height.equalTo(64.0)
            make.centerX.equalToSuperview()
        }

        setBottomMarginToContentView()
    }

    @objc private func handleClose() {
        self.dismiss(animated: true)
    }
}

extension HeroDetailViewController {

    public func dismissTransitionBehavior(cardRect: CGRect, wrapFrame: CGRect?) {

        self.heroImageWidthConstraint?.update(offset: cardRect.width)
        self.heroImageHeightConstraint?.update(offset: cardRect.height)
        self.heroImageTopConstraint?.update(offset: cardRect.minY - (wrapFrame?.minY ?? 0.0))
        let diff = UIScreen.main.bounds.height - cardRect.maxY
        self.belowContainerTopConstraint?.update(offset: diff)
        self.closeButtonBottomMarginConstraint?.update(offset: 200.0)
    }

    public func presentTransitionFromBehavior(cardRect: CGRect, wrapFrame: CGRect?) {

        self.heroImageTopConstraint?.update(offset: cardRect.minY - (wrapFrame?.minY ?? 0.0))
        self.heroImageWidthConstraint?.update(offset: cardRect.width)
        self.heroImageHeightConstraint?.update(offset: cardRect.height)
        let diff = UIScreen.main.bounds.height - heroImageHeight
        self.belowContainerTopConstraint?.update(offset: diff)
        self.closeButtonBottomMarginConstraint?.update(offset: 200.0)
    }

    public func presentTransitionToBehavior() {

        self.heroImageTopConstraint?.update(offset: 0.0)
        self.heroImageWidthConstraint?.update(offset: self.view.frame.width)
        self.heroImageHeightConstraint?.update(offset: heroImageHeight)
        self.belowContainerTopConstraint?.update(offset: 0.0)
        self.closeButtonBottomMarginConstraint?.update(offset: -30.0)
    }
}
