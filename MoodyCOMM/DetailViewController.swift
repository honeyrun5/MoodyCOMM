//
//  DetailViewController.swift
//  ServerLogin
//
//  Created by SWU Mac on 2020/06/09.
//  Copyright © 2020 SWU Mac. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    

    @IBOutlet var textUserName: UILabel!
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textDate: UILabel!
    @IBOutlet var textSinger: UILabel!
    @IBOutlet var textGenre: UILabel!
    @IBOutlet var textDescription: UILabel!
    @IBOutlet var imageView: UIImageView!
   
    @IBOutlet var deleteBtn: UIButton!
    
   
    
    // 상위 View에서 자료를 넘겨 받기 위한 변수
    var selectedData: RecommendationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let recommendData = selectedData else { return }
        textTitle.text = recommendData.songtitle
        textUserName.text = recommendData.username
        textDate.text = recommendData.date
        textSinger.text = recommendData.singer
        textGenre.text = recommendData.genre
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               guard let userID = appDelegate.ID else { return }
               
        //가져온 자료를 작성한 사람의 id와 로그인 한 유저의 id가 다르면 삭제 기능을 숨긴다.
        if userID != recommendData.id {
            deleteBtn.isHidden = true
        }
        
        textDescription.numberOfLines = 0
        textDescription.text = recommendData.descript
        var imageName = recommendData.imagename
        
        //업로드 된 이미지 불러오기
        if (imageName != "") {
        let urlString = "http://condi.swu.ac.kr/student/T08/recommend/"
            imageName = urlString + imageName
        let url = URL(string: imageName)!
        if let imageData = try? Data(contentsOf: url) {
            imageView.image = UIImage(data: imageData)
            
        } }
        
    }
    

    func getContext () -> NSManagedObjectContext {
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func saveFavorite(_ sender: UIBarButtonItem) {
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context)
        // Core Data에 Favorite record를 새로 생성함
        let favObject = NSManagedObject(entity: entity!, insertInto: context)
        favObject.setValue(textUserName.text, forKey: "userName")
        favObject.setValue(textTitle.text, forKey: "songTitle")
        favObject.setValue(textSinger.text, forKey: "singer")
        favObject.setValue(textGenre.text, forKey: "genre")
        favObject.setValue(textDescription.text, forKey: "descript")
        favObject.setValue(Date(), forKey: "date")
        
        do {
            try context.save()
            print("saved!")
            
        }
        catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)") }
        
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonDelete() {
        
        let alert=UIAlertController(title:"정말 삭제 하시겠습니까?", message: "",preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
        let urlString: String = "http://condi.swu.ac.kr/student/T08/recommend/deleteRecommend.php"
            guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        guard let listNO = self.selectedData?.listno else { return }
            let restString: String = "listno=" + listNO
            request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { return }
        guard let receivedData = responseData else { return }
        if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task.resume()
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

}
