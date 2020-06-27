//
//  FavoriteTableViewCell.swift
//  MoodyCOMM
//
//  Created by SWU Mac on 2020/06/20.
//  Copyright © 2020 SWU Mac. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    //cell의 내용을 정의함.
    
    @IBOutlet var title: UILabel!
    @IBOutlet var singer: UILabel!
    @IBOutlet var genre: UILabel!
    @IBOutlet var recommendUser: UILabel!
    @IBOutlet var descript: UILabel!
    
    @IBOutlet var date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
