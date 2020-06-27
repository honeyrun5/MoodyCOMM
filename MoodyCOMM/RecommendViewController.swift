//
//  FavoriteTableViewController.swift
//  ServerLogin
//
//  Created by SWU Mac on 2020/05/26.
//  Copyright © 2020 SWU Mac. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    //Tab bar안에 Table View가 있는 형식이므로 UIViewController에 UITableViewDataSource와 UITableViewDelegate를 할당해준다.
    
    @IBOutlet var recommendTable: UITableView!
    
    //RecommendationData타입의 배열을 선언해 데이터베이스의 내용을 가져옴
    var fetchedArray: [RecommendationData] = Array()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = []
        self.downloadDataFromServer()
    }
    func downloadDataFromServer() -> Void {
        
        let urlString: String = "http://condi.swu.ac.kr/student/T08/recommend/recommendTable.php"
        
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
        guard let receivedData = responseData else {
        print("Error: not receiving Data"); return; }
        let response = response as! HTTPURLResponse
        if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
                options:.allowFragments) as? [[String: Any]] {
                    //데이터베이스에서 정보 받아오기
                for i in 0...jsonData.count-1 {
                        var newData: RecommendationData = RecommendationData()
                        var jsonElement = jsonData[i]
                        newData.listno = jsonElement["listNO"] as! String
                        newData.username = jsonElement["userName"] as! String
                        newData.songtitle = jsonElement["songTitle"] as! String
                        newData.singer = jsonElement["singer"] as! String
                        newData.genre = jsonElement["genre"] as! String
                        newData.descript = jsonElement["description"] as! String
                        newData.imagename = jsonElement["imageName"] as! String
                        newData.date = jsonElement["date"] as! String
                        newData.id = jsonElement["id"] as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.recommendTable.reloadData()
                    }
                }
                
        } catch { print("Error: Catch") } }
        task.resume() }
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
   
    

    // MARK: - Table view data source
    
    //UITableViewController가 아니므로 override하지 않고 함수를 그냥 쓴다.

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recommendTable.dequeueReusableCell(withIdentifier: "Recommend Cell", for: indexPath)

        // Configure the cell...
        let item = fetchedArray[indexPath.row]
        cell.textLabel?.text = item.songtitle
        cell.detailTextLabel?.text = item.genre

        return cell
    }
    

 
    // MARK: - Navigation

    //테이블 뷰에서 선택한 항목을 넘겨주고 뷰의 제목을 노래 제목으로 설정한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toDetailView" {
        if let destination = segue.destination as? DetailViewController {
        if let selectedIndex = self.recommendTable.indexPathsForSelectedRows?.first?.row { let data = fetchedArray[selectedIndex]
        destination.selectedData = data
        destination.title = data.songtitle
        } }
        }
    }
    

}
