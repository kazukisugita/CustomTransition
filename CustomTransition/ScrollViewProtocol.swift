import UIKit
import SnapKit

protocol ScrollViewProtocol: class {
    var scrollView: UIScrollView! { get set }
    var contentView: UIView! { get set }
    func initScrollView()
    func setBottomMarginToContentView()
}

extension ScrollViewProtocol where Self: UIViewController {

    func initScrollView() {

        scrollView = UIScrollView()
        contentView = UIView()
        self.view.addSubview(scrollView)

        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.delaysContentTouches = false // Make it responds to highlight state faster
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
            make.centerX.equalTo(scrollView.snp.centerX)
        }

        scrollView.frame.size.width = self.view.frame.width
        contentView.frame.size.width = self.view.frame.width
    }

    func setBottomMarginToContentView() {

        guard let lastView = contentView.subviews.last else { fatalError() }

        lastView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-100.0)
        }
    }
}
