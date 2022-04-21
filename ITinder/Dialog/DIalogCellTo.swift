//
//  DialogCellTo.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 28.10.2021.
//

import UIKit

class DialogCellTo: UITableViewCell {

    @IBOutlet weak var photoProfileTo: UIImageView!
    
    
    func setUpCellData(_ fields: Message){
        
        photoProfileTo.image = fields.profilePhoto
        
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
