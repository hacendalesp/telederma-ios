//
//  RegistroPacienteTerminacionViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 10/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//


/**
 1. Se registra el paciente si es consulta y no existe.
 2. Se registra la consulta o el control.
 3. Se guardan las imágenes en base de datos.
 4. Se envían las imágenes de la consulta o control como servicio individual.
 5. Se actualiza cada consulta o control con las url de las imágenes enviadas previamente.
 6. Se reinician variables en memoria y se redirige a consultas.
 */

import UIKit
import SwiftyJSON
import Alamofire

class RegistroPacienteTerminacionViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    // botones
    @IBOutlet weak var btnDatosPaciente: UIButton!
    @IBOutlet weak var btnHistoriaClinica: UIButton!
    @IBOutlet weak var btnExamenFisico: UIButton!
    @IBOutlet weak var btnImagenes: UIButton!
    @IBOutlet weak var btnAnexos: UIButton!
    
    // Altos de botones para esconder vistas
    @IBOutlet weak var altoDatosPaciente: NSLayoutConstraint!
    @IBOutlet weak var altoHistoriaClinica: NSLayoutConstraint!
    @IBOutlet weak var altoExamenFisico: NSLayoutConstraint!
    @IBOutlet weak var altoImagenes: NSLayoutConstraint!
    @IBOutlet weak var altoAnexos: NSLayoutConstraint!
    
    // Variables de control de altura
    var datosPacienteHeight: CGFloat!;
    var historiaClinicaHeight: CGFloat!;
    var examenFisicoHeight: CGFloat!;
    var imagenesHeight: CGFloat!;
    var anexosHeight: CGFloat!;
    
    let fileManager = FileManager.default;
    let conexion = Conexion();
    
    
    // Se declara una variable estática para informar que el proceso está a punto de terminar.
    static var estaConsultaListaParaEnviar = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.conexion.conectarBaseDatos();
        self.inits();
    }
    
    private func inits () {
        // Ajustar estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        // Se almacenan los datos iniciales
        self.datosPacienteHeight = self.altoDatosPaciente.constant;
        self.historiaClinicaHeight = self.altoHistoriaClinica.constant;
        self.examenFisicoHeight = self.altoExamenFisico.constant;
        self.imagenesHeight = self.altoImagenes.constant;
        self.anexosHeight = self.altoAnexos.constant;
        
        // Se valida si es control o consulta y se ocultan y modifican los botones.
        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
            self.btnDatosPaciente.setTitle("Datos Control", for: .normal);
            
            // Se ocultan demás botones.
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.btnHistoriaClinica, altoInicial: self.altoHistoriaClinica, animado: false);
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.btnExamenFisico, altoInicial: self.altoExamenFisico, animado: false);
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.btnAnexos, altoInicial: self.altoAnexos, animado: false);
        }
        
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
    }
    
    /**
     Permite enviar toda la información de paciente e información paciente sólo si el proceso de registro corresponde a una consulta.
     No aplica cuando se está registrando un control médico.
     */
    private func registrarPaciente () {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnSiguiente, texto: "Enviando ...", color: nil, activo: false);
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            
            let resultado = FachadaHTTPDependientes.registrarHttpPaciente(paciente: MemoriaRegistroPaciente.paciente!, informacion: MemoriaRegistroPaciente.informacionPaciente!);
            
            DispatchQueue.main.async(execute: { [self] in
                
                switch  resultado {
                case let .success(data):
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnSiguiente, texto: "Guardar", color:  Constantes.COLOR_BOTON_SECUNDARIO, activo: true);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["error"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                        }
                    } else {
                        let jsonPaciente = Paciente(JSONString: json[0]["patient"].description);
                        let jsonInformacionPaciente = InformacionPaciente(JSONString: json[0]["patient_information"].description);
                        
                        jsonPaciente?.sincronizado = true;
                        jsonInformacionPaciente?.sincronizado = true;
                        
                        MemoriaRegistroConsulta.consultaMedica?.patient_id = jsonPaciente?.id;
                        MemoriaRegistroConsulta.consultaMedica?.patient_information_id = jsonInformacionPaciente?.id;
                        
                        // Se valida si existe para saber si se actualiza o se ingresa
                        if (FachadaDependientesSQL.seleccionarPorIdPaciente(conexion: self.conexion, idRegistro: (jsonPaciente?.id!)!) != nil) {
                            let _ = FachadaDependientesSQL.actualizarRegistroPaciente(conexion: self.conexion, idRegistro: (jsonPaciente?.id!)!, data: jsonPaciente!);
                        } else {
                            let _ = FachadaDependientesSQL.insertarRegistroPaciente(conexion: conexion, data: jsonPaciente!);
                        }
                        
                        // Se valida si existe para saber si se actualiza o se ingresa
                        if (FachadaDependientesSQL.seleccionarPorIdInformacionPaciente(conexion: conexion, idRegistro: jsonInformacionPaciente!.id!) != nil) {
                            let _ = FachadaDependientesSQL.actualizarRegistroInformacionPaciente(conexion: conexion, idRegistro: (jsonInformacionPaciente?.id!)!, data: jsonInformacionPaciente!);
                        } else {
                            let _ = FachadaDependientesSQL.insertarRegistroInformacionPaciente(conexion: conexion, data: jsonInformacionPaciente!);
                        }
                        
                        // Posterior a la información del paciente, se registra la consulta con los ID actualizados.
                        self.enviarConsultaControlSinAdjuntos(esConsulta: true);
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnSiguiente, texto: "Guardar", color:  Constantes.COLOR_BOTON_SECUNDARIO, activo: true);
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            });
        });
    }
    
    /**
     Permite almacenar un paciente y su información de manera local
     */
    private func registrarPacienteOffline () {
        
        MemoriaRegistroPaciente.paciente?.sincronizado = false;
        let pacienteIdLocal = FachadaDependientesSQL.insertarRegistroPaciente(conexion: conexion, data: MemoriaRegistroPaciente.paciente!);
        
        print("Paciente local: \(pacienteIdLocal)");
        
        if (pacienteIdLocal > 0) {
            // Se actualiza la llave foránea con el paciente que se acaba de registrar en la base de datos
            MemoriaRegistroPaciente.paciente?.id_local = pacienteIdLocal;
            MemoriaRegistroPaciente.informacionPaciente?.id_patient_local = pacienteIdLocal;
            MemoriaRegistroPaciente.informacionPaciente?.sincronizado = false;
            
            let informacionPacienteIdLocal = FachadaDependientesSQL.insertarRegistroInformacionPaciente(conexion: conexion, data: MemoriaRegistroPaciente.informacionPaciente!);
            
            print("Información local: \(pacienteIdLocal)");
            
            if (informacionPacienteIdLocal > 0) {
                MemoriaRegistroPaciente.informacionPaciente?.id_local = informacionPacienteIdLocal;
                self.enviarConsultaControlSinAdjuntosOffline(esConsulta: true);
            }
        }
    }
    
    
    /**
     Permite registrar una consulta o un control sin adjuntos de audio.
     */
    private func enviarConsultaControlSinAdjuntos (esConsulta: Bool) {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnSiguiente, texto: "Enviando ...", color: nil, activo: false);
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            var resultado: Result<Any>;
            if (!esConsulta) {
                resultado = FachadaHTTPDependientes.registrarControlMedicoSinAdjuntos(control: MemoriaRegistroConsulta.controlMedico!);
            } else {
                resultado = FachadaHTTPDependientes.registrarConsultaSinAdjuntos(consulta: MemoriaRegistroConsulta.consultaMedica!);
            }
            
            DispatchQueue.main.async(execute: {
                
                switch  resultado {
                case let .success(data):
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnSiguiente, texto: "Guardar", color:  Constantes.COLOR_BOTON_SECUNDARIO, activo: true);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    print(json);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["error"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                        }
                    } else {
                        if (!esConsulta) {
                            // Si se comprueba el registro del control médico, se procede a guardar las imágenes
                            if let controlRespuesta = ControlMedico(JSONString: json[0]["control_medico"].description) {
                                controlRespuesta.sincronizado = true;
                                // Se registra el nuevo control en la base de datos
                                let _ = FachadaDependientesSQL.insertarRegistroControlMedico(conexion: self.conexion, data: controlRespuesta);
                                
                                self.guardarImagenesLocal(id: (controlRespuesta.consultation_control_id)!, esConsulta: esConsulta);
                            }
                        } else {
                            // Si se comprueba el registro de la consulta médica, se procede a guardar las imágenes
                            if let consultaRespuesta = ConsultaMedica(JSONString: json[0]["consultant"].description) {
                                consultaRespuesta.sincronizado = true;
                                
                                // Se registra la nueva consulta en la base de datos
                                let _ = FachadaDependientesSQL.insertarRegistroConsultaMedica(conexion: self.conexion, data: consultaRespuesta);
                                
                                self.guardarImagenesLocal(id: (consultaRespuesta.id)!, esConsulta: esConsulta);
                            }
                        }
                        self.regresoExitoso(mensaje: json[0]["message"].description);
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnSiguiente, texto: "Guardar", color:  Constantes.COLOR_BOTON_SECUNDARIO, activo: true);
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            });
        });
    }
    
    /**
     Permite registrar una consulta o un control de manera local.
     */
    private func enviarConsultaControlSinAdjuntosOffline (esConsulta: Bool) {
        
        if (esConsulta) {
            print("Entra consulta offline")
            // A diferencia de un control, una consulta primero puede registrar un paciente.
            // Se valida si no existe paciente
            
            MemoriaRegistroConsulta.consultaMedica?.local_patient_information_id = MemoriaRegistroPaciente.informacionPaciente?.id_local;
            
            MemoriaRegistroConsulta.consultaMedica?.local_patient_id = MemoriaRegistroPaciente.paciente?.id_local;
            
            // MemoriaRegistroConsulta.consultaMedica?.status = -1;
            
            
            MemoriaRegistroConsulta.consultaMedica?.sincronizado = false;
            // Se registra y se obtiene el id del último registro, para actualizar la consulta médica local.
            
            if (MemoriaRegistroConsulta.consultaMedica?.local_patient_information_id != nil || MemoriaRegistroConsulta.consultaMedica?.patient_information_id != nil) {
                
                let consultaIdLocal = FachadaDependientesSQL.insertarRegistroConsultaMedica(conexion: self.conexion, data: MemoriaRegistroConsulta.consultaMedica!);
                print("Consulta id: \(consultaIdLocal)")
                if (consultaIdLocal > 0) {
                    MemoriaRegistroConsulta.consultaMedica?.id_local = consultaIdLocal;
                    
                    Funcionales.imprimirObjetoConPropiedades(objeto: MemoriaRegistroConsulta.consultaMedica!, titulo: "Consulta offline");
                    
                    self.guardarImagenesLocal(id: consultaIdLocal, esConsulta: esConsulta);
                }
            }
            
        } else {
            print("Entra control offline")
            MemoriaRegistroConsulta.controlMedico?.sincronizado = false;
            
            // Se registra y se obtiene el id del último registro, para actualizar el control médico local.
            let controlIdLocal = FachadaDependientesSQL.insertarRegistroControlMedico(conexion: conexion, data: MemoriaRegistroConsulta.controlMedico!);
            
            if (controlIdLocal > 0) {
                MemoriaRegistroConsulta.controlMedico?.id_local = controlIdLocal;
                self.guardarImagenesLocal(id: controlIdLocal, esConsulta: esConsulta);
            }
        }
        self.regresoExitoso(mensaje: Mensajes.ENVIAR_INFORMACION_OFFLINE);
    }
    
    
    /**
     Permite almacenar las imágenes que se tomaron previamente y que se asocian a lesión y dermatoscopía.
     - parameter id: corresponde al id de la consulta o control.
     - parameter esConsulta: permite saber si las imágenes se asocian a una consulta o a un control.
     */
    private func guardarImagenesLocal (id: Int, esConsulta: Bool) {
        
        // Imágenes lesión
        if (MemoriaRegistroConsulta.listaFotosSeleccionadas.count > 0) {
            self.guardarImagenesEnDisco(imagenes: MemoriaRegistroConsulta.listaFotosSeleccionadas, grupo: Constantes.GRUPO_LESION, idConsultaControl: id, esConsulta: esConsulta);
        }
        
        // Almacenan las imágenes de anexos.
        if (MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos.count > 0) {
            self.guardarImagenesEnDisco(imagenes: MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos, grupo: Constantes.GRUPO_ANEXO, idConsultaControl: id, esConsulta: esConsulta);
        }
    }
    
    /**
     Permite almacenar en disco las imágenes asociadas a una consulta o a un control.
     - Parameter imagenes: Corresponde al conjunto de imágenes que se desea guardar en el disposivito.
     - Parameter grupo: Corresponde al tipo de contenido al cual pertenecen las imágenes. (Lesión, Dermatoscopía, Anexos)
     - Parameter idConsultaControl: Corresponde al id de la consulta o control al cual pertenecen las imágenes.
     - Parameter esConsulta: Permite saber si las imágenes pertenecen a una consulta o a un control.
     */
    private func guardarImagenesEnDisco (imagenes: [UIImage?], grupo: String, idConsultaControl: Int, esConsulta: Bool) {
        
        // Acceso a la carpeta de documentos del dispositivo.
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            var imagenesGuardar = [ArchivosEnviar]();
            var contador = 0;
            for (indice, imagen) in imagenes.enumerated() {
                if(imagen != nil) {
                    var imageData: Data? = nil;
                    if let data = imagen!.pngData() {
                        imageData = data;
                    } else if let data = imagen!.jpegData(compressionQuality: 0.8) {
                        imageData = data;
                    }
                    
                    if(imageData != nil) {
                        // GRUPO IDImagen IDConsultaControl
                        let nombre = "\(grupo)\(contador)_\(idConsultaControl.description).jpg";
                        let filename = tDocumentDirectory.appendingPathComponent(nombre);
                        
                        do {
                            try imageData!.write(to: filename);
                            
                            let archivo = ArchivosEnviar();
                            archivo.estado = true;
                            archivo.ruta = nombre;
                            archivo.tipo = grupo;
                            archivo.padre = nil;
                            
                            if (!esConsulta) {
                                if (Funcionales.dispositivoEstaConectado) {
                                    archivo.consultation_control_id = idConsultaControl;
                                } else {
                                    archivo.local_consultation_control_id = idConsultaControl;
                                }
                            } else {
                                if (Funcionales.dispositivoEstaConectado) {
                                    archivo.consultation_id = idConsultaControl;
                                } else {
                                    archivo.local_consultation_id = idConsultaControl;
                                }
                            }
                            contador += 1;
                            imagenesGuardar.append(archivo);
                            
                            print("En disco imagen: \(filename)");
                            
                            // Se valida si la imagen tiene imágenes dermatoscópicas asociadas
                            if (MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[indice]?.count ?? 0 > 0 && grupo == Constantes.GRUPO_LESION) {
                                print("Tiene dermatoscopia");
                                
                                var contadorDermatoscopia = 0;
                                for imagenDermatoscopia in MemoriaRegistroConsulta.listaFotosSeleccionadasDermatoscopia[indice]! {
                                    if(imagenDermatoscopia != nil) {
                                        var imageDataDermatoscopia: Data? = nil;
                                        if let dataDermatoscopia = imagenDermatoscopia!.pngData() {
                                            imageDataDermatoscopia = dataDermatoscopia;
                                        } else if let dataDermatoscopia = imagenDermatoscopia!.jpegData(compressionQuality: 0.8) {
                                            imageDataDermatoscopia = dataDermatoscopia;
                                        }
                                        
                                        if(imageDataDermatoscopia != nil) {
                                            // GRUPO IDImagen IDConsultaControl
                                            let nombreDermatoscopia = "\(grupo)\(contadorDermatoscopia)_dermatoscopia_\(idConsultaControl.description).jpg";
                                            let filenameDermatoscopia = tDocumentDirectory.appendingPathComponent(nombreDermatoscopia);
                                            
                                            do {
                                                try imageDataDermatoscopia!.write(to: filenameDermatoscopia);
                                                
                                                let archivo = ArchivosEnviar();
                                                archivo.estado = true;
                                                archivo.ruta = nombreDermatoscopia;
                                                archivo.tipo = grupo;
                                                archivo.padre = nombre;
                                                
                                                if (!esConsulta) {
                                                    if (Funcionales.dispositivoEstaConectado) {
                                                        archivo.consultation_control_id = idConsultaControl;
                                                    } else {
                                                        archivo.local_consultation_control_id = idConsultaControl;
                                                    }
                                                } else {
                                                    if (Funcionales.dispositivoEstaConectado) {
                                                        archivo.consultation_id = idConsultaControl;
                                                    } else {
                                                        archivo.local_consultation_id = idConsultaControl;
                                                    }
                                                }
                                                contadorDermatoscopia += 1;
                                                imagenesGuardar.append(archivo);
                                                
                                                print("En disco imagen: \(filenameDermatoscopia)");
                                                print("Padre: \(nombre)");
                                                
                                            } catch {
                                                print("Error imagen: \(error)");
                                            }
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("Error imagen: \(error)");
                        }
                    }
                }
            }
            
            if (imagenesGuardar.count > 0) {
                let _ = FachadaDependientesSQL.insertarRegistrosArchivosEnviar(conexion: self.conexion, data: imagenesGuardar);
            }
        }
    }
    
    // Regresa a la pantalla inicial de consultas.
    private func regresoExitoso (mensaje: String) {
        // Se valida las imágenes pendientes por enviar.
        // Funcionales.revisarImagenesPendientesEnviar();
        
        // Se reinician las variables en memoria de Control y Consulta
        RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar = false;
        MemoriaHistoriaClinica.reiniciarVariables();
        MemoriaRegistroConsulta.reiniciarVariables();
        MemoriaRegistroPaciente.reiniciarVariables();
        
        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: {
            (UIAlertAction) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_consulta") as! ConsultaViewController;
            self.present(vc, animated: true, completion: nil);
        });
        let alerta = UIAlertController(title: "Registro", message: mensaje, preferredStyle: .alert);
        alerta.addAction(accion);
        
        self.present(alerta, animated: true, completion: nil);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func accionDatosPaciente(_ sender: UIButton) {
        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_control_medico") as! ControlMedicoViewController;
            self.present(vc, animated: true, completion: nil);
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_1") as! RegistroPacienteViewController1;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    
    @IBAction func accionSiguiente(_ sender: UIButton) {
        // Si está en modo control médico no hay que registrar paciente.
        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
            if (Funcionales.dispositivoEstaConectado) {
                self.enviarConsultaControlSinAdjuntos(esConsulta: false);
            } else {
                self.enviarConsultaControlSinAdjuntosOffline(esConsulta: false);
            }
        } else {
            // Está en modo consulta.
            Funcionales.imprimirObjetoConPropiedades(objeto: MemoriaRegistroPaciente.paciente!, titulo: "Paciente antes");
            
            // Si paciente existe entonces se pasa a consulta
            if (MemoriaRegistroPaciente.paciente?.id != nil || MemoriaRegistroPaciente.paciente?.id_local != nil) {
                
                // Si existe, entonces se registra la información
                MemoriaRegistroConsulta.consultaMedica?.patient_information_id = MemoriaRegistroPaciente.informacionPaciente?.id;
                if (Funcionales.dispositivoEstaConectado) {
                    self.enviarConsultaControlSinAdjuntos(esConsulta: true);
                } else {
                    self.enviarConsultaControlSinAdjuntosOffline(esConsulta: true);
                }
            } else {
                
                if (Funcionales.dispositivoEstaConectado) {
                    self.registrarPaciente();
                } else {
                    self.registrarPacienteOffline();
                }
            }
        }
    }
    
}
