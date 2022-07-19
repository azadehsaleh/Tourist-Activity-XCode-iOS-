import Foundation
class City{
    var name:String
    var activities:[Activity]
    var image:String
    init(name:String,activities:[Activity],image:String){
        self.name = name
        self.activities = activities
        self.image = image
    }
}
