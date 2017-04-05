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
    
    func handleCam() {
        self.present(CamViewController(), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let tabOne = HomeController()
        let tabOneBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = TestViewController()
        let tabTwoBarItem2 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        tabTwo.tabBarItem = tabTwoBarItem2
        
        let tabThree = CamViewController()
        let tabTwoBarItem3 = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        tabThree.tabBarItem = tabTwoBarItem3
        
        self.viewControllers = [tabOne, tabTwo, tabThree]

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(handleCam))
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        
        case is HomeController:
            self.navigationController?.isNavigationBarHidden = false
            break

        case is CamViewController:
            self.navigationController?.isNavigationBarHidden = true
            break
            
        default:
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
}
