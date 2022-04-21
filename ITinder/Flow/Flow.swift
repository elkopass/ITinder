//
//  Flow.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit
import Alamofire
struct Isliked: Codable {
    var isMutual : Bool
}
struct UserID {
    var  userId : String?
}
class Flow: UIViewController {
    
    var profiledata :  [ProfileInfo] = []
    var currentId : String = ""
    var massivOfUsers : [UserID] = []
    let UserFree : ProfileInfo = .init(userId: "nope", name: "GG wp", aboutMyself: "NO ANY USERS", avatar: nil, topics: nil)
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var aboutMyself: UILabel!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var profname: UILabel!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        ProfilePhoto.layer.cornerRadius = 103
        ProfilePhoto.contentMode = .scaleAspectFill
        
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/user/feed", method: .get, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200){
                    let decoder = JSONDecoder()
                    self.profiledata = try! decoder.decode([ProfileInfo].self, from: data)
                    //print(String(data: data, encoding: .utf8))
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    let currentData : ProfileInfo = self.findNewUser(profiledata: self.profiledata)
                    self.aboutMyself.text = currentData.aboutMyself
                    self.profname.text = currentData.name
                    if(currentData.avatar != nil){
                        self.ProfilePhoto.kf.setImage(with: URL(string: currentData.avatar!))
                            
                    }
                    self.currentId = currentData.userId!
        
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
        
    }
    
    func findNewUser(profiledata : [ProfileInfo]) -> ProfileInfo{
        for User in profiledata{
            if((IsUserNew(userid: User.userId!) == true &&  User.name != nil && User.name != "")) {
                return User
            }
        }
        
        return UserFree
    }
    
    func  IsUserNew(userid : String) -> Bool{
        for User in massivOfUsers {
            if(userid == User.userId) {
                return false
            }
        }
        let currentUser : UserID  = .init(userId: userid)
        massivOfUsers.append(currentUser)
        return true
    }
    
    @IBAction func ItisAMatch(_ sender: Any) {
        
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/user/" + currentId + "/like", method: .post, parameters: [
            "userId" : self.currentId
        ],
        encoding: JSONEncoding.default, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
                if(response.response?.statusCode == 200){
                    
                    let decoder = JSONDecoder()
                    let cur = try! decoder.decode(Isliked.self, from: data)
                    
                    if(cur.isMutual == true){
                        
                        let vc = MatchViewController()
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.modalTransitionStyle = .crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                else{
                    
                    var dialogMessage = UIAlertController(title: "Confirm", message: String(response.response!.statusCode), preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                     })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)
                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
        
        
        let currentData : ProfileInfo = self.findNewUser(profiledata: self.profiledata)
        self.aboutMyself.text = currentData.aboutMyself
        self.profname.text = currentData.name
        if(currentData.avatar != nil){
            self.ProfilePhoto.kf.setImage(with: URL(string: currentData.avatar!))
                
        }
        self.currentId = currentData.userId!
        
        
        
        
       
        
    }
    
    @IBAction func DeclineMath(_ sender: Any) {
        
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/user/" + currentId + "/dislike", method: .post, parameters: [
            "userId" : self.currentId
        ],
        encoding: JSONEncoding.default, headers: ["Authorization": "Bearer " + UserSettings.api_token] ).responseData { response in
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
                if(response.response?.statusCode == 200){
                    print("Only black big guy please")
                }
                else{
                    
                    var dialogMessage = UIAlertController(title: "Confirm", message: String(response.response!.statusCode), preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                     })
                    
                    //Add OK button to a dialog message
                    dialogMessage.addAction(ok)
                    // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
        
        
        let currentData : ProfileInfo = self.findNewUser(profiledata: self.profiledata)
        self.aboutMyself.text = currentData.aboutMyself
        self.profname.text = currentData.name
        if(currentData.avatar != nil){
            self.ProfilePhoto.kf.setImage(with: URL(string: currentData.avatar!))
                
        }
        self.currentId = currentData.userId!
        
        
    }
    

    

}
