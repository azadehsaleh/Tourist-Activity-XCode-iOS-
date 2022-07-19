import UIKit

class MyPurchaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDB.getPurchases(user: userDB.getCurrentUser()).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a cell to display
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell
        // Get the data for this row
        let purchasedData = userDB.getPurchases(user: userDB.getCurrentUser())[indexPath.row]
        cell.ActivityNameLable.text = "Activity Name: \(purchasedData.activity.name)"
        cell.ActivityQuantityLable.text = "Number of tickets: \(String(purchasedData.count))"
        cell.ActivityPriceLable.text = "Price: \(String(purchasedData.price))"
        cell.ActivityDateLable.text = "Date : \(purchasedData.date)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Deletion is always a 2 step process
                // Step 1: Delete the item from the data source array
                userDB.removePurchase(user: userDB.getCurrentUser(), index: indexPath.row)
                // Step 2: Delete the row from the UI
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                totalAmountLable.text = "Total is: $\(String(format: "%.2f", userDB.getPurchaseTotal(user: userDB.getCurrentUser())))"
                if let tabItems = tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the second tab:
                    let tabItem = tabItems[1]
                    tabItem.badgeValue = "\(userDB.getPurchases(user: userDB.getCurrentUser()).count)"
                }
            }
    }

    var defaults = UserDefaults.standard
    let db = ActivityDatabase.shared
    let userDB = UserDatabase.shared
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLable: UILabel!
    @IBOutlet weak var EmptyLable: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the Activity on the my Purchase list
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 130
        
        totalAmountLable.text = "Total is: $\(String(format: "%.2f", userDB.getPurchaseTotal(user: userDB.getCurrentUser())))"
        if (userDB.getPurchases(user: userDB.getCurrentUser()).isEmpty) {
            self.EmptyLable.isHidden = false
        } else {
            self.EmptyLable.isHidden = true
        }

    }
    override func viewWillAppear(_ animated: Bool) {
         print("Getting list of activities, again")
         self.tableView.reloadData()
        if (userDB.getPurchases(user: userDB.getCurrentUser()).isEmpty) {
            self.EmptyLable.isHidden = false
        } else {
            self.EmptyLable.isHidden = true
        }
        totalAmountLable.text = "Total is: $\(String(format: "%.2f", userDB.getPurchaseTotal(user: userDB.getCurrentUser())))"
     }
   
    
    
}
