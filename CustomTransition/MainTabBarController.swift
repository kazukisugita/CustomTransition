
import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.tabBar.isTranslucent = false

        let viewController = HeroViewController()
        viewController.tabBarItem = UITabBarItem(title: "DemoDemo", image: nil, selectedImage: nil)

        self.setViewControllers([viewController], animated: false)
    }
}
