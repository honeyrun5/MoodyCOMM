//
//  InsertViewController.swift
//  ServerLogin
//
//  Created by SWU Mac on 2020/06/01.
//  Copyright © 2020 SWU Mac. All rights reserved.
//

import UIKit

class InsertViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textSinger: UITextField!

    @IBOutlet var genrePicker: UIPickerView!
    @IBOutlet var textDescription: UITextView!
    @IBOutlet var imageView: UIImageView!
    

    //장르는 PickerView로 선택이 가능하게 함.
    let genreArray: [String] = ["얼터너티브", "클래식", "일렉트로닉",
    "힙합 / 랩", "J-POP", "재즈", "컨트리", "K-POP", "팝", "R&B", "록"]
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // delegate 연결
        textField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreArray[row]
    }
    
   
    @IBAction func saveFavorite(_ sender: UIBarButtonItem) {
        
        let title = textTitle.text!
        let singer = textSinger.text!
        let description = textDescription.text!
        let genre = genreArray[self.genrePicker.selectedRow(inComponent: 0)]
        if (title == "") {
            let alert = UIAlertController(title: "노래 제목을 입력하세요",
            message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)
            } ) )
            self.present(alert, animated: true)
            return
        }
        
        
        let myImage = imageView.image!
        
        let myUrl = URL(string:  "http://condi.swu.ac.kr/student/T08/recommend/upload.php");
        var request = URLRequest(url:myUrl!); request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let imageData = myImage.jpegData(compressionQuality:1) else { return }
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        
        body.append(imageData)
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        request.httpBody = body
        
        var imageFileName: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else { print("Error: calling POST"); return; }
        guard let receivedData = responseData else {
        print("Error: not receiving Data")
        return; }
        if let utf8Data = String(data: receivedData, encoding: .utf8) {
            // 서버에 저장한 이미지 파일 이름
            imageFileName = utf8Data
            print(imageFileName)
            semaphore.signal()
        } }
        task.resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        
        //필요한 정보를 rest형식으로 전달
        let urlString: String = "http://condi.swu.ac.kr/student/T08/recommend/insertRecommend.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let name = appDelegate.userName else { return }
        guard let userID = appDelegate.ID else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myDate = formatter.string(from: Date())
        var restString: String = "username=" + name + "&title=" + title
        restString += "&singer=" + singer + "&genre=" + genre
        restString += "&description=" + description
        restString += "&image=" + imageFileName + "&date=" + myDate + "&id=" + userID
         request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else { return }
        guard let receivedData = responseData else { return }
        if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
       }
       task2.resume()
       _ = self.navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func selectPicture(_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
        }
    
    // 앨범에서 이미지 선택을 위한 함수
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
    self.imageView.image = image
    }
    self.dismiss(animated: true, completion: nil) }

    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) { self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
