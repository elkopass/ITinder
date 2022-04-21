//
//  TableViewFieldCell.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 14.10.2021.
//

import UIKit

class TableViewFieldCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thelastmes: UILabel!
    @IBOutlet weak var photoProfile: UIImageView!
    
    func setUpCellData(_ fields: Field){
        name.text = fields.name
        thelastmes.text = fields.lastmessage
        photoProfile.image = fields.profilePhoto
        
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
