import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ActivityNameLable: UILabel!
    @IBOutlet weak var ActivityQuantityLable: UILabel!
    @IBOutlet weak var ActivityPriceLable: UILabel!
    @IBOutlet weak var ActivityDateLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
