import Foundation
class Purchase: Codable {
    var activity:Activity
    var count:Int
    var price:Double
    var date:String
    var user:String?
    init(activity:Activity,count:Int,price:Double,date:String){
        self.activity = activity
        self.count = count
        self.price = price
        self.date = date
    }
}
