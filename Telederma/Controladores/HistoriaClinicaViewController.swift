//
//  HistoriaClinicaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 12/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class HistoriaClinicaViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var vistaPrincipal: UIView!
    @IBOutlet weak var btnHistoriaClinica: UIButton!
    @IBOutlet weak var btnImagenes: UIButton!
    @IBOutlet weak var btnRespuesta: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var btnControlMedico: UIButton!
    
    // Se asigna desde el controlador que hace el llamado
    var consultaId: Int!;        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes de estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnControlMedico.isHidden = true;
        self.loading.hidesWhenStopped = true;
        
        // Se reinician los valores en Memoria
        MemoriaHistoriaClinica.reiniciarVariablesSinControlActivo();
        
        if (Funcionales.dispositivoEstaConectado) {
            self.obtenerConsultaPorId();
        } else {
            self.obtenerConsultaPorIdOffline();
        }
    }
    
    /**
     Permite cargar el viewcontroller de historia clínica de manera embebida.
     */
    private func iniciarHistoriaClinica () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_interno_historia_clinica") as! InternoHistoriaClinicaViewController;
        vc.consultaId = self.consultaId;
        
        // Se añade un controller hijo.
        self.addChild(vc);
        
        // Se ajusta la vista del hijo al contenedor padre.
        self.vistaPrincipal.addSubview(vc.view);
        vc.view.frame = self.vistaPrincipal.bounds;
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        
        // El contenedor hijo se reporta con el padre.
        vc.didMove(toParent: self);
    }
    
    /**
     Permite cargar el viewcontroller de imágenes de manera embebida.
     */
    private func iniciarImagenes () {
        if let consulta = MemoriaHistoriaClinica.consultasMedicas.first(where: {$0.id == self.consultaId}) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_interno_imagenes") as! InternoImagenesViewController;
            vc.consulta = consulta;
            // Se añade un controller hijo.
            self.addChild(vc);
            
            // Se ajusta la vista del hijo al contenedor padre.
            self.vistaPrincipal.addSubview(vc.view);
            vc.view.frame = self.vistaPrincipal.bounds;
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight];
            
            // El contenedor hijo se reporta con el padre.
            vc.didMove(toParent: self);
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.NO_INFO);
        }
    }
    
    /**
     Permite cargar el viewcontroller de respuesta de manera embebida.
     */
    private func iniciarRespuesta () {
        if let consulta = MemoriaHistoriaClinica.consultasMedicas.first(where: {$0.id == self.consultaId}) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_interno_respuesta") as! InternoRespuestaViewController;
            vc.consulta = consulta;
            
            // Se añade un controller hijo.
            self.addChild(vc);
            
            // Se ajusta la vista del hijo al contenedor padre.
            self.vistaPrincipal.addSubview(vc.view);
            vc.view.frame = self.vistaPrincipal.bounds;
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight];
            
            // El contenedor hijo se reporta con el padre.
            vc.didMove(toParent: self);
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.NO_INFO);
        }
    }
    
    /**
     Permite cargar el viewcontroller de historial de manera embebida.
     */
    private func iniciarHistorial () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_interno_historial") as! InternoHistorialViewController;
        
        // Se añade un controller hijo.
        self.addChild(vc);
        
        // Se ajusta la vista del hijo al contenedor padre.
        self.vistaPrincipal.addSubview(vc.view);
        vc.view.frame = self.vistaPrincipal.bounds;
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        
        // El contenedor hijo se reporta con el padre.
        vc.didMove(toParent: self);
    }
    
    /**
     Permite cambiar los botones de las pestañas al color por defecto.
     */
    private func desactivarBotones () {
        self.btnHistoriaClinica.backgroundColor = .systemBlue;
        self.btnImagenes.backgroundColor = .systemBlue;
        self.btnRespuesta.backgroundColor = .systemBlue;
        self.btnHistorial.backgroundColor = .systemBlue;
    }
    
    /**
     Permite consultar la infomación desde el servidor.
     */
    private func obtenerConsultaPorId () {
        
        self.loading.startAnimating();
        let parametros: [String: String] = [
            "consultation_id": self.consultaId.description
        ];
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.obtenerHttpConsultaMedicaPorId(parametros: parametros);
            
            DispatchQueue.main.async(execute: {
                switch (resultado) {
                case let .success(data):
                    let json = JSON(arrayLiteral: data);
                    self.loading.stopAnimating();
                    self.btnControlMedico.isHidden = false;
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["error"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            if(!(json[0]["error"].array != nil)) {
                                Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                            } else {
                                Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONVERSION_DATA);
                            }
                        }
                    } else {
                        let conexion = Conexion();
                        conexion.conectarBaseDatos();
                        
                        if (json[0].count > 0) {
                            if (json[0]["patient"] != nil) {
                                
                                let paciente = Paciente(JSONString: json[0]["patient"].description);
                                paciente?.sincronizado = true;
                                
                                MemoriaHistoriaClinica.paciente = paciente;
                                
                                // Validamos si ya existe o si se debe ingresar
                                if (FachadaDependientesSQL.seleccionarPorIdPaciente(conexion: conexion, idRegistro: (paciente?.id)!) != nil) {
                                    let _ = FachadaDependientesSQL.actualizarRegistroPaciente(conexion: conexion, idRegistro: (paciente?.id)!, data: paciente!);
                                } else {
                                    let _ = FachadaDependientesSQL.insertarRegistroPaciente(conexion: conexion, data: paciente!);
                                }
                                
                                if (json[0]["patient"]["consultants"].count > 0) {
                                    for item in json[0]["patient"]["consultants"].arrayValue {
                                        
                                        let consultaGeneral = ConsultaMedica(JSONString: item.description);
                                        consultaGeneral?.sincronizado = true;
                                        
                                        MemoriaHistoriaClinica.consultasMedicas.append(consultaGeneral!);
                                        
                                        // Se valida si ya existe o si se debe crear
                                        if (FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).first(where: {$0.id == consultaGeneral?.id}) != nil) {
                                            
                                            let _ = FachadaDependientesSQL.actualizarRegistroConsultaMedica(conexion: conexion, idRegistro: (consultaGeneral?.id)!, data: consultaGeneral!);
                                        } else {
                                            let _ = FachadaDependientesSQL.insertarRegistroConsultaMedica(conexion: conexion, data: consultaGeneral!);
                                        }
                                        
                                        if let idConsultaGeneral = item["id"].int {
                                            if let consulta = ConsultaMedica(JSONString: item["medical_consultation"].description) {
                                                consulta.sincronizado = true;
                                                
                                                MemoriaHistoriaClinica.consultasMedicas.append(consulta);
                                                
                                                // Se valida si existe o no en la base de datos para saber si se actualiza o se ingresa
                                                if (FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).first(where: {$0.id == consulta.id}) != nil) {
                                                    let _ = FachadaDependientesSQL.actualizarRegistroConsultaMedica(conexion: conexion, idRegistro: consulta.id!, data: consulta);
                                                } else {
                                                    let _ = FachadaDependientesSQL.insertarRegistroConsultaMedica(conexion: conexion, data: consulta);
                                                }
                                            }
                                            
                                            if let informacionPaciente = InformacionPaciente(JSONString: item["patient_information"].description) {
                                                
                                                // Se inicializa la primera vez para que se pueda añadir elementos.
                                                if (MemoriaHistoriaClinica.informacionPaciente[idConsultaGeneral] == nil) {
                                                    MemoriaHistoriaClinica.informacionPaciente[idConsultaGeneral] = [];
                                                }
                                                informacionPaciente.sincronizado = true;
                                                
                                                MemoriaHistoriaClinica.informacionPaciente[idConsultaGeneral]!.append(informacionPaciente);
                                                
                                                // Se valida si ya exite o si se debe ingresar
                                                if (FachadaDependientesSQL.seleccionarPorIdInformacionPaciente(conexion: conexion, idRegistro: informacionPaciente.id!) != nil) {
                                                    let _ = FachadaDependientesSQL.actualizarRegistroInformacionPaciente(conexion: conexion, idRegistro: informacionPaciente.id!, data: informacionPaciente);
                                                } else {
                                                    let _ = FachadaDependientesSQL.insertarRegistroInformacionPaciente(conexion: conexion, data: informacionPaciente);
                                                }
                                            }
                                            
                                            if let doctor = Usuario(JSONString: item["doctor"].description) {
                                                
                                                // Si no existe se agrega a la lista de doctores.
                                                if (MemoriaHistoriaClinica.medico.contains(where: {$0.professional_card == doctor.professional_card }) == false) {
                                                    doctor.sincronizado = true;
                                                    
                                                    MemoriaHistoriaClinica.medico.append(doctor);
                                                    
                                                    // Se valida si existe o si se debe ingresar
                                                    if (FachadaIndependientesSQL.seleccionarPorIdUsuario(conexion: conexion, idRegistro: doctor.id!) != nil) {
                                                        let _ = FachadaIndependientesSQL.actualizarRegistroUsuario(conexion: conexion, idRegistro: doctor.id!, data: doctor);
                                                    } else {
                                                        let _ = FachadaIndependientesSQL.insertarRegistrosUsuario(conexion: conexion, data: [doctor]);
                                                    }
                                                }
                                            }
                                            
                                            // Se procede con las lesiones
                                            if (item["injuries"].count > 0) {
                                                for itemLesion in item["injuries"].arrayValue {
                                                    if let lesion = Lesion(JSONString: itemLesion.description) {
                                                        lesion.sincronizado = true;
                                                        
                                                        MemoriaHistoriaClinica.lesiones.append(lesion);
                                                        
                                                        // Se valida si existe la lesión para saber si se actualiza o se ingresa
                                                        if (FachadaDependientesSQL.seleccionarTodoLesiones(conexion: conexion).first(where: {$0.id == lesion.id}) != nil) {
                                                            let _ = FachadaDependientesSQL.actualizarRegistroLesiones(conexion: conexion, idRegistro: lesion.id!, data: lesion);
                                                        } else {
                                                            let _ = FachadaDependientesSQL.insertarRegistrosLesiones(conexion: conexion, data: [lesion]);
                                                        }
                                                        
                                                        if (itemLesion["images_injuries"].count > 0) {
                                                            
                                                            for itemImagenLesion in itemLesion["images_injuries"].arrayValue {
                                                                
                                                                if let imagenLesion = ImagenLesion(JSONString: itemImagenLesion.description) {
                                                                    
                                                                    imagenLesion.image_injury_id = itemImagenLesion["image_injury_id"] != nil ? itemImagenLesion["image_injury_id"].description : nil;
                                                                    imagenLesion.sincronizado = true;
                                                                    
                                                                    MemoriaHistoriaClinica.imagenesLesiones.append(imagenLesion);
                                                                    
                                                                    // Se valida si existe o no para saber si se actualiza o se ingresa
                                                                    if (FachadaDependientesSQL.seleccionarTodoImagenLesiones(conexion: conexion).first(where: {$0.id == imagenLesion.id}) != nil) {
                                                                        let _ = FachadaDependientesSQL.actualizarRegistroImagenLesiones(conexion: conexion, idRegistro: imagenLesion.id!, data: imagenLesion);
                                                                    } else {
                                                                        let _ = FachadaDependientesSQL.insertarRegistrosImagenLesiones(conexion: conexion, data: [imagenLesion]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                } // Fin ciclo FOR lesiones
                                            }
                                            
                                            // Se procede con las respuestas de especialistas
                                            if (item["specialist_response"].count > 0) {
                                                for respuesta in item["specialist_response"].arrayValue {
                                                    if let respuestaEspecialista = RespuestaEspecialista(JSONString: respuesta.description) {
                                                        
                                                        // Se almacena la respuesta en memoria.
                                                        MemoriaHistoriaClinica.respuestasEspecialistas.append(respuestaEspecialista);
                                                        
                                                        // Se valida si existe para saber si se actualiza o se ingresa
                                                        if (FachadaDependientesSQL.seleccionarTodoRespuestaEspecialista(conexion: conexion).first(where: {$0.id == respuestaEspecialista.id}) != nil) {
                                                            let _ = FachadaDependientesSQL.actualizarRegistroRespuestaEspecialista(conexion: conexion, idRegistro: respuestaEspecialista.id!, data: respuestaEspecialista);
                                                        } else {
                                                            let _ = FachadaDependientesSQL.insertarRegistrosRespuestaEspecialista(conexion: conexion, data: [respuestaEspecialista]);
                                                        }
                                                        
                                                        // Se analiza el especialista asociado.
                                                        if let especialista = Especialista(JSONString: respuesta["specialist"].description) {
                                                            
                                                            // Si no existe se agrega a la lista de doctores.
                                                            if (MemoriaHistoriaClinica.especialista.contains(where: {$0.professional_card == especialista.professional_card }) == false) {
                                                                especialista.sincronizado = true;
                                                                
                                                                MemoriaHistoriaClinica.especialista.append(especialista);
                                                                
                                                                // Se valida si existe o si se debe ingresar
                                                                if (FachadaDependientesSQL.seleccionarTodoEspecialista(conexion: conexion).first(where: {$0.professional_card == especialista.professional_card}) != nil) {
                                                                    let _ = FachadaDependientesSQL.actualizarRegistroEspecialista(conexion: conexion, idRegistro: especialista.id!, data: especialista);
                                                                } else {
                                                                    let _ = FachadaDependientesSQL.insertarRegistrosEspecialista(conexion: conexion, data: [especialista]);
                                                                }
                                                            }
                                                        }
                                                        
                                                        // Se valida si tiene diagnósticos asociados.
                                                        if (respuesta["diagnostics"].count > 0) {
                                                            
                                                            for itemDiagnostico in respuesta["diagnostics"].arrayValue {
                                                                
                                                                if let diagnostico = Diagnostico(JSONString: itemDiagnostico.description) {
                                                                    // Se almacena el diagnóstico en memoria.
                                                                    MemoriaHistoriaClinica.diagnosticos.append(diagnostico);
                                                                    
                                                                    // Se valida si existe para saber si se actualiza o se ingresa
                                                                    if (FachadaDependientesSQL.seleccionarTodoDiagnostico(conexion: conexion).first(where: {$0.id == diagnostico.id}) != nil) {
                                                                        let _ = FachadaDependientesSQL.actualizarRegistroDiagnostico(conexion: conexion, idRegistro: diagnostico.id!, data: diagnostico);
                                                                    } else {
                                                                        let _ = FachadaDependientesSQL.insertarRegistrosDiagnostico(conexion: conexion, data: [diagnostico]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        // Se valida si tiene exámenes solicitados asociados.
                                                        if (respuesta["request_exams"].count > 0) {
                                                            
                                                            for itemExamen in respuesta["request_exams"].arrayValue {
                                                                
                                                                if let examenSolicitado = ExamenSolicitado(JSONString: itemExamen.description) {
                                                                    // Se almacena el exámen en memoria.
                                                                    MemoriaHistoriaClinica.examenesSolicitados.append(examenSolicitado);
                                                                    
                                                                    // Se valida si existe para saber si se actualiza o se ingresa
                                                                    if (FachadaDependientesSQL.seleccionarTodoExamenSolicitado(conexion: conexion).first(where: {$0.id == examenSolicitado.id}) != nil) {
                                                                        let _ = FachadaDependientesSQL.actualizarRegistroExamenSolicitado(conexion: conexion, idRegistro: examenSolicitado.id!, data: examenSolicitado);
                                                                    } else {
                                                                        let _ = FachadaDependientesSQL.insertarRegistrosExamenSolicitado(conexion: conexion, data: [examenSolicitado]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        // Se valida si tiene fórmulas asociados.
                                                        if (respuesta["formulas"].count > 0) {
                                                            
                                                            for itemFormula in respuesta["formulas"].arrayValue {
                                                                
                                                                if let formula = Formula(JSONString: itemFormula.description) {
                                                                    // Se almacena la fórmula en memoria.
                                                                    MemoriaHistoriaClinica.formulas.append(formula);
                                                                    
                                                                    // Se valida si existe para saber si se actualiza o se ingresa
                                                                    if (FachadaDependientesSQL.seleccionarTodoFormula(conexion: conexion).first(where: {$0.id == formula.id}) != nil) {
                                                                        let _ = FachadaDependientesSQL.actualizarRegistroFormula(conexion: conexion, idRegistro: formula.id!, data: formula);
                                                                    } else {
                                                                        let _ = FachadaDependientesSQL.insertarRegistrosFormula(conexion: conexion, data: [formula]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        // Se valida si tiene Mipres asociados.
                                                        if (respuesta["mipres"].count > 0) {
                                                            
                                                            for itemMipres in respuesta["mipres"].arrayValue {
                                                                
                                                                if let mipres = Mipres(JSONString: itemMipres.description) {
                                                                    // Se almacena Mipres en memoria.
                                                                    MemoriaHistoriaClinica.mipres.append(mipres);
                                                                    
                                                                    // Se valida si existe para saber si se actualiza o se ingresa
                                                                    if (FachadaDependientesSQL.seleccionarTodoMipres(conexion: conexion).first(where: {$0.id == mipres.id}) != nil) {
                                                                        let _ = FachadaDependientesSQL.actualizarRegistroMipres(conexion: conexion, idRegistro: mipres.id!, data: mipres);
                                                                    } else {
                                                                        let _ = FachadaDependientesSQL.insertarRegistrosMipres(conexion: conexion, data: [mipres]);
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            // Se procede con los requerimientos
                                            if (item["request"].count > 0) {
                                                for itemRequest in item["request"].arrayValue {
                                                    if let request = Requerimiento(JSONString: itemRequest.description) {
                                                        MemoriaHistoriaClinica.requerimientos.append(request);
                                                        
                                                        // Se valida si existe para saber si se actualiza o se ingresa
                                                        if (FachadaDependientesSQL.seleccionarTodoRequerimiento(conexion: conexion).first(where: {$0.id == request.id}) != nil) {
                                                            let _ = FachadaDependientesSQL.actualizarRegistroRequerimiento(conexion: conexion, idRegistro: request.id!, data: request);
                                                        } else {
                                                            let _ = FachadaDependientesSQL.insertarRegistrosRequerimiento(conexion: conexion, data: [request]);
                                                        }
                                                    }
                                                } // Fin ciclo FOR requerimientos
                                            }
                                        }
                                        
                                        // Controles
                                        if (item["consultation_controls"].count > 0) {
                                            
                                            for control in item["consultation_controls"].arrayValue {
                                                
                                                if let controlMedicoPadre = ControlMedico(JSONString: control.description) {
                                                    controlMedicoPadre.sincronizado = true;
                                                                                                        
                                                    MemoriaHistoriaClinica.controlesMedicos.append(controlMedicoPadre);
                                                    
                                                    // Se valida si existe para saber si se actualiza o se ingresa.
                                                    if (FachadaDependientesSQL.seleccionarTodoControlMedico(conexion: conexion).first(where: {$0.id == controlMedicoPadre.id}) != nil) {
                                                        let _ = FachadaDependientesSQL.actualizarRegistroControlMedico(conexion: conexion, idRegistro: controlMedicoPadre.id!, data: controlMedicoPadre);
                                                    } else {
                                                        let _ = FachadaDependientesSQL.insertarRegistroControlMedico(conexion: conexion, data: controlMedicoPadre);
                                                    }
                                                    
                                                    if let doctor = Usuario(JSONString: control["doctor"].description) {
                                                        
                                                        if (MemoriaHistoriaClinica.medico.contains(where: {$0.professional_card == doctor.professional_card }) == false) {
                                                            doctor.sincronizado = true;
                                                            
                                                            MemoriaHistoriaClinica.medico.append(doctor);
                                                            
                                                            // Se valida si existe para saber si se actualiza o se ingresa
                                                            if (FachadaIndependientesSQL.seleccionarPorIdUsuario(conexion: conexion, idRegistro: doctor.id!) != nil) {
                                                                let _ = FachadaIndependientesSQL.actualizarRegistroUsuario(conexion: conexion, idRegistro: doctor.id!, data: doctor);
                                                            } else {
                                                                let _ = FachadaIndependientesSQL.insertarRegistrosUsuario(conexion: conexion, data: [doctor]);
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    // Se cargan los controles de la consulta previa.
                                                    if let controlMedico = ControlMedico(JSONString: control["medical_control"].description) {
                                                        // controlMedico.consultation_id = controlMedicoPadre.consultation_id;
                                                        controlMedico.consultation_control_id = controlMedicoPadre.id;
                                                        controlMedico.sincronizado = true;
                                                        
                                                        MemoriaHistoriaClinica.controlesMedicos.append(controlMedico);
                                                        
                                                        // Se valida si existe para saber si se actualiza o se ingresa
                                                        if (FachadaDependientesSQL.seleccionarTodoControlMedico(conexion: conexion).first(where: {$0.id == controlMedico.id}) != nil) {
                                                            let _ = FachadaDependientesSQL.actualizarRegistroControlMedico(conexion: conexion, idRegistro: controlMedico.id!, data: controlMedico);
                                                        } else {
                                                            let _ = FachadaDependientesSQL.insertarRegistroControlMedico(conexion: conexion, data: controlMedico);
                                                        }
                                                        
                                                    }
                                                    
                                                    if (control["injuries"].count > 0) {
                                                        
                                                        for injury in control["injuries"].arrayValue {
                                                            
                                                            if let lesion = Lesion(JSONString: injury.description) {
                                                                lesion.sincronizado = true;
                                                                
                                                                MemoriaHistoriaClinica.lesiones.append(lesion);
                                                                
                                                                // Se valida si existe para saber si se actualiza o se ingresa
                                                                if (FachadaDependientesSQL.seleccionarTodoLesiones(conexion: conexion).first(where: {$0.id == lesion.id}) != nil) {
                                                                    let _ = FachadaDependientesSQL.actualizarRegistroLesiones(conexion: conexion, idRegistro: lesion.id!, data: lesion);
                                                                } else {
                                                                    let _ = FachadaDependientesSQL.insertarRegistrosLesiones(conexion: conexion, data: [lesion]);
                                                                }
                                                                
                                                                // Se verifica si hay imágenes de lesión.
                                                                
                                                                if (injury["images_injuries"].count > 0) {
                                                                    for injuryImage in injury["images_injuries"].arrayValue {
                                                                        
                                                                        if let imagenLesion = ImagenLesion(JSONString: injuryImage.description) {
                                                                            imagenLesion.image_injury_id = injuryImage["image_injury_id"] != nil ? injuryImage["image_injury_id"].description : nil;
                                                                            imagenLesion.sincronizado = true;
                                                                            
                                                                            MemoriaHistoriaClinica.imagenesLesiones.append(imagenLesion);
                                                                            
                                                                            // Se valida si existe para saber si se actualiza o se ingresa
                                                                            if (FachadaDependientesSQL.seleccionarTodoImagenLesiones(conexion: conexion).first(where: {$0.id == imagenLesion.id}) != nil) {
                                                                                let _ = FachadaDependientesSQL.actualizarRegistroImagenLesiones(conexion: conexion, idRegistro: imagenLesion.id!, data: imagenLesion);
                                                                            } else {
                                                                                let _ = FachadaDependientesSQL.insertarRegistrosImagenLesiones(conexion: conexion, data: [imagenLesion]);
                                                                            }
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    if (control["specialist_response"].count > 0) {
                                                        for response in control["specialist_response"].arrayValue {
                                                            
                                                            if let respuesta = RespuestaEspecialista(JSONString: response.description) {
                                                                MemoriaHistoriaClinica.respuestasEspecialistas.append(respuesta);
                                                                
                                                                // Se valida si existe para saber si se actualiza o se ingresa
                                                                if (FachadaDependientesSQL.seleccionarTodoRespuestaEspecialista(conexion: conexion).first(where: {$0.id == respuesta.id}) != nil) {
                                                                    let _ = FachadaDependientesSQL.actualizarRegistroRespuestaEspecialista(conexion: conexion, idRegistro: respuesta.id!, data: respuesta);
                                                                } else {
                                                                    let _ = FachadaDependientesSQL.insertarRegistrosRespuestaEspecialista(conexion: conexion, data: [respuesta]);
                                                                }
                                                                
                                                                if let especialista = Especialista(JSONString: response["specialist"].description) {
                                                                    
                                                                    if (MemoriaHistoriaClinica.especialista.contains(where: {$0.professional_card == especialista.professional_card}) == false) {
                                                                        
                                                                        MemoriaHistoriaClinica.especialista.append(especialista);
                                                                        
                                                                        // Se valida si existe para saber si se actualiza o se ingresa
                                                                        if (FachadaDependientesSQL.seleccionarTodoEspecialista(conexion: conexion).first(where: {$0.id == especialista.id}) != nil) {
                                                                            let _ = FachadaDependientesSQL.actualizarRegistroEspecialista(conexion: conexion, idRegistro: especialista.id!, data: especialista);
                                                                        } else {
                                                                            let _ = FachadaDependientesSQL.insertarRegistrosEspecialista(conexion: conexion, data: [especialista]);
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                
                                                                if (response["diagnostics"].count > 0) {
                                                                    for itemDiagnostico in response["diagnostics"].arrayValue {
                                                                        
                                                                        if let diagnostico = Diagnostico(JSONString: itemDiagnostico.description) {
                                                                            
                                                                            MemoriaHistoriaClinica.diagnosticos.append(diagnostico);
                                                                            
                                                                            // Se valida si existe para saber si se actualiza o se ingresa
                                                                            if (FachadaDependientesSQL.seleccionarTodoDiagnostico(conexion: conexion).first(where: {$0.id == diagnostico.id}) != nil) {
                                                                                let _ = FachadaDependientesSQL.actualizarRegistroDiagnostico(conexion: conexion, idRegistro: diagnostico.id!, data: diagnostico);
                                                                            } else {
                                                                                let _ = FachadaDependientesSQL.insertarRegistrosDiagnostico(conexion: conexion, data: [diagnostico]);
                                                                            }
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                                
                                                                if (response["request_exams"].count > 0) {
                                                                    for itemExamenSolicitado in response["request_exams"].arrayValue {
                                                                        
                                                                        if let examen = ExamenSolicitado(JSONString: itemExamenSolicitado.description) {
                                                                            
                                                                            MemoriaHistoriaClinica.examenesSolicitados.append(examen);
                                                                            
                                                                            // Se valida si existe para saber si se actualiza o se ingresa
                                                                            if (FachadaDependientesSQL.seleccionarTodoExamenSolicitado(conexion: conexion).first(where: {$0.id == examen.id}) != nil) {
                                                                                let _ = FachadaDependientesSQL.actualizarRegistroExamenSolicitado(conexion: conexion, idRegistro: examen.id!, data: examen);
                                                                            } else {
                                                                                let _ = FachadaDependientesSQL.insertarRegistrosExamenSolicitado(conexion: conexion, data: [examen]);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                if (response["formulas"].count > 0) {
                                                                    for itemFormula in response["formulas"].arrayValue {
                                                                        
                                                                        if let formula = Formula(JSONString: itemFormula.description) {
                                                                            
                                                                            MemoriaHistoriaClinica.formulas.append(formula);
                                                                            
                                                                            // Se valida si existe para saber si se actualiza o se ingresa
                                                                            if (FachadaDependientesSQL.seleccionarTodoFormula(conexion: conexion).first(where: {$0.id == formula.id}) != nil) {
                                                                                let _ = FachadaDependientesSQL.actualizarRegistroFormula(conexion: conexion, idRegistro: formula.id!, data: formula);
                                                                            } else {
                                                                                let _ = FachadaDependientesSQL.insertarRegistrosFormula(conexion: conexion, data: [formula]);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                if (response["mipres"].count > 0) {
                                                                    for itemMipres in response["mipres"].arrayValue {
                                                                        
                                                                        if let mipres = Mipres(JSONString: itemMipres.description) {
                                                                            
                                                                            MemoriaHistoriaClinica.mipres.append(mipres);
                                                                            
                                                                            // Se valida si existe para saber si se actualiza o se ingresa
                                                                            if (FachadaDependientesSQL.seleccionarTodoMipres(conexion: conexion).first(where: {$0.id == mipres.id}) != nil) {
                                                                                let _ = FachadaDependientesSQL.actualizarRegistroMipres(conexion: conexion, idRegistro: mipres.id!, data: mipres);
                                                                            } else {
                                                                                let _ = FachadaDependientesSQL.insertarRegistrosMipres(conexion: conexion, data: [mipres]);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                    } // Fin ciclo FOR generales
                                }
                                self.ordenarConsultas();
                                self.iniciarHistoriaClinica();
                            } else {
                                Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.NO_INFO);
                            }
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.NO_INFO);
                        }
                    }
                    break;
                case let.failure(error):
                    print(error);
                    self.loading.stopAnimating();
                    self.btnControlMedico.isHidden = false;
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    break;
                }
            });
        });
    }
    
    /**
     Permite cargar la información desde la base de datos cuando no se reconoce una conexión a internet.
     */
    private func obtenerConsultaPorIdOffline () {
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        self.loading.startAnimating();
        // Selecciona las consultas almacenadas en la base de datos.
        if let consultaGeneral = FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).first(where: {$0.id == self.consultaId}) {
            // Se activa el botón para agregar controles
            self.btnControlMedico.isHidden = false;
            
            // Selecciona el paciente relacionado con la consulta.
            if let paciente = FachadaDependientesSQL.seleccionarPorIdPaciente(conexion: conexion, idRegistro: consultaGeneral.patient_id!) {
                MemoriaHistoriaClinica.paciente = paciente;
            }
            
            MemoriaHistoriaClinica.consultasMedicas.append(consultaGeneral);
            // Selecciona las consulta médicas con consultation_id igual a consultaId
            let medicalConsultations = FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).filter({$0.consultation_id == nil && $0.patient_id == MemoriaHistoriaClinica.paciente?.id});
            if (medicalConsultations.count > 0) {
                for medicalConsultation in medicalConsultations {
                    if (!MemoriaHistoriaClinica.consultasMedicas.contains(where: {$0.id == medicalConsultation.id})) {
                        MemoriaHistoriaClinica.consultasMedicas.append(medicalConsultation);
                    }
                }
            }
            
            if let patientInformation = FachadaDependientesSQL.seleccionarTodoInformacionPaciente(conexion: conexion).first(where: {$0.id == consultaGeneral.patient_information_id}) {
                if (MemoriaHistoriaClinica.informacionPaciente[consultaGeneral.id!] == nil) {
                    MemoriaHistoriaClinica.informacionPaciente[consultaGeneral.id!] = [];
                }
                MemoriaHistoriaClinica.informacionPaciente[consultaGeneral.id!]!.append(patientInformation);
            }
            
            // Selecciona al doctor que realizó la consulta
            if let doctor = FachadaIndependientesSQL.seleccionarPorIdUsuario(conexion: conexion, idRegistro: consultaGeneral.doctor_id!) {
                // Si no existe se agrega a la lista de doctores.
                if (MemoriaHistoriaClinica.medico.contains(where: {$0.professional_card == doctor.professional_card }) == false) {
                    MemoriaHistoriaClinica.medico.append(doctor);
                }
            }
            
            // Selecciona lesiones
            let lesiones = FachadaDependientesSQL.seleccionarTodoLesiones(conexion: conexion).filter({$0.consultation_id == consultaGeneral.id});
            if (lesiones.count > 0) {
                for lesion in lesiones {
                    MemoriaHistoriaClinica.lesiones.append(lesion);
                    let imagesInjuries = FachadaDependientesSQL.seleccionarTodoImagenLesiones(conexion: conexion).filter({$0.injury_id == lesion.id});
                    if (imagesInjuries.count > 0) {
                        for imagen in imagesInjuries {
                            MemoriaHistoriaClinica.imagenesLesiones.append(imagen);
                        }
                    }
                }
            }
            
            // Selecciona respuesta especialista
            let respuestasEspecialista = FachadaDependientesSQL.seleccionarTodoRespuestaEspecialista(conexion: conexion).filter({$0.consultation_id == consultaGeneral.id});
            if (respuestasEspecialista.count > 0) {
                for respuesta in respuestasEspecialista {
                    MemoriaHistoriaClinica.respuestasEspecialistas.append(respuesta);
                    // Selecciona diagnósticos asociados.
                    let diagnosticos = FachadaDependientesSQL.seleccionarTodoDiagnostico(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                    if (diagnosticos.count > 0) {
                        for diagnostico in diagnosticos {
                            MemoriaHistoriaClinica.diagnosticos.append(diagnostico);
                        }
                    }
                    // Selecciona exámenes solicitados
                    let requestExams = FachadaDependientesSQL.seleccionarTodoExamenSolicitado(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                    if (requestExams.count > 0) {
                        for request in requestExams {
                            MemoriaHistoriaClinica.examenesSolicitados.append(request);
                        }
                    }
                    // Selecciona fórmulas
                    let formulas = FachadaDependientesSQL.seleccionarTodoFormula(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                    if (formulas.count > 0) {
                        for formula in formulas {
                            MemoriaHistoriaClinica.formulas.append(formula);
                        }
                    }
                    // Selecciona mipres
                    let mipres = FachadaDependientesSQL.seleccionarTodoMipres(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                    if (mipres.count > 0) {
                        for mipresItem in mipres {
                            MemoriaHistoriaClinica.mipres.append(mipresItem);
                        }
                    }
                    if let especialista = FachadaDependientesSQL.seleccionarTodoEspecialista(conexion: conexion).first(where: {$0.id == respuesta.specialist_id}) {
                        if (MemoriaHistoriaClinica.especialista.contains(where: {$0.professional_card == especialista.professional_card}) == false) {
                            MemoriaHistoriaClinica.especialista.append(especialista);
                        }
                    }
                }
            }
            
            // Selecciona requerimientos
            let requerimientos = FachadaDependientesSQL.seleccionarTodoRequerimiento(conexion: conexion).filter({$0.consultation_id == consultaGeneral.id});
            if (requerimientos.count > 0) {
                for requerimiento in requerimientos {
                    MemoriaHistoriaClinica.requerimientos.append(requerimiento);
                }
            }
            
            let consultationControls = FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).filter({$0.consultation_id == consultaGeneral.id});
            if (consultationControls.count > 0) {
                for consultationControl in consultationControls {
                    MemoriaHistoriaClinica.consultasMedicas.append(consultationControl);
                    if (consultationControl.doctor_id != nil) {
                        if let doctor = FachadaIndependientesSQL.seleccionarPorIdUsuario(conexion: conexion, idRegistro: consultationControl.doctor_id!) {
                            if (MemoriaHistoriaClinica.medico.contains(where: {$0.professional_card == doctor.professional_card }) == false) {
                                MemoriaHistoriaClinica.medico.append(doctor);
                            }
                        }
                    }
                    
                    if let control = FachadaDependientesSQL.seleccionarTodoControlMedico(conexion: conexion).first(where: {$0.consultation_control_id == consultationControl.id}) {
                        MemoriaHistoriaClinica.controlesMedicos.append(control);
                    }
                    
                    // Selecciona lesiones
                    let lesiones = FachadaDependientesSQL.seleccionarTodoLesiones(conexion: conexion).filter({$0.consultation_control_id == consultationControl.id});
                    if (lesiones.count > 0) {
                        for lesion in lesiones {
                            MemoriaHistoriaClinica.lesiones.append(lesion);
                            let imagesInjuries = FachadaDependientesSQL.seleccionarTodoImagenLesiones(conexion: conexion).filter({$0.injury_id == lesion.id});
                            if (imagesInjuries.count > 0) {
                                for imagen in imagesInjuries {
                                    MemoriaHistoriaClinica.imagenesLesiones.append(imagen);
                                }
                            }
                        }
                    }
                    
                    // Selecciona respuesta especialista
                    let respuestasEspecialista = FachadaDependientesSQL.seleccionarTodoRespuestaEspecialista(conexion: conexion).filter({$0.consultation_control_id == consultationControl.id});
                    if (respuestasEspecialista.count > 0) {
                        for respuesta in respuestasEspecialista {
                            MemoriaHistoriaClinica.respuestasEspecialistas.append(respuesta);
                            // Selecciona diagnósticos asociados.
                            let diagnosticos = FachadaDependientesSQL.seleccionarTodoDiagnostico(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                            if (diagnosticos.count > 0) {
                                for diagnostico in diagnosticos {
                                    MemoriaHistoriaClinica.diagnosticos.append(diagnostico);
                                }
                            }
                            // Selecciona exámenes solicitados
                            let requestExams = FachadaDependientesSQL.seleccionarTodoExamenSolicitado(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                            if (requestExams.count > 0) {
                                for request in requestExams {
                                    MemoriaHistoriaClinica.examenesSolicitados.append(request);
                                }
                            }
                            // Selecciona fórmulas
                            let formulas = FachadaDependientesSQL.seleccionarTodoFormula(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                            if (formulas.count > 0) {
                                for formula in formulas {
                                    MemoriaHistoriaClinica.formulas.append(formula);
                                }
                            }
                            // Selecciona mipres
                            let mipres = FachadaDependientesSQL.seleccionarTodoMipres(conexion: conexion).filter({$0.specialist_response_id == respuesta.id});
                            if (mipres.count > 0) {
                                for mipresItem in mipres {
                                    MemoriaHistoriaClinica.mipres.append(mipresItem);
                                }
                            }
                            if let especialista = FachadaDependientesSQL.seleccionarTodoEspecialista(conexion: conexion).first(where: {$0.id == respuesta.specialist_id}) {
                                if (MemoriaHistoriaClinica.especialista.contains(where: {$0.professional_card == especialista.professional_card}) == false) {
                                    MemoriaHistoriaClinica.especialista.append(especialista);
                                }
                            }
                        }
                    }
                }
            }
        }
        self.ordenarConsultas();
        self.iniciarHistoriaClinica();
        self.loading.stopAnimating();
    }
    
    /**
     Permite ordenar las consultas médicas asociadas a cada paciente.
     */
    private func ordenarConsultas () {
        if (MemoriaHistoriaClinica.consultasMedicas.count > 0) {
            // Se ordenan las consultas mayor a menor
            let sortedConsultas = MemoriaHistoriaClinica.consultasMedicas.sorted {$0.id! > $1.id!};
            MemoriaHistoriaClinica.consultasMedicas = sortedConsultas;
            
            // Se ordenan los controles
            if (MemoriaHistoriaClinica.controlesMedicos.count > 0) {
                let sortedControl = MemoriaHistoriaClinica.controlesMedicos.sorted {$0.id! > $1.id!};
                MemoriaHistoriaClinica.controlesMedicos = sortedControl;
            }
            
            // Se ordenan las lesiones de la consulta padre
            if (MemoriaHistoriaClinica.lesiones.count > 0) {
                let sortedLesion = MemoriaHistoriaClinica.lesiones.sorted {$0.id! > $1.id!};
                MemoriaHistoriaClinica.lesiones = sortedLesion;
            }
            
            // Se ordenan las imágenes de lesiones de la consulta padre
            if (MemoriaHistoriaClinica.imagenesLesiones.count > 0) {
                let sortedLesion = MemoriaHistoriaClinica.imagenesLesiones.sorted {$0.id! > $1.id!};
                MemoriaHistoriaClinica.imagenesLesiones = sortedLesion;
            }
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionHistoriaClinica(_ sender: UIButton) {
        self.desactivarBotones();
        self.btnHistoriaClinica.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        self.iniciarHistoriaClinica();
    }
    @IBAction func accionImagenes(_ sender: UIButton) {
        self.desactivarBotones();
        self.btnImagenes.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        self.iniciarImagenes();
    }
    @IBAction func accionRespuesta(_ sender: UIButton) {
        self.desactivarBotones();
        self.btnRespuesta.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        self.iniciarRespuesta();
    }
    @IBAction func accionHistorial(_ sender: UIButton) {
        self.desactivarBotones();
        self.btnHistorial.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        self.iniciarHistorial();
    }
    @IBAction func accionControlMedico(_ sender: UIButton) {
        MemoriaRegistroConsulta.reiniciarVariables();
        RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar = false;
        MemoriaRegistroConsulta.estaControlMedicoActivo = true;
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_control_medico") as! ControlMedicoViewController;
        vc.consultaId = self.consultaId;
        self.present(vc, animated: true, completion: nil);
    }
    
}
