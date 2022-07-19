import Foundation
import UIKit

class UserDatabase
{
    static let shared = UserDatabase()
    
    private var userList = [User(userId: 1, emailAdrees: "azadeh.saleh@gmail.com", password: "1234"), User(userId: 2, emailAdrees: "dharin.shah@gmail.com", password: "0987")]
    
    func getUsers() -> [User]
    {
        return userList
    }
    
    func getUser(byId userId: Int) -> User? {
        for user in userList {
            if user.userId == userId {
                return user
            }
        }
        
        return nil
    }
    
    func getUser(byIndex index: Int) -> User {
        return userList[index]
    }
    
    func getCurrentUser() -> User {
        return getUser(byId: UserDefaults.standard.integer(forKey: "currentUser"))!
    }
    
    func savePurchase(user: User, purchase: Purchase) {
        var purchases = getPurchases(user: user)
        purchases.append(purchase)
        
        UserDefaults.standard.setEncodablesAsArrayOfDictionaries(purchases, for: "\(user.userId)-purchases")
    }
    
    func getPurchases(user: User) -> [Purchase] {
        let purchases: [Purchase]? = UserDefaults.standard.getDecodablesFromArrayOfDictionaries(for: "\(user.userId)-purchases")
        if (purchases == nil)
        {
            return []
        }
        else
        {
            return purchases!
        }
    }
    
    func removePurchase(user: User, index: Int) {
        var purchases = getPurchases(user: user)
        
        purchases.remove(at: index)
        
        UserDefaults.standard.setEncodablesAsArrayOfDictionaries(purchases, for: "\(user.userId)-purchases")
    }
    
    func getPurchaseTotal(user: User) -> Double {
        
        var total:Double = 0
        for p in getPurchases(user: user){
            total += p.price
        }
        return total
        
    }
    
    func addFavorite(user: User, activity: Activity) {
        var activities = getFavorites(user: user)
        //activity.isPopular = true
        activities.append(activity)
        
        UserDefaults.standard.setEncodablesAsArrayOfDictionaries(activities, for: "\(user.userId)-favorites")
    }
    
    func getFavorites(user: User) -> [Activity] {
        let activities: [Activity]? = UserDefaults.standard.getDecodablesFromArrayOfDictionaries(for: "\(user.userId)-favorites")
        if (activities == nil)
        {
            return []
        }
        else
        {
            return activities!
        }
    }
    
    func removeFavorite(user: User, index: Int) {
        var activities = getFavorites(user: user)

        activities.remove(at: index)
        
        UserDefaults.standard.setEncodablesAsArrayOfDictionaries(activities, for: "\(user.userId)-favorites")
    }
    
    func removeFavorite(user: User, activity: Activity) {
        var activities = getFavorites(user: user)

        for i in 0..<activities.count
        {
            if activity.name == activities[i].name
            {
                activities.remove(at: i)
                break
            }
        }
        
        UserDefaults.standard.setEncodablesAsArrayOfDictionaries(activities, for: "\(user.userId)-favorites")
    }
    
    func isFavorite(user: User, activity: Activity) -> Bool {
        let activities = getFavorites(user: user)

        for i in 0..<activities.count
        {
            if activity.name == activities[i].name
            {
                return true
            }
        }
        
        return false
    }
}

extension Encodable {
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String : Any]
    }
}

extension Decodable {
    init?(dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        guard let object = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = object
    }
}

extension UserDefaults {
    func setEncodableAsDictionary<T: Encodable>(_ encodable: T, for key: String) {
        self.set(encodable.asDictionary, forKey: key)
    }

    func getDecodableFromDictionary<T: Decodable>(for key: String) -> T? {
        guard let dictionary = self.dictionary(forKey: key) else {
            return nil
        }
        return T(dictionary: dictionary)
    }
}

extension UserDefaults {
    func setEncodablesAsArrayOfDictionaries<T: Encodable>(_ encodables: Array<T>, for key: String) {
        let arrayOfDictionaries = encodables.map({ $0.asDictionary })
        self.set(arrayOfDictionaries, forKey: key)
    }

    func getDecodablesFromArrayOfDictionaries<T: Decodable>(for key: String) -> [T]? {
        guard let arrayOfDictionaries = self.array(forKey: key) as? [[String: Any]] else {
            return nil
        }
        return arrayOfDictionaries.compactMap({ T(dictionary: $0) })
    }
}
