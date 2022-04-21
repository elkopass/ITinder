//
//  StartScreen.swift
//  ITinder
//
//  Created by Тимофей Веретнов on 08.10.2021.
//

import UIKit

class StartScreen: UIViewController {
    
    
    @IBOutlet weak var but: GradientView!
    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
             // Do any additional setup after loading the view.
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(false)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }

    @IBAction func MoveToSignUp(_ sender: Any) {
        let NextVC = SignUp()
        navigationController?.pushViewController(NextVC, animated: true)
    }
    
    
    @IBAction func MoveToSignIn(_ sender: Any) {
        let NextVC = SignIn()
        navigationController?.pushViewController(NextVC, animated: true)
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
