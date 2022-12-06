//
//  HttpHelpDesk.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 22/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpHelpDesk: HttpBase {
    /**
     Permite registrar un ticket en el servidor sin envío de imágenes.
     - Parameter paciente: Corresonde a un diccionario con la información del ticket. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func registrarHelpDeskSinImagenes (helpDesk: Dictionary<String, Any>) -> Result<Any> {
        let url = "api/v1/managements.json";
        let headers = [
            "imei": Constantes.UDID
        ];
        let parametros: [String : Any] = [
            "help_desk": helpDesk,
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto paciente debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(parametros), headers: headers);
        return request;
    }
    
    /**
    Permite registrar la información de mesa de ayuda en el servidor (Con imágenes adjuntas).
    - Parameter helpDesk: Corresonde a un diccionario con la información de la mesa de ayuda. Es de tipo [String, String].
    - Parameter imagenes: Corresponde al arreglo de imágenes que se desea enviar.
    - Returns: Devuelve un objeto de tipo SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien haga el llamado debe evaluar la respuesta.
    */
    func registrarHelpDeskConImagenes (helpDesk: Dictionary<String, String>, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        let url = "api/v1/managements.json";
        let headers = [
            "imei" : Constantes.UDID,
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ];
        let adicionales = [
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // El objeto helpDesk debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametrosConImagenes(url: url, parametrosArray: helpDesk, nombreParametrosArray: "help_desk", adicionales: adicionales, headers: headers, imagenes: imagenes);
        return request;
    }
    
    /**
     Permite obtener toda la información asociada a Tickets de un cliente.
     - Returns: Devuelve un objeto Result. Si .success entonces contiene la DATA, y si .failded entonces contiene el ERROR
     */
    func obtenerTodoTickets () -> Result<Any> {
        let url = "api/v1/managements.json";
        let parametros = [
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        let headers = [
            "imei": Constantes.UDID
        ];
        let request = super.realizarPeticionGetConParametros(url: url, parametros: parametros, headers: headers);
        return request;
    }
}
