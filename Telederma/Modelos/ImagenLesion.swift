//
//  ImagenLesion.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class ImagenLesion: ModeloBase {
    var id_injury_local: Int?;
    var photo: String?;
    var edited_photo: String?;
    var descriptions: String?;
    var injury_id: Int?;
    var medical_control_id: Int?;
    var photoFile: UIImage?;
    var image_injury_id: String?;
    var id_local: Int!;
    var local_medical_control_id: Int?;
    var sincronizado: Bool!;
    
    override init() {
        self.id_injury_local = nil;
        self.photo = nil;
        self.edited_photo = nil;
        self.descriptions = nil;
        self.injury_id = nil;
        self.medical_control_id = nil;
        self.photoFile = nil;
        self.image_injury_id = nil;
        self.id_local = Int();
        self.local_medical_control_id = nil;
        self.sincronizado = false;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.id_injury_local <- map["id_injury_local"];
        self.photo <- map["photo"];
        self.edited_photo <- map["edited_photo"];
        self.descriptions <- map["description"];
        self.injury_id <- map["injury_id"];
        self.medical_control_id <- map["medical_control_id"];
        self.image_injury_id <- map["image_injury_id"];
        super.mapping(map: map);
    }
}
