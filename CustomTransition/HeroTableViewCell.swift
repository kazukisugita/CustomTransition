
import UIKit
import SnapKit

class HeroTableViewCell: UITableViewCell {

    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.groupTableViewBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureLayouts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }

    private func configureLayouts() {

        self.contentView.addSubview(heroImageView)
        heroImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-20.0)
            make.bottom.equalToSuperview().offset(-20.0)
            make.left.equalToSuperview().offset(20.0)
        }
    }
}

extension HeroTableViewCell {

    public func configure(by hero: Hero) {
        self.heroImageView.image = hero.image
    }

    public var presentAsCardItem: UIView {
        return self.heroImageView
    }
}
