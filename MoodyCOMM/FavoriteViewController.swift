//
//  FavoriteViewController.swift
//  MoodyCOMM
//
//  Created by SWU Mac on 2020/06/20.
//  Copyright © 2020 SWU Mac. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favorites: [NSManagedObject] = []
    
    @IBOutlet var favoriteTable: UITableView!
    
   func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // View가 보여질 때 자료를 Core Data에서 가져오도록 한다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        
        let sortDescriptor = NSSortDescriptor (key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
    do {
        favorites = try context.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)") }
        self.favoriteTable.reloadData()
        
    }
    
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.favoriteTable.dequeueReusableCell(withIdentifier: "Favorite Cell", for: indexPath) as! FavoriteTableViewCell
        
        //favoriteList에 각 셀의 내용을 담아 할당해준다.
        let favoriteList = favorites[indexPath.row]

        cell.recommendUser?.text = favoriteList.value(forKey: "userName") as? String
        cell.title?.text = favoriteList.value(forKey: "songTitle") as? String
        cell.singer?.text = favoriteList.value(forKey: "singer") as? String
        cell.genre?.text = favoriteList.value(forKey: "genre") as? String
        cell.descript?.text = favoriteList.value(forKey: "descript") as? String
        cell.date?.text = favoriteList.value(forKey: "date") as? String

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "저장 목록" }
    

    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: FavoriteTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        // Core Data 내의 해당 자료 삭제
            let context = getContext()
            context.delete(favorites[indexPath.row])
            do {
            try context.save()
            print("deleted!")
            } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)") }
            // 배열에서 해당 자료 삭제
            favorites.remove(at: indexPath.row)
            // 테이블뷰 Cell 삭제
            favoriteTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
  

}
