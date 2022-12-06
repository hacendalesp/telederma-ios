//
//  HttpUsuario.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 3/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire

class HttpUsuario: HttpBase {
    
    /**
     Permite registrar un usuario en el servidor.
     - Parameter usuario: Corresonde a un diccionario con la información del usuario. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func registrarUsuario (usuario: Dictionary<String, Any>) -> Result<Any> {
        let url = "api/v1/sessions/register.json";
        // El objeto usuario debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(dictionaryLiteral: ("user", usuario)), headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
    
    /**
    Permite actualizar la información del perfil de un usuario en el servidor (Con imágenes adjuntas).
    - Parameter usuario: Corresonde a un diccionario con la información del usuario. Es de tipo [String, String].
    - Parameter imagenes: Corresponde al arreglo de imágenes que se desea enviar.
    - Returns: Devuelve un objeto de tipo SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien haga el llamado debe evaluar la respuesta.
    */
    func registrarUsuarioConImagenes (usuario: Dictionary<String, String>, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        let url = "api/v1/sessions/register.json";
        let headers = [
            "imei" : Constantes.UDID,
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ];
        
        // El objeto usuario debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametrosConImagenes(url: url, parametrosArray: usuario, nombreParametrosArray: "user", adicionales: nil, headers: headers, imagenes: imagenes);
        return request;
    }
    
    
    /**
     Permite iniciar sesión a un usuario.
     - Parameter documento: Corresponde al número del documento del usuario (String).
     - Parameter password: Corresponde a la contraseña (String).
     - Returns: Devuelve un objeto de tipo Result<Any> Alamofire.
     */
    func iniciarSesion (documento: String, password: String) -> Result<Any> {
        let url = "api/v1/sessions/login.json";
        // Los parámetros se envían sueltos según documentación.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(dictionaryLiteral: ("number_document", documento), ("password", password)), headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
    
    /**
     Permite enviar una solicitud para el restablecimiento de la contraseña.
     - Parameter documento: Corresponde al documento del usuario quien realiza la solicitud.
     - Returns: Devuelve un objeto Result <Any> Alamofire.
     */
    func restablecerPassword (documento: String) -> Result<Any> {
        let url = "api/v1/sessions/forget_password.json";
        // Se realiza la petición con un parámetro y sin cabeceras.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: .init(dictionaryLiteral: ("number_document", documento)), headers: nil);
        return request;
    }
    
    /**
     Permite actualizar la información del perfil de un usuario en el servidor.
     - Parameter usuario: Corresonde a un diccionario con la información del usuario. Es de tipo [String, Any].
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func actualizarPerfilUsuario (usuario: Dictionary<String, Any>, adicionales: [String: String]?) -> Result<Any> {
        let url = "api/v1/sessions/update.json";
        var parametros = Parameters(dictionaryLiteral: ("user", usuario));
        
        if(adicionales != nil) {
            for (llave, valor) in adicionales! {
                parametros[llave] = valor;
            }
        }
        
        // El objeto usuario debe ser pasado a tipo Parameter en la petición PUT.
        let request = super.realizarPeticionPutConParametros(url: url, parametros: parametros, headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
    
    /**
     Permite actualizar la información del perfil de un usuario en el servidor (Con imágenes adjuntas).
     - Parameter usuario: Corresonde a un diccionario con la información del usuario. Es de tipo [String, String].
     - Parameter adicionales: Corresponde a la información que se envía adicional para validar el usuario.
     - Parameter imagenes: Corresponde al arreglo de imágenes que se desea enviar.
     - Returns: Devuelve un objeto de tipo SessionManager.MultipartFormDataEncodingResult de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func actualizarPerfilUsuarioConImagenes (usuario: Dictionary<String, String>, adicionales: [String: String]?, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        let url = "api/v1/sessions/update.json";
        let headers = [
            "imei" : Constantes.UDID,
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ];
        
        // El objeto usuario debe ser pasado a tipo Parameter en la petición PUT.
        let request = super.realizarPeticionPutConParametrosConImagenes(url: url, parametrosArray: usuario, nombreParametrosArray: "user", adicionales: adicionales, headers: headers, imagenes: imagenes);
        return request;
    }
    
    /**
     Permite certificar un usuario en el servidor.
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func certificarUsuario () -> Result<Any> {
        let url = "api/v1/sessions/certificated.json";
        let parametros: [String: Any] = [
            "doctor_id": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID)!,
            "certified": true,
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL)!,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN)!
        ];
        let headers = [
            "imei" : Constantes.UDID
        ];
        
        let request = super.realizarPeticionGetConParametros(url: url, parametros: parametros, headers: headers);
        return request;
    }
}
