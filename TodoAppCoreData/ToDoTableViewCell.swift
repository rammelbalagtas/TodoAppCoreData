//
//  ToDoTableViewCell.swift
//  TodoAppCoreData
//
//  Created by Rammel on 2022-03-11.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
