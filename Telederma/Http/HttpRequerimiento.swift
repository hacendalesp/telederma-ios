//
//  HttpRequerimiento.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/09/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpRequerimiento: HttpBase {
    
    /**
     Permite actualizar la información del perfil de un usuario en el servidor.
     - Parameter usuario: Corresonde a un diccionario con la información del usuario. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func descartarRequerimiento (adicionales: [String: Any]?) -> Result<Any> {
        let url = "api/v1/consultations/reject_request.json";
        var parametros = Parameters();
        
        if(adicionales != nil) {
            for (llave, valor) in adicionales! {
                parametros[llave] = valor;
            }
        }
        
        parametros["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String;
        parametros["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String;
        
        print(parametros);
        
        // El objeto debe ser pasado a tipo Parameter en la petición PUT.
        let request = super.realizarPeticionPutConParametros(url: url, parametros: parametros, headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
    
    /**
     Permite actualizar la información del perfil de un usuario en el servidor.
     - Parameter usuario: Corresonde a un diccionario con la información del usuario. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func resolverRequerimiento (adicionales: [String: Any]?) -> Result<Any> {
        let url = "api/v1/consultations/response_request.json";
        var parametros = Parameters();
        
        if(adicionales != nil) {
            for (llave, valor) in adicionales! {
                parametros[llave] = valor;
            }
        }
        
        parametros["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String;
        parametros["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String;
        
        print(parametros);
        
        // El objeto debe ser pasado a tipo Parameter en la petición PUT.
        let request = super.realizarPeticionPutConParametros(url: url, parametros: parametros, headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
}
