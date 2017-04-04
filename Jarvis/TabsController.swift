import UIKit

class TabsController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .red
        
        let tabOne = HomeController()
        let tabOneBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = TestViewController()
        let tabTwoBarItem2 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        tabTwo.tabBarItem = tabTwoBarItem2
        
        self.viewControllers = [tabOne, tabTwo]
    }
    
    
}
