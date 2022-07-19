import UIKit

class ActivityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //number of columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //number of rows of data
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return pickerData[row]
       }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerData[row] == "FAVORITES")
        {
            self.activityList = userDB.getFavorites(user: userDB.getCurrentUser())
            self.item.title = "Favorites"
            self.item.image = UIImage(named: "favorites")
            self.collection.reloadData()
            return
        }
        
        let selectedIndex = self.picker.selectedRow(inComponent: 0)
        self.item.image = UIImage(named: cityList[selectedIndex].image)
        self.item.title = cityList[selectedIndex].name
        print(cityList[selectedIndex].name)
        activityList = (cityList[selectedIndex].activities)
        self.collection.reloadData()
        
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell to display
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! MyCollectionViewCell
        let activitiesList = activityList[indexPath.row]
        cell.cellLable.text = activitiesList.name
        cell.cellPriceLable.text = "Price: $\(String(activitiesList.price))/Person"
        cell.activityImage.image = UIImage(named: activitiesList.image)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        if (activitiesList.isPopular){
            cell.layer.backgroundColor = UIColor.yellow.cgColor
        }else {
            cell.layer.backgroundColor = UIColor.clear.cgColor
        }
        // Return the cell
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nextScreen = storyboard?.instantiateViewController(identifier: "ActivityDetailsScreen") as? ActivityDetailsViewController else {
            print("Cannot find next screen")
            return
        }
        // send current/selected activity's information
        nextScreen.currentActivity = activityList[indexPath.row]
        nextScreen.userLogined = self.userLogined
        //Go to  Activity screen
        self.navigationController?.pushViewController(nextScreen, animated: true)
        
        //Go to  Activity screen
        return
    }
   
    var db = ActivityDatabase.shared
    let userDB = UserDatabase.shared

    var activityList:[Activity] = []
    var cityList:[City]=[]
    var activityListLondon:[Activity]=[]
    var pickerData: [String] = [String]()
    var userLogined: String = ""
    @IBOutlet weak var item: UITabBarItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var picker: UIPickerView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello \(userLogined)")
        
        titleLabel.text = "Things to do in "
        self.activityList = db.getAll()
        self.activityListLondon = db.getAllLondon()
        self.collection.dataSource = self
        self.collection.delegate = self
        
        pickerData = ["PARIS", "LONDON", "FAVORITES"]
        self.picker.dataSource = self
        self.picker.delegate = self
        
        cityList = [City(name: "PARIS", activities: activityList, image: "PARIS"),
                    City(name: "LONDON", activities: activityListLondon,image: "london")]
        
        self.item.image = UIImage(named: cityList[0].image)
        self.item.title = cityList[0].name
        
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the second tab:
            let tabItem = tabItems[1]
            tabItem.badgeValue = "\(userDB.getPurchases(user: userDB.getCurrentUser()).count)"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabItems = tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the second tab:
            let tabItem = tabItems[1]
            tabItem.badgeValue = "\(userDB.getPurchases(user: userDB.getCurrentUser()).count)"
        }
        
        // Update the Favorite View
        let selectedRow = self.picker.selectedRow(inComponent: 0)
        if(selectedRow == 2)
        {
            self.activityList = userDB.getFavorites(user: userDB.getCurrentUser())
            self.item.title = "Favorites"
            self.item.image = UIImage(named: "favorites")
            self.collection.reloadData()
            return
        }
    }

}
