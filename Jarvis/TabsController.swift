import UIKit

class TabsController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func handleSettings() {

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let lockAction = UIAlertAction(title: "Lock Jarvis", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            UserDefaults.standard.setIsLoggedIn(value: false)
            
            let loginController = LoginController()
            self.present(loginController, animated: true, completion: nil)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(lockAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let tabOne = HomeController()
        let tabOneBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = TestViewController()
        let tabTwoBarItem2 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        tabTwo.tabBarItem = tabTwoBarItem2
        
        self.viewControllers = [tabOne, tabTwo]

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        switch viewController {
//        
//        // show settings on home
//        case is HomeController:
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
//            break
//        // hide settings on test
//        case is TestViewController:
//            self.navigationItem.leftBarButtonItem?.isEnabled = false
//            self.navigationItem.leftBarButtonItem?.title = ""
//            break
//            
//        default:
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
//        }
//    }
    
}
