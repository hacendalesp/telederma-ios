//
//  ImagenAnexo.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 19/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ImagenAnexo: ModeloBase {
    var consultation_control_local: String?;
    var consultation_id_local: String?;
    var annex_url: String?;
    var consultation_id: String?;
    var consultation_control_id: String?;
    var local_id: Int!;
    var sincronizado: Bool!;
    
    override init() {
        self.consultation_control_local = nil;
        self.consultation_id_local = nil;
        self.annex_url = nil;
        self.consultation_id = nil;
        self.consultation_control_id = nil;
        self.local_id = Int();
        self.sincronizado = false;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.consultation_control_local <- map["consultation_control_local"];
        self.consultation_id_local <- map["consultation_id_local"];
        self.annex_url <- map["annex_url"];
        self.consultation_id <- map["consultation_id"];
        self.consultation_control_id <- map["consultation_control_id"];
        super.mapping(map: map);
    }
}
