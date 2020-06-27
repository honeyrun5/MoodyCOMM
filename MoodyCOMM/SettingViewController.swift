//
//  SettingViewController.swift
//  MoodyCOMM
//
//  Created by SWU Mac on 2020/06/26.
//  Copyright © 2020 SWU Mac. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    
    @IBOutlet var userID: UILabel!
    @IBOutlet var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //사용자 정보 표시
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.userID.text = appDelegate.ID
        self.userName.text = appDelegate.userName

    }
    
    
    @IBAction func LogoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString: String = "http://condi.swu.ac.kr/student/T08/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else { return } }
        task.resume()
            
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
             loginView.modalPresentationStyle = .fullScreen
         self.present(loginView, animated: true, completion: nil)
            }))
            
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
  

}
