//
//  HelpDesk.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 18/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import ObjectMapper

class HelpDesk: ModeloBase {
    var ticket: String?;
    var response_ticket: String?;
    var image_admin: String?;
    var status: Int?;
    var device_id:  String?;
    var descriptions: String?;
    var subject: String?;
    var image_user: String?;
    var user_id: Int?;
    var admin_user_id: Int?;
    var id_local: Int?;
    
    override init() {
        self.ticket = nil;
        self.response_ticket = nil;
        self.image_admin = nil;
        self.status = nil;
        self.device_id = nil;
        self.descriptions = nil;
        self.subject = nil;
        self.image_user = nil;
        self.user_id = nil;
        self.admin_user_id = nil;
        self.id_local = nil;
        super.init();
    }
    
    required init?(map: Map) {
        super.init(map: map);
    }
    
    override func mapping(map: Map) {
        self.ticket <- map["ticket"];
        self.response_ticket <- map["response_ticket"];
        self.image_admin <- map["image_admin"];
        self.status <- map["status"];
        self.device_id <- map["device_id"];
        self.descriptions <- map["description"];
        self.subject <- map["subject"];
        self.image_user <- map["image_user"];
        self.user_id <- map["user_id"];
        self.admin_user_id <- map["admin_user_id"];
        super.mapping(map: map);
    }
}
