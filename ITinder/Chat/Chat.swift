//
//  Chat.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit
import Alamofire
import Kingfisher

struct Field {
    var name: String
    var profilePhoto: UIImage
    var lastmessage: String
}

struct ChatRow : Codable{
    var chat : ChatC = .init()
    var lastMessage : LastMessage = .init()
}
struct ChatC: Codable {
    var id : String = ""
    var title : String = ""
    var avatar : String = ""
}
struct LastMessage: Codable{
    var id : String = ""
    var text: String = ""
    var user : ProfileInfo = .init()
    var attachments : [String] = []
}



class Chat: UIViewController {
    
    let cellReuseIdentifier = "CustomCell"
    

    private var fileds: [Field] = [Field(name: "Tim", profilePhoto: #imageLiteral(resourceName: "ProfileVector"), lastmessage: "Hello bro"),
                                   Field(name: "Dan", profilePhoto: #imageLiteral(resourceName: "ProfileVector"), lastmessage: "Hello brouisgisug igs;ig sigecisgc;igsgcs;gc ;sige;isgcsigcs;egcsce;cisgcie;s")]
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
       
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName: "TableViewFieldCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        // Do any additional setup after loading the view.
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPAth: IndexPath )
    {
        let NextVC = Dialog()
        navigationController?.pushViewController(NextVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/chat", method: .get, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200){
                    let decoder = JSONDecoder()
                    let profiledata = try! decoder.decode([ChatRow].self, from: data)
                    print(String(data: data, encoding: .utf8))
                    for User in profiledata{
                        var appToField : Field = .init(name: User.lastMessage.user.name!, profilePhoto: #imageLiteral(resourceName: "Deny") , lastmessage: User.lastMessage.text)
                        if(User.chat.avatar != nil && User.chat.avatar != ""){
                            let tmpImage : UIImageView = .init()
                            tmpImage.kf.setImage(with: URL(string: User.chat.avatar))
                            self.fileds.append(Field.init(name: User.lastMessage.user.name!, profilePhoto: #imageLiteral(resourceName: "ProfileVector"), lastmessage: User.lastMessage.text))
                            let appToFieldTy : Field = .init(name: User.lastMessage.user.name!, profilePhoto: #imageLiteral(resourceName: "Pencil"), lastmessage: User.lastMessage.text)
                            appToField = appToFieldTy
                        }
                        
                        self.fileds.append(appToField)
                        print(self.fileds)
                    }
                }
                if(response.response?.statusCode == 401){
                    AF.request("http://193.38.50.175/itindr/api/mobile/v1/auth/refresh", method: .post, parameters: [
                        "refreshToken": UserSettings.ref_token!
                    ],
                    encoding: JSONEncoding.default).responseData { response in
                        switch response.result {
                        case .success(let data):
                        
                            if(response.response?.statusCode == 200){
                                
                                let decoder = JSONDecoder()
                                let tokens = try? decoder.decode(TokenResponse.self, from: data)
                                UserSettings.api_token = tokens?.accessToken
                                
    
                                
                            }
                        case .failure(let error):
                            print(error.errorDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
       navigationController?.setNavigationBarHidden(false, animated: false)
       
        
        
        tabBarController?.navigationController?.navigationBar.backItem?.hidesBackButton = true
        
        navigationController?.navigationBar.topItem?.title = "Чаты"
        
        tabBarController?.navigationController?.navigationBar.barTintColor = .green
        //navigationController?.navigationBar.tintColor
        tabBarController?.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

extension Chat: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
extension Chat: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileds.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableview.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? TableViewFieldCell else {
            return UITableViewCell()
            
        }
        cell.selectionStyle = .none
        cell.setUpCellData(fileds[indexPath.row])
        return cell
    }
}


