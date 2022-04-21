//
//  SignUp.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit
import Alamofire
class SignUp: UIViewController {

    @IBOutlet weak var email: DSTextField!
    @IBOutlet weak var password: DSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func MoveToAboutMySelfScreen(_ sender: Any) {
        let eem : String? = email.text
        let pass : String? = password.text
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/auth/register", method: .post, parameters: [
            "email": eem,
            "password" : pass
        ],
        encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200){
                    
                    let decoder = JSONDecoder()
                    let tokens = try? decoder.decode(TokenResponse.self, from: data)
                    UserSettings.api_token = tokens?.accessToken
                    UserSettings.ref_token = tokens?.refreshToken
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
        let NextVC = AboutMySelf()
        navigationController?.pushViewController(NextVC, animated: true)
    }
    
    
    @IBAction func MoveBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
