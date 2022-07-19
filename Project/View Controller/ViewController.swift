import UIKit

class ViewController: UIViewController {
    
    var defaults = UserDefaults.standard
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var switchToggle: UISwitch!
    
    @IBAction func logOutBtt(_ sender: Any) {
        defaults.removeObject(forKey: "msgKey")
    }
    
    @IBAction func loginBtt(_ sender: Any) {
        guard let userEmail = emailField.text, let userPassword = passwordField.text else {
            print("Data are not assigned")
            return
        }
        if (userEmail.isEmpty){
            messageLabel.text = "You must enter email!"
        } else if (userPassword.isEmpty){
            messageLabel.text = "You must enter password!"
        }
        else {
            var successfull = false
            for i in 0..<UserDatabase.shared.getUsers().count{
                let user = UserDatabase.shared.getUser(byIndex: i)
                if (user.emailAdrees == userEmail
                    && user.password == userPassword) {
                    successfull = true

                    if (switchToggle.isOn) {
                        // save data for Automatically Login
                        defaults.set(true, forKey: "loggedIn")
                    }
                    
                    defaults.set(user.userId, forKey: "currentUser")
                    // navigate to next b
                    // - try to get a reference to the next screen
                    guard let goToActivityScreen = storyboard?.instantiateViewController(identifier: "tabarid") as? UITabBarController else {
                        print("Cannot find next screen")
                        return
                    }

                    // - navigate to the next screen
                    self.navigationController?.pushViewController(goToActivityScreen, animated: true)
                }
            }
            
            if !successfull
            {
                messageLabel.text = "Incorrect Email or Password!"
            }
        }
        
        emailField.text = ""
        passwordField.text = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userImage.image = UIImage(named: "userImage")
        switchToggle.isOn = false
        
        // retrieve data for Automatically Login
        if (defaults.bool(forKey: "loggedIn") == true) {
            guard let goToActivityScreen = storyboard?.instantiateViewController(identifier: "tabarid") as? UITabBarController else {
                print("Cannot find next screen")
                return
            }
            self.navigationController?.pushViewController(goToActivityScreen, animated: false)
            return
        }
        else {
            defaults.set(false, forKey: "loggedIn")
        }
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
}

