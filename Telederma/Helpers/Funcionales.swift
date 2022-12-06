//
//  Funcionales.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 1/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import Network

class Funcionales: NSObject {
    
    static var dispositivoEstaConectado = true;
    
    /**
     Permite validar si se puede establecer una conexión.
     */
    class func estaConectado () {
        let monitor = NWPathMonitor();
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                Funcionales.dispositivoEstaConectado = true;
            } else {
                Funcionales.dispositivoEstaConectado = false;
            }
        }
        
        let queue = DispatchQueue(label: "Monitor");
        monitor.start(queue: queue);
    }
    
    /**
     Permite mostrar un mensaje básico de alerta. Usado principalmente para respuestas "inesperadas".
     - Parameter view: Corresponde al elemento VIEW desde el cual se mostrará la alerta.
     - Parameter mensaje: Corresponde a una cadena de texto con el mensaje que se desea mostrar.
     */
    class func mostrarAlerta(view: UIViewController, mensaje: String) {
        let accion = UIAlertAction.init(title: "Aceptar", style: .default, handler: nil);
        let alerta = UIAlertController.init(title: "Atención", message: mensaje, preferredStyle: .alert);
        
        alerta.addAction(accion);
        view.present(alerta, animated: true, completion: nil);
    }
    
    /**
     Permite mostrar un mensaje de alerta con el contenido de errores particulares de una consulta al servidor.
     - Parameter view: Corresponde al ViewConntroller desde el cual se hace el llamado y donde se motrará la alerta.
     - Parameter datos: Corresponde al conjunto de datos que describen los errores de tipo diccionario [String: JSON]
     */
    class func mostrarMensajeErrorCompuesto (view: UIViewController, datos: [String: JSON]) {
        var mensajeFinal = String();
        // Si contiene varios datos ...
        if(datos.count > 0) {
            mensajeFinal = Mensajes.MENSAJE_ALERTA_ERROR;
            // Se obtiene la tupla por cada dato del diccionario, para acceder al nombre del campo y al error.
            for (campo, msj) in datos {
                // Se convierte el contenido de los errores en un arreglo.
                if let mensajes = JSON(msj).array {
                    let campoDiccionario = Constantes.DICCIONARIO_CAMPOS[campo] ?? campo;
                    
                    mensajeFinal += "- El campo \(campoDiccionario): ";
                    var contadorMensajes = 0;
                    // Se recorren los errores del campo que evalúa la iteración
                    for mensaje in mensajes {
                        // Se termina de construir el mensaje a mostrar.
                        mensajeFinal += mensaje.description;
                        contadorMensajes += 1;
                        
                        if (contadorMensajes < mensajes.count){
                            mensajeFinal += ",";
                        }
                    }
                    mensajeFinal += "\n";
                }
            }
        }
        self.mostrarAlerta(view: view, mensaje: mensajeFinal);
    }
    
    /**
     Permite mostrar un mensaje cuando se trata de una única cadena de texto.
     - Parameter view: Corresponde al ViewConntroller desde el cual se hace el llamado y donde se motrará la alerta.
     - Parameter mensaje: Corresponde al texto que se desea mostrar en la alerta.
     */
    class func mostrarMensajeErrorSimple (view: UIViewController, mensaje: String) {
        var mensajeFinal = Mensajes.MENSAJE_ALERTA_ERROR;
        mensajeFinal += mensaje;
        
        self.mostrarAlerta(view: view, mensaje: mensajeFinal);
    }
    
    /**
     Permite guardar en el fichero de configuraciones un dato.
     - Parameter valor: Corresponde al valor del dato que se desea guardar.
     - Parameter llave: Corresponde al índice o llave asociada al valor.
     */
    class func guardarUserDefaults (valor: Any, llave: String) {
        Constantes.USER_DEFAULTS.set(valor, forKey: llave);
    }
    
    /**
     Permite obtener el valor asociado a una llave.
     - Parameter llave: Corresponde al índice o llave del cual se desea obtener su respectivo valor.
     - Returns: Devuelve un objeto de tipo Any Opcional.
     */
    class func obtenerUserDefaults (llave: String) -> Any? {        
        return Constantes.USER_DEFAULTS.object(forKey: llave);
    }
    
    /**
     Permite eliminar el texto para cada uno de los campos de texto.
     - Parameter campos: Corresponde al conjunto de campos de texto que se desean limpiar de información.
     */
    class func vaciarCamposTexto (campos: [UITextField]) {
        if (campos.count > 0) {
            for campo in campos {
                campo.text = "";                
            }
        }
    }
    
    /**
     Permite asignar el texto a un botón que funcione como selector, y ajustarlo.
     - Parameter boton: Corresponde al botón al cual se derealizarán los ajustes.
     - Parameter texto: Corresponde al texto que se asignará al botón.
     */
    class func ajustarTextoBotonSelector (boton: UIButton, texto: String) {
        boton.setTitle(texto, for: .normal);
        boton.titleLabel?.font = .preferredFont(forTextStyle: .subheadline);
        boton.titleLabel?.adjustsFontForContentSizeCategory = true;
    }
    
    /**
     Permite rotar una imagen los grados deseados.
     - Parameter oldImage: Corresponde a la imagen inicial que se desea rotar (UIImage).
     - Parameter grados: Corresponde al valor de la rotación en grados (CGFloat)
     - Returns: Devuelve una imagen nueva con los cambios.
     */
    class func rotarImagen (oldImage: UIImage, grados: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: grados * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (grados * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     Permite eliminar una foto base, y actualizar los índices de las listas y diccionarios asociados.
     - Parameter posicion: Corresponde a la posición de la imagen en la lista base (Int).
     */
    class func eliminarFotoYActualizar (posicion: Int) {
        
        // Se valida que exista una imagen en la posición.
        if (posicion < MemoriaRegistroConsulta.listaFotosTomadas.count) {
            
            // Corresponde a imágenes base paso 1.
            // Se valida si la foto que se elimina es escogida como principal.
            // Se valida si existen fotos principales.
            if (MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.count > 0) {
                
                // Si la foto actual existe como foto principal.
                if let _ = MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia[posicion] {
                    
                    // De ser así, se reinicias variables de clase asociadas a dermatoscopía
                    MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.removeValue(forKey: posicion);
                    
                    // Si ya no quedan imágenes dermatoscópicas, entonces se inactiva la variable de guardado.
                    if(MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia.count == 0) {
                        MemoriaRegistroConsulta.estaDermatoscopiaGuardada = false;
                    }
                    
                    MemoriaRegistroConsulta.fotoPrincipalTemporalDermatoscopia = nil;
                    
                    MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia.removeValue(forKey: posicion);
                    
                    MemoriaRegistroConsulta.estaViendoImagenesDermatoscopia = false;
                }
            }
            
            // Después se elimina la foto.
            MemoriaRegistroConsulta.listaFotosTomadas.remove(at: posicion);
        }
        // Se valida si hay fotos principales
        if (MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.count > 0) {
            
            // Se recorren según el tamaño de las imágenes base
            for index in (posicion..<MemoriaRegistroConsulta.listaFotosTomadas.count) {
                
                // Se actualizan los índices de los diccionarios para fotos principales, y dermatológicas seleccionadas
                
                // Se actualizan los diccionarios bajando una posición los que estaban después de la imagen borrada.
                
                // Se hizo de esta manera por un error del programador al pensar que sólo una foto base (padre) podría tener imágenes dermatoscópicas asociadas. Ls solución es algorítmicamente más compleja pero completamente funcional.
                
                MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia[index] = MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia[index + 1];
                
                MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[index] = MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[index + 1];
                
                // Si es el último elemento de las fotos base, elimina el que era último de los diccionarios
                if(index == MemoriaRegistroConsulta.listaFotosTomadas.count-1) {
                    
                    MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia.removeValue(forKey: index+1);
                    
                    MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia.removeValue(forKey: index+1);
                }
            }
        }
        
        // Si se eliminan todas las imágenes base, para asegurar aún más la funcionalidad, se reinicia todo lo asociado a las listas base y dermatoscopia.
        if(MemoriaRegistroConsulta.listaFotosTomadas.count == 0) {
            
            MemoriaRegistroConsulta.listaFotosTomadas = [];
            MemoriaRegistroConsulta.listaFotosSeleccionadas = [];
            
            MemoriaRegistroConsulta.fotosPrincipalesDermatoscopia = [:];
            MemoriaRegistroConsulta.listaFotosDermatoscopias = [:];
            MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia = [:];
        }
    }
    
    /**
     Permite redondear cualquier objeto que herede de UIView.
     - Parameter view: Corresponde al elemento que se desea redondear.
     */
    class func redondearVista (view: UIView) {
        view.layer.borderWidth = Constantes.BORDE_GROSOR;
        view.layer.masksToBounds = false;
        view.layer.borderColor = Constantes.BORDE_COLOR;
        view.layer.cornerRadius = view.frame.height/2;
        view.clipsToBounds = true;
    }
    
    /**
     Permite mostrar una vista que ha ocultado previamente.
     - Parameter vistaController: Corresponde a la vista padre que es el controlador.
     - Parameter vistaMostrar: Corresponde al elemento que se desea mostrar.
     - Parameter altoInicial : Corresponde al valor inicial que tenía la vista a mostrar.
     - Parameter altoAuxiliar: Guarda en memoria el valor inicial del alto de la vista antes de ser ocultada.
     - Parameter animado: Si se desea agregar una pequeña animación al mostrar la vista.
     */
    class func mostrarSeccion (vistaController: UIView, vistaMostrar: UIView, altoInicial : NSLayoutConstraint, altoAuxiliar: CGFloat, animado: Bool) {
        altoInicial.constant = altoAuxiliar;
        vistaMostrar.isHidden = false;
        
        if animado {
            UIView.animate(withDuration: 0.2, animations: {
                () -> Void in
                vistaController.layoutIfNeeded();
            }, completion: nil);
        } else {
            vistaController.layoutIfNeeded();
        }
    }
    
    /**
     Permite ocultar una vista.
     - Parameter vistaController: Corresponde a la vista padre que es el controlador.
     - Parameter vista: Corresponde al elemento que se desea ocultar.
     - Parameter altoInicial : Corresponde al valor inicial que tenía la vista a mostrar.
     - Parameter animado: Si se desea agregar una pequeña animación al mostrar la vista.
     */
    class func ocultarSeccion (vistaController: UIView, vista: UIView, altoInicial: NSLayoutConstraint, animado: Bool) {
        altoInicial.constant = 0;
        vista.isHidden = true;
        
        if animado {
            UIView.animate(withDuration: 0.2, animations: {
                () -> Void in
                vistaController.layoutIfNeeded()
            }, completion: nil)
        } else {
            vistaController.layoutIfNeeded()
        }
    }
    
    /**
     Permite descargar un conjunto de imágenes de manera asíncrona (background)
     - Parameter grupo: Corresponde al grupo al que pertenecen esas imágenes. Ver Constantes.
     - Parameter identificador: Corresponde al identificador del objeto al que pertenecen.
     - Parameter imagenes: Corresponde al conjunto de imágenes que se desea descargar.
     */
    class func descargarImagenesAsincrono (grupo: String, identificador: String, imagenes: [String: String]) {
        
        if(imagenes.count > 0) {
            let fileManager = FileManager.default;
            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                for (nombre, imagen) in imagenes {
                    if let url = URL(string: imagen) {
                        Alamofire.request(url).responseImage { response in
                            
                            if case .success(let image) = response.result {
                                let nombreFinal = "\(grupo)\(identificador)_\(nombre).png";
                                
                                var imageData: Data? = nil;
                                if let data = image.jpegData(compressionQuality: 0.8) {
                                    imageData = data;
                                } else if let data = image.pngData() {
                                    imageData = data;
                                }
                                
                                if(imageData != nil) {
                                    let filename = tDocumentDirectory.appendingPathComponent(nombreFinal);
                                    do {
                                        try imageData!.write(to: filename);
                                        print("En disco imagen: \(filename)");
                                    } catch {
                                        print("Error imagen: \(error)");
                                    }
                                }
                            } else {
                                print(response.error!);
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     Permite descargar un conjunto de imágenes de manera síncrona.
     - Parameter grupo: Corresponde al grupo al que pertenecen esas imágenes. Ver Constantes.
     - Parameter identificador: Corresponde al identificador del objeto al que pertenecen.
     - Parameter imagenes: Corresponde al conjunto de imágenes que se desea descargar.
     */
    class func descargarImagenSincrono (imagenUrl: String) -> DataResponse<Image> {
        
        // Se declara una variable para almacenar la respuesta del servicio.
        var resultado: DataResponse<Image>!;
        
        if let url = URL(string: imagenUrl) {
            // Se declara una variable para el control de peticiones asíncronas secuenciales.
            
            let semaforo = DispatchSemaphore(value: 0);
            
            Alamofire.request(url).responseImage { response in
                
                // Se evalúa la respuesta y se asigna al resultado.
                resultado = response;
                semaforo.signal();
            }
            _ = semaforo.wait(wallTimeout: .distantFuture);
        }
        return resultado;
    }
    
    /**
     Permite guardar o eliminar la "sesión" del usuario logueado, en los ficheros de configuración del dispositivo.
     - Parameter usuario: Corresponde al objeto Usuario que contiene la información para almacenar.
     - Parameter estaIniciando: Corresponde a un valor booleano para saber si se debe almacenar o eliminar.
     */
    class func iniciarCerrarSesion (usuario: Usuario?, estaIniciando: Bool) {
        if(estaIniciando){
            // Se almacena el ID del usuario que ha iniciado sesión.
            Funcionales.guardarUserDefaults(valor: usuario!.id!, llave: Constantes.SETTINGS_ID);
            // Se almacena el TOKEN de acceso.
            Funcionales.guardarUserDefaults(valor: usuario!.authentication_token!, llave: Constantes.SETTINGS_ACCESS_TOKEN);
            // Se almacen el estado de la sesión (true -> iniciada)
            Funcionales.guardarUserDefaults(valor: true, llave: Constantes.SETTINGS_LOGIN);
            // se almacena el email del médico
            Funcionales.guardarUserDefaults(valor: usuario!.email!, llave: Constantes.SETTINGS_EMAIL);
            // se almacena el nombre del médico
            Funcionales.guardarUserDefaults(valor: usuario!.name!, llave: Constantes.SETTINGS_NOMBRE);
            // se almacena el documento del médico
            Funcionales.guardarUserDefaults(valor: usuario!.number_document!, llave: Constantes.SETTINGS_DOCUMENTO);
        } else {
            Funcionales.guardarUserDefaults(valor: "", llave: Constantes.SETTINGS_ID);
            Funcionales.guardarUserDefaults(valor: "", llave: Constantes.SETTINGS_EMAIL);
            Funcionales.guardarUserDefaults(valor: false, llave: Constantes.SETTINGS_LOGIN);
            Funcionales.guardarUserDefaults(valor: "", llave: Constantes.SETTINGS_ACCESS_TOKEN);
            Funcionales.guardarUserDefaults(valor: "", llave: Constantes.SETTINGS_NOMBRE);
            Funcionales.guardarUserDefaults(valor: "", llave: Constantes.SETTINGS_DOCUMENTO);
            
            let domain = Bundle.main.bundleIdentifier!;
            UserDefaults.standard.removePersistentDomain(forName: domain);
            UserDefaults.standard.synchronize();
        }
    }
    
    /**
     Permite cambiar el estilo y texto de un botón y desactivarlo o no según se requiera.
     Generalmente cuando se ejecuta una tarea que consume algunos segundos. Ej: API.
     - Parameter boton: Corresponde al botón que se desea modificar.
     - Parameter texto: Corresponde al nuevo texto que se asignará al botón.
     - Parameter color: Corresponde al color background del botón.
     - Parameter activo: Corresponde a sí se debe activar o no el botón.
     */
    class func activarDesactivarBoton (boton: UIButton, texto: String, color: UIColor?, activo: Bool) {
        boton.isEnabled = activo;
        
        if(!activo) {
            boton.backgroundColor = .lightGray;
            boton.setTitle(texto, for: .disabled);
        } else {
            boton.backgroundColor = color;
            boton.setTitle(texto, for: .normal);
        }
    }
    
    /**
     Permite descargar las imágenes del usuario.
     - Parameter usuario: Corresponde al objeto del usuario que contiene las imágenes.
     */
    class func descargarImagenesUsuario (usuario: Usuario) {
        var imagenes = [String: String]();
        
        if(usuario.image_digital != nil) {
            imagenes["image_digital"] = usuario.image_digital!;
        }
        
        if(usuario.photo != nil) {
            imagenes["photo"] = usuario.photo!;
        }
        
        Funcionales.descargarImagenesAsincrono(grupo: Constantes.GRUPO_USUARIO, identificador: usuario.number_document!, imagenes: imagenes);
    }
    
    /**
     Permite agregar bordes en diferentes lados de una vista.
     - Parameter lado: Corresponde al lado según ENUM (al final de este documento).
     - Parameter color: Corresponde al color CGColor con el que se desea pintar el borde.
     - Parameter grosor: Corresponde al grosor de la lineal del borde.
     - Parameter view: Corresponde a la vista a la cual se aplica el borde.
     */
    class func agregarBorde(lado: ViewSide, color: CGColor, grosor: CGFloat, vista: UIView) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch lado {
        case .Left: border.frame = CGRect(x: vista.frame.minX, y: vista.frame.minY, width: grosor, height: vista.frame.height); break
        case .Right: border.frame = CGRect(x: vista.frame.maxX, y: vista.frame.minY, width: grosor, height: vista.frame.height); break
        case .Top: border.frame = CGRect(x: vista.frame.minX, y: vista.frame.minY, width: vista.frame.width, height: grosor); break
        case .Bottom: border.frame = CGRect(x: vista.frame.minX, y: vista.frame.height, width: vista.frame.width, height: grosor); break
        }
        
        vista.layer.addSublayer(border);
    }
    
    /**
     Permite imprimir en consola la información de un objeto. Se usa en modo pruebas.
     - Parameter objeto: Corresponde al objeto del cual se desea obtener la información.
     - Parameter titulo: Corresponde a un valor opcional que indica las propiedades de quíen.
     */
    class func imprimirObjetoConPropiedades (objeto: NSObject, titulo: String?) {
        if(titulo != nil) {
            print(titulo!);
        }
        
        let mirrored_object = Mirror(reflecting: objeto);
        
        for (index, attr) in mirrored_object.children.enumerated() {
            if let propertyName = attr.label as String? {
                print("Attr \(index): \(propertyName) = \(attr.value)")
            }
        }
    }
    
    /**
     Permite calcular la edad del paciente.
     - Parameter nacimiento: Corresponde a la fecha de nacimiento tipo Date.
     - Returns: Devuelve una tupla compuesta por cantidad y unidad de medida.
     */
    class func calcularEdad (nacimiento: Date, listaUnidadMedida: [ConstanteValor], enTexto: Bool) -> (Int, String)?{
        let now = Date();
        let birthday = nacimiento;
        let calendar = Calendar.current;
        
        let edadAnios = calendar.dateComponents([.year], from: birthday, to: now);
        let edadMeses = calendar.dateComponents([.month], from: birthday, to: now);
        let edadDias = calendar.dateComponents([.day], from: birthday, to: now);
        
        // Se valida en orden descendente si el resultado es mayor a cero.
        if let anios = edadAnios.year {
            if (anios > 0) {
                if let unidad = listaUnidadMedida.first(where: {$0.title == "Años"}) {
                    if (enTexto) {
                        return (anios, unidad.title!);
                    } else {
                        return (anios, unidad.value!.description);
                    }
                }
            }
        }
        
        if let meses = edadMeses.month {
            if (meses > 0) {
                if let unidad = listaUnidadMedida.first(where: {$0.title == "Meses"}) {
                    if (enTexto) {
                        return (meses, unidad.title!);
                    } else {
                        return (meses, unidad.value!.description);
                    }
                }
            }
        }
        
        if let dias = edadDias.day {
            if (dias > 0) {
                if let unidad = listaUnidadMedida.first(where: {$0.title == "Días"}) {
                    if (enTexto) {
                        return (dias, unidad.title!);
                    } else {
                        return (dias, unidad.value!.description);
                    }
                }
            }
        }
        
        return nil;
    }
    
    /**
     Permite convertir una imagen a codificación 64
     - Parameter image: Corresponde a una imagen de tipo UIImage.
     - Returns: Devuelve un string con la imagen codificacda.
     */
    class func imagen64 (imagen: UIImage) -> String {
        let imageData = imagen.jpegData(compressionQuality: 0.8);
        let imageBase64String = "data:image/jpeg;base64,\(String(describing: imageData!.base64EncodedString().description))";
        
        return imageBase64String;
    }
    
    /**
     Se encarga de revisar si hay información pendiente por sincronizar.
     Aplica para:
     - Paciente:
     - Información paciente:
     - Consulta:
     - Control:
     */
    class func sincronizarInformacion () {
        
        print ("Entra a sincronizar información");
        
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        let pacientes = FachadaDependientesSQL.seleccionarPorSincronizadoPaciente(conexion: conexion, estaSincronizado: false);
        
        print("Pacientes: \(pacientes.count)")
        
        if (pacientes.count > 0) {
            for paciente in pacientes {
                Funcionales.imprimirObjetoConPropiedades(objeto: paciente, titulo: "Paciente");
                
                if let informacion = FachadaDependientesSQL.seleccionarTodoInformacionPaciente(conexion: conexion).first(where: {$0.id_patient_local == paciente.id_local && $0.sincronizado == false}) {
                    sincronizarPaciente(paciente: paciente, informacion: informacion);
                }
            }
        } else {
            let consultas = FachadaDependientesSQL.seleccionarPorSincronizadoConsultaMedica(conexion: conexion, estaSincronizado: false);
            if (consultas.count > 0) {
                for consulta in consultas {
                    sincronizarConsultaMedica(consulta: consulta);
                }
            }
            
            let controles = FachadaDependientesSQL.seleccionarPorSincronizadoControlMedico(conexion: conexion, estaSincronizado: false);
            if (controles.count > 0) {
                for control in controles {
                    sincronizarControlMedico(control: control);
                }
            }
            
            if (consultas.count == 0 && controles.count == 0) {
                revisarImagenesPendientesEnviar();
            }
        }
        
    }
    
    /**
     Permite sincronizar la información local del paciente con el servidor.
     - Parameter paciente: Corresponde al objeto paciente con la información local.
     - Parameter informacion: Corresponde al objeto información paciente con la información local.
     */
    class func sincronizarPaciente (paciente: Paciente, informacion: InformacionPaciente) {
        
        print("Entra sincronizar paciente");
        
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.registrarHttpPaciente(paciente: paciente, informacion: informacion);
            
            DispatchQueue.main.async(execute: {
                switch resultado {
                case let .success(data):
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    if (json[0]["error"] == nil) {
                        
                        // Se sincronizan con el servidor
                        if let pacienteRespuesta = Paciente(JSONString: json[0]["patient"].description) {
                            
                            if let informacionPacienteRespuesta = InformacionPaciente(JSONString: json[0]["patient_information"].description) {
                                pacienteRespuesta.sincronizado = true;
                                informacionPacienteRespuesta.sincronizado = true;
                                
                                pacienteRespuesta.id_local = paciente.id_local;
                                informacionPacienteRespuesta.id_local = informacion.id_local;
                                informacionPacienteRespuesta.id_patient_local = informacion.id_patient_local;
                                
                                Funcionales.imprimirObjetoConPropiedades(objeto: pacienteRespuesta, titulo: "Paciente sincronizado");
                                Funcionales.imprimirObjetoConPropiedades(objeto: informacionPacienteRespuesta, titulo: "\n\nInformación Paciente sincronizado");
                                
                                // Se actualiza la base de datos con la información que devuelve el servidor.
                                let _ = FachadaDependientesSQL.actualizarRegistroPacienteOffline(conexion: conexion, idRegistro: paciente.id_local, data: pacienteRespuesta);
                                let _ = FachadaDependientesSQL.actualizarRegistroInformacionPacienteOffline(conexion: conexion, idRegistro: informacionPacienteRespuesta.id_local, data: informacionPacienteRespuesta);
                                
                                // Se consultan las consultas médicas sin sincronizar y con información paciente local del registro que se acaba de sincronizar
                                let consultas = FachadaDependientesSQL.seleccionarPorSincronizadoConsultaMedica(conexion: conexion, estaSincronizado: false).filter({$0.local_patient_information_id == informacion.id_local});
                                
                                if (consultas.count > 0) {
                                    for consulta in consultas {
                                        consulta.patient_information_id = informacionPacienteRespuesta.id;
                                        consulta.patient_id = pacienteRespuesta.id;
                                        
                                        Funcionales.imprimirObjetoConPropiedades(objeto: consulta, titulo: "Consulta sincronizar")
                                        
                                        sincronizarConsultaMedica(consulta: consulta);
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                    }
                case let .failure(error):
                    print("Error: \(error)");
                }
            });
        });
    }
    
    /**
     Permite sincronizar la información local de una consulta con el servidor.
     - Parameter consulta: Corresponde a un objeto de tipo consulta médica.
     */
    class func sincronizarConsultaMedica (consulta: ConsultaMedica) {
        
        Funcionales.imprimirObjetoConPropiedades(objeto: consulta, titulo: "Consulta pendiente");
        print("Entra sincronizar consulta");
        
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.registrarConsultaSinAdjuntos(consulta: consulta);
            
            DispatchQueue.main.async(execute: {
                
                switch  resultado {
                case let .success(data):
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    print(json);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] == nil) {
                        // Si se comprueba el registro de la consulta médica, se procede a guardar las imágenes
                        if let consultaRespuesta = ConsultaMedica(JSONString: json[0]["consultant"].description) {
                            consultaRespuesta.sincronizado = true;
                            consultaRespuesta.local_patient_information_id = consulta.local_patient_information_id;
                            consultaRespuesta.local_patient_id = consulta.local_patient_id;
                            consultaRespuesta.local_consultation_id = consulta.consultation_id;
                            consultaRespuesta.id_local = consulta.id_local;
                            
                            // Se actualiza la base de datos con la información que devuelve el servidor.
                            let _ = FachadaDependientesSQL.actualizarRegistroConsultaMedicaOffline(conexion: conexion, idRegistro: consulta.id_local, data: consultaRespuesta);
                            
                            Funcionales.imprimirObjetoConPropiedades(objeto: consultaRespuesta, titulo: "Consulta actualizada");
                            
                            // Se actualizan los registros de imágenes asociadas a la consulta para el posterior envío.
                            let archivosEnviar = FachadaDependientesSQL.seleccionarTodoArchivosEnviar(conexion: conexion).filter({$0.local_consultation_id == consulta.id_local});
                            if (archivosEnviar.count > 0) {
                                for archivo in archivosEnviar {
                                    archivo.consultation_id = consultaRespuesta.id;
                                    let _ = FachadaDependientesSQL.actualizarRegistroArchivosEnviar(conexion: conexion, idRegistro: archivo.id!, data: archivo);
                                    
                                    Funcionales.imprimirObjetoConPropiedades(objeto: archivo, titulo: "Archivo actualizado");
                                }
                                
                                revisarImagenesPendientesEnviar();
                            }
                            
                        }
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                }
            });
        });
    }
    
    /**
     Permite sincronizar la información local de un control médico con el servidor.
     - Parameter control: Corresponde a un objeto de tipo consulta médica.
     */
    class func sincronizarControlMedico (control: ControlMedico) {
        
        print("Entra sincronizar control");
        
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.registrarControlMedicoSinAdjuntos(control: control);
            
            DispatchQueue.main.async(execute: {
                
                switch  resultado {
                case let .success(data):
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    print(json);
                    
                    if(json[0]["error"] == nil) {
                        // Si se comprueba el registro de la consulta médica, se procede a guardar las imágenes
                        // Si se comprueba el registro del control médico, se procede a guardar las imágenes
                        if let controlRespuesta = ControlMedico(JSONString: json[0]["control_medico"].description) {
                            controlRespuesta.sincronizado = true;
                            controlRespuesta.local_consultation_id = control.local_consultation_id;
                            controlRespuesta.local_consultation_control_id = control.local_consultation_control_id;
                            controlRespuesta.id_local = control.id_local;
                            controlRespuesta.id_patient_local = control.id_patient_local;
                            
                            // Se actualiza la base de datos con la información que devuelve el servidor.
                            let _ = FachadaDependientesSQL.actualizarRegistroControlMedicoOffline(conexion: conexion, idRegistro: control.id_local!, data: controlRespuesta);
                            
                            // Se actualizan los registros de imágenes asociadas a la consulta para el posterior envío.
                            let archivosEnviar = FachadaDependientesSQL.seleccionarTodoArchivosEnviar(conexion: conexion).filter({$0.local_consultation_control_id == control.id_local});
                            
                            if (archivosEnviar.count > 0) {
                                for archivo in archivosEnviar {
                                    archivo.consultation_control_id = controlRespuesta.consultation_control_id;
                                    let _ = FachadaDependientesSQL.actualizarRegistroArchivosEnviar(conexion: conexion, idRegistro: archivo.id!, data: archivo);
                                }
                                
                                revisarImagenesPendientesEnviar();
                            }
                            
                        }
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                }
            });
        });
    }
    
    /**
     Se encarga de revisar en la base de datos, qué imágenes no se han enviado para enviarlas de manera asíncrona.
     */
    class func revisarImagenesPendientesEnviar () {
        
        print("Entra a revisar imagenes pendientes");
        
        // Se declara una conexión a la base de datos interna.
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        // Se comprueba si aún quedan registros de imágenes pendientes por enviar.
        if let pendientePrimero = FachadaDependientesSQL.seleccionarPrimerRegistroArchivosEnviar(conexion: conexion) {
            
            // Se obtienen los registros que pertenezcan al mismo Control o Consulta y al mismo tipo de la primera consulta.
            // En el caso de lesiones, se obtiene tanto lesiones como dermatoscopía al tiempo. Uno tiene padre otro no.
            let tipo = pendientePrimero.tipo!;
            let controlConsultaId = (pendientePrimero.consultation_control_id != nil) ? pendientePrimero.consultation_control_id! : pendientePrimero.consultation_id!;
            let esConsulta = pendientePrimero.consultation_control_id != nil ? false : true;
            
            // Se obtienen los registros con el mismo control o consulta y el mismo tipo.
            let pendientes = FachadaDependientesSQL.seleccionarPorTipoConsultaControlArchivosEnviar(conexion: conexion, tipo: tipo, consultaControlId: controlConsultaId, esConsulta: esConsulta);
            
            var listaPadres = [String: String]();
            var listaHijas = [String: [String]]();
            
            let totalPendientes = pendientes.count;
            
            // Se valida si hay registros
            if (totalPendientes > 0) {
                var contador = 0;
                for pendiente in pendientes {
                    
                    DispatchQueue.global(qos: .background).async(execute: {
                        
                        // Guardar imagen individual
                        let resultado = FachadaHTTPDependientes.guardarImagenIndividual(imagen: pendiente, grupo: tipo);
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            switch (resultado) {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    if (response.response?.statusCode == 200) {
                                        let json = JSON(response.result.value!);
                                        // json["image"] contiene la url individual
                                        if(json[0]["error"] == nil) {
                                            print(json["image"].description);
                                            
                                            
                                            // Se guardan las hijas
                                            if (pendiente.padre != nil && pendiente.padre != "") {
                                                if (listaHijas[pendiente.padre!] == nil) {
                                                    listaHijas[pendiente.padre!] = [String]();
                                                }
                                                listaHijas[pendiente.padre!]?.append(json["image"].description);
                                            } else {
                                                listaPadres[pendiente.ruta] = json["image"].description;
                                            }
                                            
                                            
                                            contador += 1;
                                            
                                            print("Contador final: \(contador)");
                                            
                                            // Cuando ya se han enviado todas las imágenes de manera individual se procede a actualizar la consulta o control según el caso.
                                            if (contador == totalPendientes) {
                                                
                                                print("PAdres")
                                                print(listaPadres);
                                                
                                                print("Hijas")
                                                print(listaHijas);
                                                
                                                
                                                // Se evalúa el grupo al que pertenecen las imágenes y se llama al método correspondiente.
                                                switch tipo {
                                                case Constantes.GRUPO_ANEXO:
                                                    Funcionales.actualizarPendientesAnexos(conexion: conexion, controlConsultaId: controlConsultaId, listaFinal: listaPadres, esConsulta: esConsulta, pendientes: pendientes);
                                                    break;
                                                case Constantes.GRUPO_LESION:
                                                    Funcionales.actualizarPendientesLesion(conexion: conexion, controlConsultaId: controlConsultaId, listaFinal: listaPadres, listaAdicionales: listaHijas, esConsulta: esConsulta, lesiones: pendientes);
                                                    break;
                                                default:
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                                break;
                            case let.failure(error):
                                print(error);
                                break;
                            }
                        });
                    });
                }
            }
        } else {
            print("No hay pendientes.");
        }
    }
    
    /**
     Permite actualizar registros de anexos con las imágenes que ya se han enviado al servidor y se encuentran pendientes de envío a su respectiva consulta o control.
     - Parameter conexion: Corresponde a la conexión a la base de datos interna, con el fin de eliminar el registro una vez se haya obtenido respuesta satisfactoria del servidor.
     - Parameter controlConsultaId: Corresponde a un entero con el ID de la consulta la cual se actualiza y se asocian las imágenes pendientes.
     - Parameter listaFinal: Corresponde a la lista con la ruta de las imágenes que se enviaron de manera individual y que deben asociarse a la consulta.
     - Parameter esConsulta: Permite saber si se están asociando imágnees a una consulta o a un control.
     - Parameter pendientes: Corresponde al conjunto de imágenes pendientes ArchivosEnviar que deben ser eliminadas del disposivito.
     */
    private class func actualizarPendientesAnexos (conexion: Conexion, controlConsultaId: Int, listaFinal: [String: String], esConsulta: Bool, pendientes: [ArchivosEnviar]) {
        // Se llama a una función con lista de urls y el id de la consulta.
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.guardarAnexos(idControlConsulta: controlConsultaId, anexos: listaFinal, esConsulta: esConsulta);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case let .success(data):
                    print("Guardar anexos");
                    print(data);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta no contiene un error se actualiza la consulta
                    if(json[0]["error"] == nil) {
                        var idFinal: Int = 0;
                        if (esConsulta) {
                            idFinal = json[0]["consultation_id"].intValue;
                        } else {
                            idFinal = json[0]["consultation_control_id"].intValue;
                        }
                        
                        // Si se actualizó una consulta o control adjuntando las imágenes, entonces se eliminan del dispositivo
                        if (idFinal > 0) {
                            let fileManager = FileManager.default;
                            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                                
                                // Se recorren las imágenes que se encuentran en el dispositivo, que se acaban de asociar
                                for pendiente in pendientes {
                                    // Se genera la ruta por cada imagen
                                    let rutaCompleta = tDocumentDirectory.appendingPathComponent(pendiente.ruta);
                                    if (fileManager.fileExists(atPath: rutaCompleta.path)){
                                        do {
                                            try fileManager.removeItem(at: rutaCompleta);
                                        }
                                        catch let error as NSError {
                                            print("No se borró anexo: \(error)")
                                        }
                                    }
                                    
                                    let eliminar = FachadaDependientesSQL.eliminarRegistroArchivosEnviar(conexion: conexion, idRegistro: pendiente.id!);
                                    
                                    print("Eliminar Anexo: \(eliminar) - ID: \(String(describing: pendiente.id))")
                                }
                                
                                // Se llama nuevamente a la función de manera recursiva mientras sigan existiendo registros.
                                revisarImagenesPendientesEnviar();
                            }
                        }
                        
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                }
            }
        }
    }
    
    /**
     Permite actualizar registros de lesiones con las imágenes que ya se han enviado al servidor y se encuentran pendientes de envío a su respectiva consulta o control.
     - Parameter conexion: Corresponde a la conexión a la base de datos interna, con el fin de eliminar el registro una vez se haya obtenido respuesta satisfactoria del servidor.
     - Parameter controlConsultaId: Corresponde a un entero con el ID de la consulta la cual se actualiza y se asocian las imágenes pendientes.
     - Parameter listaFinal: Corresponde a la lista con la ruta de las imágenes que se enviaron de manera individual y que deben asociarse a la consulta.
     - Parameter esConsulta: Permite saber si se están asociando imágnees a una consulta o a un control.
     - Parameter lesiones: Corresponde al conjunto de imágenes pendientes ArchivosEnviar que deben ser eliminadas del disposivito.
     */
    private class func actualizarPendientesLesion (conexion: Conexion, controlConsultaId: Int, listaFinal: [String: String], listaAdicionales: [String: [String]], esConsulta: Bool, lesiones: [ArchivosEnviar]) {
        // Se llama a una función con lista de urls y el id de la consulta.
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.guardarLesiones(idControlConsulta: controlConsultaId, lesiones: listaFinal, adicionales: listaAdicionales, esConsulta: esConsulta);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case let .success(data):
                    print("Guardar lesión");
                    print(data);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta no contiene un error se actualiza la consulta
                    if(json[0]["error"] == nil) {
                        // Se crea un objeto lesión con la respuesta del servicio
                        if let lesion = Lesion(JSONString: json[0]["injury"].description) {
                            
                            var idFinal: Int = 0;
                            if (esConsulta) {
                                idFinal = lesion.consultation_id!;
                            } else {
                                idFinal = lesion.consultation_control_id!;
                            }
                            
                            // Si se actualizó una consulta o control adjuntando las imágenes, entonces se eliminan del dispositivo
                            if (idFinal > 0) {
                                let fileManager = FileManager.default;
                                if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                                    
                                    // Se recorren las imágenes que se encuentran en el dispositivo, que se acaban de asociar
                                    for lesion in lesiones {
                                        // Se genera la ruta por cada imagen
                                        let rutaCompleta = tDocumentDirectory.appendingPathComponent(lesion.ruta);
                                        if (fileManager.fileExists(atPath: rutaCompleta.path)){
                                            do {
                                                try fileManager.removeItem(at: rutaCompleta);
                                            }
                                            catch let error as NSError {
                                                print("No se borró anexo: \(error)")
                                            }
                                        }
                                        
                                        let eliminar = FachadaDependientesSQL.eliminarRegistroArchivosEnviar(conexion: conexion, idRegistro: lesion.id!);
                                        
                                        print("Eliminar Lesión: \(eliminar) - ID: \(String(describing: lesion.id))")
                                    }
                                    
                                    // Se llama nuevamente a la función de manera recursiva mientras sigan existiendo registros.
                                    revisarImagenesPendientesEnviar();
                                }
                            }
                        }
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                }
            }
        }
    }
    
    class func arregloToJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}



enum ViewSide {
    case Left, Right, Top, Bottom
}
