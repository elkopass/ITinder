//
//  DialogCell.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 25.10.2021.
//

import UIKit

class DialogCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var photoProfile: UIImageView!
    func setUpCellData(_ fields: Message){
        
        photoProfile.image = fields.profilePhoto
        message.text = fields.message
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
