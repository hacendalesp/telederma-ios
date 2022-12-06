//
//  HttpBase.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

class HttpBase: NSObject {
    
    /**
     El método permite realizar peticiones para obtener datos, que no involucra el envío de parámetros adicionales.
     - Parameter url: Corresponde a una cadena con la dirección electrónica del recurso final.
     - Returns: Devuelve una respuesta de tipo Result con la DATA en caso de éxito y con el ERROR cuando falla.
     */
    func realizarPeticionGetSinParametros(url: String) -> Result<Any> {
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: Result<Any>!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.request(url_final, method: .get, parameters: nil, encoding: URLEncoding.default)
            .responseSwiftyJSON { dataResponse in
                
                if let data = dataResponse.value {
                    resultado = .success(data);
                } else {
                    resultado = .failure(dataResponse.error!);
                }
                
                semaforo.signal();
        };
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     El método permite realizar peticiones para obtener datos, que sí involucra el envío de parámetros adicionales.
     - Parameter url: Corresponde a una cadena con la dirección electrónica del recurso final.
     - Returns: Devuelve una respuesta de tipo Result con la DATA en caso de éxito y con el ERROR cuando falla.
     */
    func realizarPeticionGetConParametros(url: String, parametros: Parameters, headers: Dictionary<String, String>) -> Result<Any> {
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: Result<Any>!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.request(url_final, method: .get, parameters: parametros, encoding: URLEncoding.default, headers: headers)
            .responseSwiftyJSON { dataResponse in
                
                if let data = dataResponse.value {
                    resultado = .success(data);
                } else {
                    resultado = .failure(dataResponse.error!);
                }
                
                semaforo.signal();
        };
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     Permite realizar una petición POST con parámetros y cabeceras opcionales.
     - Parameter url: Corresponde a la parte de la url que apunta al servicio específico. Debe ser String.
     - Parameter parametros: Corresponde al conjunto de parámetros que se enviarán (Opcional). Debe ser Parameter
     - Parameter headers: Corresponde al conjunto de cabeceras que acompañan la petición (Opcional). Debe ser Dictionary<String, Any>
     - Returns: Devuelve un objecto Result<Any> de Alamofire.
     */
    func realizarPeticionPostConParametros (url: String, parametros: Parameters?, headers: Dictionary<String, String>?) -> Result<Any> {
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: Result<Any>!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.request(url_final, method: .post, parameters: parametros, encoding: URLEncoding.default, headers: headers).responseSwiftyJSON { dataResponse in
            
            // Se evalúa la respuesta y se asigna al resultado.
            if let data = dataResponse.value {
                resultado = .success(data);
            } else {
                resultado = .failure(dataResponse.error!);
            }
            semaforo.signal();
        };
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     Permite realizar una petición POST con parámetros, imágenes y cabeceras opcionales.
     - Parameter url: Corresponde a la parte de la url que apunta al servicio específico. Debe ser String.
     - Parameter parametros: Corresponde al conjunto de parámetros que se enviarán (Opcional). Debe ser Parameter
     - Parameter headers: Corresponde al conjunto de cabeceras que acompañan la petición (Opcional). Debe ser Dictionary<String, Any>
     - Returns: Devuelve un objecto Result<Any> de Alamofire.
     */
    func realizarPeticionPostConParametrosConImagenes (url: String, parametrosArray: Dictionary<String, String>?, nombreParametrosArray: String?, adicionales: Dictionary<String, String>?, headers: Dictionary<String, String>?, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: SessionManager.MultipartFormDataEncodingResult!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Se añaden las imágenes com parámetros para el envío.
            if (imagenes.count > 0) {
                for (nombre, imagen) in imagenes {
                    multipartFormData.append(imagen.pngData()!, withName: "\(nombreParametrosArray!)[\(nombre)]", fileName: "\(nombre).png", mimeType: "image/png");
                }
            }
            
            if(parametrosArray != nil) {
                for (llave, _) in parametrosArray! {
                    multipartFormData.append((parametrosArray![llave]!.data(using: .utf8))!, withName: "\(nombreParametrosArray!)[\(llave)]");
                }
            }
            
            if(adicionales != nil) {
                for (llave, valor) in adicionales! {
                    multipartFormData.append(valor.data(using: .utf8)!, withName: llave);
                }
            }
        }, usingThreshold:UInt64.init(),
           to: url_final,
           method: .post,
           headers: headers,
           encodingCompletion: { (result) in
            
            resultado = result;
            semaforo.signal();
        });
        
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     Permite realizar una petición PUT con parámetros y cabeceras opcionales.
     - Parameter url: Corresponde a la parte de la url que apunta al servicio específico. Debe ser String.
     - Parameter parametros: Corresponde al conjunto de parámetros que se enviarán (Opcional). Debe ser Parameter
     - Parameter headers: Corresponde al conjunto de cabeceras que acompañan la petición (Opcional). Debe ser Dictionary<String, Any>
     - Returns: Devuelve un objecto Result<Any> de Alamofire.
     */
    func realizarPeticionPutConParametros (url: String, parametros: Parameters?, headers: Dictionary<String, String>?) -> Result<Any> {
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: Result<Any>!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.request(url_final, method: .put, parameters: parametros, encoding: URLEncoding.default, headers: headers).responseSwiftyJSON { dataResponse in
            
            // Se evalúa la respuesta y se asigna al resultado.
            if let data = dataResponse.value {
                resultado = .success(data);
            } else {
                resultado = .failure(dataResponse.error!);
            }
            semaforo.signal();
        };
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     Permite realizar una petición PUT con parámetros e imágenes y cabeceras opcionales.
     - Parameter url: Corresponde a la parte de la url que apunta al servicio específico. Debe ser String.
     - Parameter parametros: Corresponde al conjunto de parámetros que se enviarán (Opcional). Debe ser Parameter
     - Parameter headers: Corresponde al conjunto de cabeceras que acompañan la petición (Opcional). Debe ser Dictionary<String, Any>
     - Returns: Devuelve un objecto Result<Any> de Alamofire.
     */
    func realizarPeticionPutConParametrosConImagenes (url: String, parametrosArray: Dictionary<String, String>?, nombreParametrosArray: String?, adicionales: Dictionary<String, String>?, headers: Dictionary<String, String>?, imagenes: [String: UIImage]) -> SessionManager.MultipartFormDataEncodingResult {
        
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: SessionManager.MultipartFormDataEncodingResult!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Se añaden las imágenes com parámetros para el envío.
            for (nombre, imagen) in imagenes {
                multipartFormData.append(imagen.pngData()!, withName: "\(nombreParametrosArray!)[\(nombre)]", fileName: "\(nombre).png", mimeType: "image/png");
            }
            
            if(parametrosArray != nil) {                
                for (llave, _) in parametrosArray! {
                    multipartFormData.append((parametrosArray![llave]!.data(using: .utf8))!, withName: "\(nombreParametrosArray!)[\(llave)]");
                }
            }
            
            if(adicionales != nil) {
                for (llave, valor) in adicionales! {
                    multipartFormData.append(valor.data(using: .utf8)!, withName: llave);
                }
            }
        }, usingThreshold:UInt64.init(),
           to: url_final,
           method: .put,
           headers: headers,
           encodingCompletion: { (result) in                    
            
            resultado = result;
            semaforo.signal();
        });
        
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     Permite realizar una petición POST con parámetros, archivos y cabeceras opcionales.
     - Parameter url: Corresponde a la parte de la url que apunta al servicio específico. Debe ser String.
     - Parameter parametros: Corresponde al conjunto de parámetros que se enviarán (Opcional). Debe ser Parameter
     - Parameter headers: Corresponde al conjunto de cabeceras que acompañan la petición (Opcional). Debe ser Dictionary<String, Any>
     - Returns: Devuelve un objecto Result<Any> de Alamofire.
     */
    func realizarPeticionPostConParametrosConAdjuntos (url: String, parametrosArray: Dictionary<String, String>?, nombreParametrosArray: String?, adicionales: Dictionary<String, String>?, headers: Dictionary<String, String>?, adjuntos: [Adjunto]) -> SessionManager.MultipartFormDataEncodingResult {
        
        // Comprobamos el estado y validéz de nuestra URL
        guard let url_final = URL(string: String(Constantes.URL_BASE + url)) else {
            // Se retorna un fallo de URL si por alguna razón no es una URL válida.
            return .failure(NetworkError.url);
        }
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: SessionManager.MultipartFormDataEncodingResult!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Se añaden las imágenes com parámetros para el envío.
            if (adjuntos.count > 0) {
                for adjunto in adjuntos {
                    multipartFormData.append(adjunto.archivo, withName: "\(nombreParametrosArray!)[\(String(describing: adjunto.nombre))]", fileName: "\(String(describing: adjunto.nombre)).\(String(describing: adjunto.tipoExtension))", mimeType: adjunto.tipoMime);
                }
            }
            
            if(parametrosArray != nil) {
                for (llave, _) in parametrosArray! {
                    multipartFormData.append((parametrosArray![llave]!.data(using: .utf8))!, withName: "\(nombreParametrosArray!)[\(llave)]");
                }
            }
            
            if(adicionales != nil) {
                for (llave, valor) in adicionales! {
                    multipartFormData.append(valor.data(using: .utf8)!, withName: llave);
                }
            }
        }, usingThreshold:UInt64.init(),
           to: url_final,
           method: .post,
           headers: headers,
           encodingCompletion: { (result) in
            
            resultado = result;
            semaforo.signal();
        });
        
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    
}
