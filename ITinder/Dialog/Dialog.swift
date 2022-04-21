//
//  Dialog.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 25.10.2021.
//

import UIKit
struct Message{
    var time: String
    var profilePhoto: UIImage
    var message: String
    var incoming : Bool
}

class Dialog: UIViewController{
    
    let cellReuseIdentifier = "CustomCell"
    let cellReuseIdentifierTo = "CustomCellTo"
    

    private var fileds: [Message] = [Message(time: "Tim", profilePhoto: #imageLiteral(resourceName: "ProfileVector"), message: "Hello broThe answer here, for anyone searching, is to edit the storyboard and remove any link to the undefined key specified. You have to edit the storyboard file in an external editor: Right click on the storyboard listing in the hierarchy and then click on  or what have you. Open in a text editor, remove said links by searching, save and return to Xcode. No more issue.", incoming: false),
    Message(time: "Dan", profilePhoto: #imageLiteral(resourceName: "ProfileVector"), message: "Hello brouisgisug igs;ig sigecisgc;igsgcs;gc ;sige;isgcsigcs;egcsce;cisgcie;s", incoming: true)]
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(UINib(nibName: "DialogCellTo", bundle: nil), forCellReuseIdentifier: cellReuseIdentifierTo)
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
       navigationController?.navigationBar.backItem?.title = "Назад"
       navigationController?.setNavigationBarHidden(false, animated: false)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}
extension Dialog: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 96
//    }
    
}
extension Dialog: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileds.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(fileds[indexPath.row].incoming == false){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? DialogCell else {
                return UITableViewCell()
            }
            cell.setUpCellData(fileds[indexPath.row])
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifierTo) as? DialogCellTo else {
                return UITableViewCell()
            }
            cell.setUpCellData(fileds[indexPath.row])
            return cell
        }
        
    }
}
