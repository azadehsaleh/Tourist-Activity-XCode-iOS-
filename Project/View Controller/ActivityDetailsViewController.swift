import UIKit

class ActivityDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    var defaults:UserDefaults = UserDefaults.standard
    var currentActivity:Activity?
    var pickerData:[String] = []
    let db = ActivityDatabase.shared
    let userDB = UserDatabase.shared
    
    @IBOutlet weak var ActivityNameLable: UILabel!
    @IBOutlet weak var ActivityImage: UIImageView!
    @IBOutlet weak var ActivityDescribtion: UILabel!
    @IBOutlet weak var ActivityHostLable: UILabel!
    @IBOutlet weak var ActivityPriceLable: UILabel!
    @IBOutlet weak var ActivityFavorite: UISwitch!

    @IBAction func logoutClicked(_ sender: Any)
    {
        defaults.set(false, forKey: "loggedIn")
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func favoriteToggled(_ sender: UISwitch)
    {
        if(sender.isOn)
        {
            userDB.addFavorite(user: userDB.getCurrentUser(), activity: currentActivity!)
        }
        else
        {
            userDB.removeFavorite(user: userDB.getCurrentUser(), activity: currentActivity!)
        }
    }
    
    @IBAction func WebLinkClicked(_ sender: Any) {
        guard let nextScreen = storyboard?.instantiateViewController(identifier: "screenB") as? WebViewViewController else {
            print("Cannot find next screen")
            return
        }
        // send current activity's information
        if let currentActivity = currentActivity {
            nextScreen.currentActivityLink = currentActivity.websiteLink
        }
        // - navigate to the next screen
        self.navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    @IBOutlet weak var PurchaseBtt: UIButton!
    @IBAction func purchaseBttClicked(_ sender: Any) {
        // 1. Retrieve what was selected in the picker
        let selectedIndex = self.numberPicker.selectedRow(inComponent: 0)
        print("Selected index: \(selectedIndex)")
        
        // 2. Display it in the ui
        let box = UIAlertController(title: "Total Cost", message: "You will be charged \(Double(selectedIndex+1) * (currentActivity?.price ?? 0)) Are you sure?", preferredStyle: .actionSheet)
        box.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            let numberOfTickets = Double(selectedIndex+1)
            let priceOfActivity = self.currentActivity?.price
            let total = numberOfTickets * priceOfActivity!
            print("Total  \(numberOfTickets*priceOfActivity!)")
            let date = self.dateInput.text
            self.userDB.savePurchase(user: self.userDB.getCurrentUser(), purchase: Purchase(activity: self.currentActivity!, count: Int(numberOfTickets), price: total, date: date!))

        }))
        
        box.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(box, animated: true)
    }
    
    @IBOutlet weak var numberPicker: UIPickerView!
    var datePicker2 = UIDatePicker()
    let formatter = DateFormatter()
    var userLogined: String = ""
    @IBOutlet weak var dateInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello again \(userLogined)")
        
        if let currentActivity = currentActivity {
            ActivityNameLable.text = currentActivity.name
            ActivityImage.image = UIImage(named: currentActivity.image)
            ActivityDescribtion.text = currentActivity.describtion
            ActivityHostLable.text = "Hosted by: \(currentActivity.hostingName)"
            ActivityPriceLable.text = "Price per person: $\(String(currentActivity.price))"
            
            if userDB.isFavorite(user: userDB.getCurrentUser(), activity: currentActivity) {
                ActivityFavorite.isOn = true
            }
        }
        else {
            print("No activity found")
        }
        
        self.numberPicker.delegate = self
        self.numberPicker.dataSource = self
        for i in 1...5 {
            pickerData.append(String(i))
        }
            
        // formatter
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateInput.text = formatter.string(from: Date.now.addingTimeInterval(86400))
        createDatePicker()
        
    }
    
    func createDatePicker(){
        
        datePicker2.frame.size = CGSize(width: 0, height: 100)
        datePicker2.preferredDatePickerStyle = .wheels
        datePicker2.minimumDate = evaluateDate()
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // bar button
        let donBtt = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([donBtt], animated: true)

        //assign toolbar
        dateInput.inputAccessoryView = toolbar

        // assign datepicker to the button
        dateInput.inputView = datePicker2
        
        // date picker mode
        datePicker2.datePickerMode = .date
        
        // programatically add a navigation bar Logout button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
    }
    
    @objc func logoutButtonPressed() {
        print("Logout button pressed")
        guard let nextScreen = storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as? ViewController else {
            print("Cannot find Login screen")
            return
        }
        defaults.removeObject(forKey: "loggedIn")
        navigationController?.pushViewController(nextScreen, animated: true)
    }

    @objc func donePressed(){
        dateInput.text = formatter.string(from: datePicker2.date)
        self.view.endEditing(true)
    }
    
    func evaluateDate() -> Date {
        let tomorrow = Date.now.addingTimeInterval(86400)
        return(tomorrow)
    }
}
