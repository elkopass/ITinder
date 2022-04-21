//
//  AboutMySelf.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit
import Alamofire
import Kingfisher


struct ProfileInfo: Codable {
    var userId : String? = ""
    var name : String? = ""
    var aboutMyself : String? = ""
    var avatar : String? = ""
    var topics : [Tag]? = []
}

struct Tag : Codable {
    var id : String = ""
    var title : String = ""
}
class AboutMySelf: UIViewController, UIImagePickerControllerDelegate, TagListViewDelegate, UINavigationControllerDelegate {
    
    let defaultImage : UIImage = #imageLiteral(resourceName: "ProfileVector")
    var tags : [String] = []
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var TVAbout: UITextView!
    @IBOutlet weak var TFName: UITextField!
    @IBOutlet weak var ChoosePhotoButton: UIButton!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var ProfilePhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
       
        LoadProfileData()
        
        ProfilePhoto.contentMode = .scaleAspectFill
        tagList.delegate = self
        TFName.layer.cornerRadius = 28
        textView.layer.cornerRadius = 28
        
        
        TVAbout.textColor = UIColor.black
        imagePicker.delegate = self
        ProfilePhoto.image = #imageLiteral(resourceName: "AddProfilePhoto")
        if(self.ProfilePhoto.image == defaultImage){
            ChoosePhotoButton.setTitle("Выбрать фото", for: .normal)
            ChoosePhotoButton.setTitleColor(UIColor(named: "PinkColor"), for: .normal)
        }
        else{
            ChoosePhotoButton.setTitle("Удалить фото", for: .normal)
            ChoosePhotoButton.setTitleColor(UIColor(named: "PinkColor"), for: .normal)
        }
        
        tagList.tagBackgroundColor = .white
        tagList.textColor = UIColor(named: "PinkColor")!
        tagList.borderColor = UIColor(named: "PinkColor")
        tagList.textFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        tagList.borderWidth = 1
        tagList.alignment = .leading
        tagList.paddingX = 10
        tagList.paddingY = 5
        tagList.marginX = 8
        tagList.marginY = 8
        tagList.cornerRadius = 12
        LoadProfileData()
        LoadTags()
        // Do any additional setup after loading the view.
        setupTags()
    }
    override func viewWillAppear(_ animated: Bool) {
        LoadProfileData()
    }
    func LoadProfileData(){
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/profile", method: .get, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200){
                    let decoder = JSONDecoder()
                    let profiledata = try? decoder.decode(ProfileInfo.self, from: data)
                    self.TFName.text = profiledata?.name
                    self.TVAbout.text = profiledata?.aboutMyself
                    UserSettings.userId = profiledata?.userId
                    
                    if (profiledata?.avatar != nil){
                        self.ProfilePhoto.kf.setImage(with:  URL(string: profiledata!.avatar!))
                    }
                    
                    print(String(data: data, encoding: .utf8))
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true

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
    
    func LoadTags(){
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/topic", method: .get, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
                if(response.response?.statusCode == 200){
                    let decoder = JSONDecoder()
                    //self.tags =  try! decoder.decode([Tag].self, from: data)
                    let tagsList = try! decoder.decode([Tag].self, from: data)
                    
                    for tag in tagsList{
                        self.tagList.addTag(tag.title)
                        
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
  
    }
    @IBAction func ChoosePhoto(_ sender: Any) {
        if(self.ProfilePhoto.image == defaultImage){
            
            load(ChoosePhotoButton)
            ChoosePhotoButton.setTitle("Удалить фото", for: .normal)
            ChoosePhotoButton.setTitleColor(UIColor(named: "PinkColor"), for: .normal)
            
            
        }
        else{
            ChoosePhotoButton.setTitle("Выбрать фото", for: .normal)
            ChoosePhotoButton.setTitleColor(UIColor(named: "PinkColor"), for: .normal)
            self.ProfilePhoto.image = defaultImage
            AF.upload(multipartFormData: { formData in
                formData.append(self.ProfilePhoto.image?.jpegData(compressionQuality: 0.1) ?? Data(), withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            }, to: "http://193.38.50.175/itindr/api/mobile/v1/profile/avatar", headers:  ["Authorization": "Bearer " + UserSettings.api_token]).responseData {
                response in
                switch response.result {
                case .success(let data):
                    print(String(data: data, encoding: .utf8))
                    print("hear")
                    if(response.response?.statusCode == 204){
                       print ("ŸESS")
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
        
    }
    
    @objc func load(_ sender: UIButton) {
        let alert = UIAlertController(title: "Image", message: nil, preferredStyle: .actionSheet)
        
        let actionPhoto = UIAlertAction(title: "Photo library", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    private func setupTags(){
        
        
        
        self.tagList.alignment = .leading
        self.tagList.textFont = UIFont.systemFont(ofSize: 24)
        self.tagList.minWidth = 57
       
        
        
        self.tagList.marginX = 8
        self.tagList.marginY = 8
        self.tagList.paddingX = 8
        self.tagList.paddingY = 3
        for tag in self.tagList.tagViews {
            tag.layer.borderWidth = 1
            tag.backgroundColor = UIColor.systemPink
            tag.borderColor = UIColor.blue
            tag.textColor = UIColor.black
        }
       
        
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if(tagView.isSelected){
            tagView.tagBackgroundColor = UIColor(named: "PinkColor")!
            tagView.textColor = UIColor.white
            tagView.paddingX = 0
            tagView.paddingY = 0
        }
        else{
            tagView.tagBackgroundColor = UIColor.white
            tagView.textColor = UIColor(named: "PinkColor")!
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            ProfilePhoto.image = pickedImage
            ProfilePhoto.contentMode = .scaleAspectFill
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func moveToTabBar(_ sender: Any) {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        AF.request("http://193.38.50.175/itindr/api/mobile/v1/profile", method: .patch, parameters: [
            "name": TFName.text!,
            "aboutMyself" : TVAbout.text!
        ],
        encoding: JSONEncoding.default, headers: ["Authorization": "Bearer " + UserSettings.api_token]).responseData { response in
            switch response.result {
            case .success(let data):
            
                if(response.response?.statusCode == 200){
                   print(String(data: data, encoding: .utf8))
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
        
        AF.upload(multipartFormData: { formData in
            formData.append(self.ProfilePhoto.image?.jpegData(compressionQuality: 0.1) ?? Data(), withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
        }, to: "http://193.38.50.175/itindr/api/mobile/v1/profile/avatar", headers:  ["Authorization": "Bearer " + UserSettings.api_token]).responseData {
            response in
            switch response.result {
            case .success(let data):
                print(String(data: data, encoding: .utf8))
                print("hear")
                if(response.response?.statusCode == 204){
                   print ("ŸESS")
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

        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        let nextVC = UITabBarController()

        nextVC.self.tabBar.backgroundColor = .white
        nextVC.self.tabBar.tintColor = UIColor(named: "PinkColor")

        let vc1 = Flow()
        let vc2 = Peolple()
        let vc3 = Chat()
        let vc4 = Profile()
        vc1.title = "Поток"
        vc2.title = "Люди"
        vc3.title = "Чат"
        vc4.title = "Профиль"
        vc4.navigationController?.title = "Профиль"

        vc1.tabBarItem.image = #imageLiteral(resourceName: "FlowIcon")
        vc2.tabBarItem.image = #imageLiteral(resourceName: "PeopleIcon")
        vc3.tabBarItem.image = #imageLiteral(resourceName: "ChatIcon")
        vc4.tabBarItem.image = #imageLiteral(resourceName: "ProfileVector")
        nextVC.setViewControllers([vc1,vc2,vc3,vc4], animated: false)
        navigationController?.pushViewController(nextVC, animated: true)
//        
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
extension AboutMySelf: UITextViewDelegate {
    
    func textViewEditing(_ textView: UITextView){
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textDidEnd(_ textView: UITextView){
        guard textView.text.isEmpty else {
            return
        }
        textView.textColor = UIColor.lightGray
        textView.text = "О себе"
    }
    
}
