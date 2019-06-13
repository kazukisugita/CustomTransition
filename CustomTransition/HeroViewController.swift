
import UIKit
import SnapKit

enum Hero: Int, CaseIterable {
    case superman = 1, spiderman, lamborghini, boy, fireman

    public var image: UIImage? {
        return UIImage(named: "hero\(self.rawValue)")
    }

    public var text: String {
        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }
}

final class HeroViewController: UIViewController {

    private typealias TableViewCell = HeroTableViewCell
    private var cardTransitionHolder: CardTransition?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.className)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        configureLayouts()
    }

    private func configureLayouts() {

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
        }
    }
}

extension HeroViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Hero.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.className, for: indexPath) as! TableViewCell
        cell.configure(by: Hero.allCases[indexPath.row])
        return cell
    }
}

extension HeroViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let hero = Hero.allCases[indexPath.row]
        let safeAreaFrame = CGRect(
            x: 0.0,
            y: self.view.safeAreaInsets.top,
            width: self.view.frame.width,
            height: self.view.frame.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)
        )
        let wrapFrame = self.tableView.convert(safeAreaFrame, to: self.tableView)
        self.cardTransitionHolder = CardTransition.start(from: cell.presentAsCardItem, wrapFrame: wrapFrame, presented: HeroDetailViewController(by: hero))
    }
}
