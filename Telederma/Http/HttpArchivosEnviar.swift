//
//  HttpUsuario.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 3/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HttpArchivosEnviar: HttpBase {
    
    /**
     Permite enviar imágenes de anexo o lesión de manera individual.
     Si la respuesta es positiva, actualiza la consulta o control con las url de las imágenes que se enviaron previamente.
     Se realiza de manera asíncrona y devuelve resultado a quien lo llama para obtener la url de la imagen registrada en servidor.
     */
    func registroImagenIndividual (imagen: ArchivosEnviar, grupo: String) -> SessionManager.MultipartFormDataEncodingResult {
        let url = "api/v1/injuries/individual_image.json";
        let headers = [
            "imei" : Constantes.UDID,
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ];
        
        let adicionales: [String : String] = [
            "user_email": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as! String,
            "user_token": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as! String
        ];
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: SessionManager.MultipartFormDataEncodingResult!;
        // Se declara una variable para el control de peticiones asíncronas secuenciales.
        let semaforo = DispatchSemaphore(value: 0);
        
        // Comprobamos el estado y validéz de nuestra URL
        if let url_final = URL(string: String(Constantes.URL_BASE + url)) {
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                let fileManager = FileManager.default;
                if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                    // let idConsultaControl = imagen.consultation_id != nil ? imagen.consultation_id! : imagen.consultation_control_id!;
                    // Se crea una imagen UIImage a partir de la imagen almacenada en dispositivo.
                    let rutaCompleta = tDocumentDirectory.appendingPathComponent(imagen.ruta);
                    if (fileManager.fileExists(atPath: rutaCompleta.path)){
                        if let imagen = UIImage(contentsOfFile: rutaCompleta.path) {
                            let imageBase64String = Funcionales.imagen64(imagen: imagen);
                            let nombreArchivo = (grupo == Constantes.GRUPO_ANEXO) ? "annex_url" : "photo";
                            
                            print("Base 64: \(nombreArchivo)");
                            
                            multipartFormData.append(imageBase64String.data(using: .utf8)!, withName: nombreArchivo);
                        }
                    }
                    
                    // Envío de datos adicionales
                    for (llave, valor) in adicionales {
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
        }
        
        _ = semaforo.wait(wallTimeout: .distantFuture);
        return resultado;
    }
    
    /**
     Permite actualizar la información de anexos de un control o consulta en el servidor.
     - Parameter idControlConsulta: Corresponde a un número entero que representa la llave de la consulta o control al cual se asocian los anexos.
     - Parameter anexos: Corresponde al arreglo que contiene las urls de las imágenes asociadas al ID de la consulta o control.
     - Parameter esConsulta: Permite saber si se están asociando a una consulta o a un control.
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func actualizarAnexoControlConsulta (idControlConsulta: Int, anexos: [String: String], esConsulta: Bool) -> Result<Any> {
        let url = "api/v1/consultations/update.json";
        var parametroControlConsulta: String!;
        
        if (!esConsulta) {
            parametroControlConsulta = "consultation_control_id";
        } else {
            parametroControlConsulta = "consultation_id";
        }
        
        var anexosFinal = [String]();
        for (_, valor) in anexos {
            anexosFinal.append(valor);
        }
        
        var parametros = Parameters(dictionaryLiteral: (parametroControlConsulta, idControlConsulta));
        parametros["images_annex"] = anexosFinal;
        /*for anexo in anexos {
         parametros["images_annex[]"] = anexo;
         }*/
        parametros["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN);
        parametros["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL);
        
        // El objeto usuario debe ser pasado a tipo Parameter en la petición PUT.
        let request = super.realizarPeticionPutConParametros(url: url, parametros: parametros, headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
    
    /**
     Permite actualizar la información de lesiones de una consulta o control en el servidor.
     - Parameter idControlConsulta: Corresponde a un número entero que representa la llave de la consulta o control al cual se asocian los anexos.
     - Parameter lesiones: Corresponde al arreglo que contiene las urls de las imágenes asociadas al ID de la consulta o control.
     - Parameter esConsulta: Permite saber si se están asociando a una consulta o a un control.
     - Returns: Devuelve un objeto de tipo Result<Any> de Alamofire. Quien haga el llamado debe evaluar la respuesta.
     */
    func crearLesionControlConsulta (idControlConsulta: Int, lesiones: [String: String], adicionales: [String: [String]], esConsulta: Bool) -> Result<Any> {
        let url = "api/v1/injuries.json";
        var parametros = Parameters();
        var imagenes = [ImagenLesion]();
        
        parametros["injury[consultation_id]"] = (esConsulta) ? idControlConsulta : nil;
        parametros["injury[consultation_control_id]"] = (esConsulta) ? nil : idControlConsulta;
        parametros["injury[body_area_id]"] = 182;
        
        for (indice, valor) in lesiones {
            let imagenLesion = ImagenLesion();
            imagenLesion.photo = valor;
            imagenLesion.image_injury_id = "";
            
            imagenes.append(imagenLesion);
            
            if (adicionales.count > 0) {
                // Se valida si la lesión tiene hijas
                if let adicionalesLesion = adicionales[indice] {
                    if (adicionalesLesion.count > 0) {
                        for adicional in adicionalesLesion {
                            let imagenLesionAdicional = ImagenLesion();
                            imagenLesionAdicional.photo = adicional;
                            imagenLesionAdicional.image_injury_id = valor;
                            imagenes.append(imagenLesionAdicional);
                        }
                    }
                }
            }
        }
        
        print("Enviadas: \(imagenes.count)");
        
        parametros["images"] = imagenes.toJSON();
        parametros["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN);
        parametros["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL);
        
        // El objeto usuario debe ser pasado a tipo Parameter en la petición POST.
        let request = super.realizarPeticionPostConParametros(url: url, parametros: parametros, headers: .init(dictionaryLiteral: ("imei", Constantes.UDID)));
        return request;
    }
}
