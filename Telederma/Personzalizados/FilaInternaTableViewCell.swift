//
//  FilaInternaTableViewCell.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class FilaInternaTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDiagnostico: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var imgEstado: UIImageView!
    @IBOutlet weak var lblNumeroControles: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
