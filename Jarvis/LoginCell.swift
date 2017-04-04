import UIKit
import LBTAComponents
import LocalAuthentication

class LoginCell: UICollectionViewCell {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orange
        button.setTitle("Authenticate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: LoginControllerDelegate?
    
    func handleLogin() {
        authenticate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoImageView)
        addSubview(loginButton)
        
        logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -230, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 160, heightConstant: 160)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        loginButton.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func authenticate() {
        let authenticationContext = LAContext()
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "With great power, comes great responsibility...",
            reply: { [unowned self] (success, error) -> Void in
                if( success ) {
                    self.delegate?.finishLoggingIn()
                }else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
        })
    }
    
}
