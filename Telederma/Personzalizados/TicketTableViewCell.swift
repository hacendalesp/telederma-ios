//
//  TicketTableViewCell.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 25/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTicket: UILabel!
    @IBOutlet weak var lblAsunto: UILabel!
    @IBOutlet weak var imgEstado: UIImageView!
    @IBOutlet weak var lblEstado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
