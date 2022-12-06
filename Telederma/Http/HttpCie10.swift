//
//  HttpCIE10.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpCie10: HttpBase {
    
    /**
     Permite obtener toda la información asociada a CIE10.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerTodoCie10 () -> Result<Any> {
        let url = "api/v1/static_resources/diseases";
        let request = super.realizarPeticionGetSinParametros(url: url);
        return request;
    }
    
}
