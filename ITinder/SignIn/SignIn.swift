//
//  SignIn.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit
import Alamofire

struct  TokenResponse: Codable{
    let  accessToken: String
    let  accessTokenExpiredAt: String
    let  refreshToken: String
    let  refreshTokenExpiredAt: String
}
class SignIn: UIViewController {

    @IBOutlet weak var password: DSTextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var email: DSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func MoveToAboutMySelfScreen(_ sender: Any) {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let NextVC = AboutMySelf()
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/auth/login", method: .post, parameters: [
        "email": email.text,
        "password" : password.text
        ],
        encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .success(let data):
            
                if(response.response?.statusCode == 200){
                    
                    let decoder = JSONDecoder()
                    let tokens = try? decoder.decode(TokenResponse.self, from: data)
                    UserSettings.api_token = tokens?.accessToken
                    UserSettings.ref_token = tokens?.refreshToken
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.pushViewController(NextVC, animated: true)
                    print("je")
                    
                    
                }
                else{
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
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
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                var dialogMessage = UIAlertController(title: "Confirm", message: error.errorDescription, preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
            }
        }
        
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
