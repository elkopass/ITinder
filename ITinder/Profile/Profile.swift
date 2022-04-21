//
//  Profile.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 25.10.2021.
//

import UIKit
import Alamofire
import  Kingfisher
class Profile: UIViewController {

    @IBOutlet weak var aboutMyself: UILabel!
    @IBOutlet weak var namefield: UILabel!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var profPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        profPhoto.layer.cornerRadius = 103
       
        // Do any additional setup after loading the view.
        tagList.tagBackgroundColor = .white
        tagList.textColor = UIColor(named: "PinkColor")!
        tagList.borderColor = UIColor(named: "PinkColor")
        
        tagList.borderWidth = 1
        tagList.alignment = .leading
        tagList.paddingX = 10
        tagList.paddingY = 5
        tagList.marginX = 8
        tagList.marginY = 8
        tagList.cornerRadius = 12
        LoadProfileData()
    }

    @IBAction func MoveToAboutMySelf(_ sender: Any) {
        let NextVC = AboutMySelf()
        navigationController?.pushViewController(NextVC, animated: true)
    }
    
    func LoadProfileData(){
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/profile", method: .get, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200){
                    
                    let decoder = JSONDecoder()
                    let profiledata = try? decoder.decode(ProfileInfo.self, from: data)
                    self.namefield.text = profiledata?.name
                    self.aboutMyself.text = profiledata?.aboutMyself
                    UserSettings.userId = profiledata?.userId
                    
                    if (profiledata?.avatar != nil){
                        self.profPhoto.kf.setImage(with:  URL(string: profiledata!.avatar!))
                    }
                    if(profiledata!.topics != nil){
                        let massivOfTopic :[Tag] = profiledata!.topics!
                        for tag in massivOfTopic{
                            let tmp : String = tag.title
                            self.tagList.addTag(tmp)
                        }
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
                            var dialogMessage = UIAlertController(title: "Confirm", message: String(response.response!.statusCode), preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                print("Ok button tapped")
                             })
                            
                            //Add OK button to a dialog message
                            dialogMessage.addAction(ok)
                            // Present Alert to
                            self.present(dialogMessage, animated: true, completion: nil)
                        case .failure(let error):
                            print(error.errorDescription)
                        }
                    }
                }
                var dialogMessage = UIAlertController(title: "Confirm", message: String(response.response!.statusCode), preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
