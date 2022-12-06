//
//  InternoRespuestaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 2/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Presentr
import WebKit

class InternoRespuestaViewController: UIViewController {
    
    // Elementos individuales
    @IBOutlet weak var btnControles: UIButton!
    @IBOutlet weak var lblNombreEspecialista: UILabel!
    @IBOutlet weak var lblTarjetaProfesional: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblAnalisisLesion: UILabel!
    @IBOutlet weak var lblDiagnosticoPrincipal: UILabel!
    @IBOutlet weak var lblMotivoRemision: UILabel!
    @IBOutlet weak var lblComentarios: UILabel!
    @IBOutlet weak var lblAnalisisCaso: UILabel!
    @IBOutlet weak var lblProximoControl: UILabel!
    @IBOutlet weak var imgEspecialista: UIImageView!
    @IBOutlet weak var btnEspecialista: UIButton!
    @IBOutlet weak var lblRecomendaciones: UILabel!
    @IBOutlet weak var btnVerMipres: UIButton!
    @IBOutlet weak var btnCompartirMipres: UIButton!
    
    // Vistas
    @IBOutlet weak var vistaAnalisisLesion: UIView!
    @IBOutlet weak var vistaDiagnosticoPrincipal: UIView!
    @IBOutlet weak var vistaMotivoRemision: UIView!
    @IBOutlet weak var vistaComentarios: UIView!
    @IBOutlet weak var vistaAnalisisCaso: UIView!
    @IBOutlet weak var vistaProximoControl: UIView!
    @IBOutlet weak var vistaRequerimientos: UIView!
    @IBOutlet weak var vistaNotas: UIView!
    @IBOutlet weak var vistaRecomendaciones: UIView!
    @IBOutlet weak var vistaRequerimientoContenido: UIView!
    @IBOutlet weak var vistaNotaEspecialista: UIView!
    @IBOutlet weak var vistaSolicitudExamenes: UIView!
    @IBOutlet weak var vistaSolicitudExamenesContenido: UIView!
    @IBOutlet weak var vistaFormulacion: UIView!
    @IBOutlet weak var vistaFormulacionContenido: UIView!
    @IBOutlet weak var vistaMipres: UIView!
    
    // Altos de los elementos que se ocultan
    @IBOutlet weak var altoAnalisisLesion: NSLayoutConstraint!
    @IBOutlet weak var altoDiagnosticoPrincipal: NSLayoutConstraint!
    @IBOutlet weak var altoMotivoRemision: NSLayoutConstraint!
    @IBOutlet weak var altoComentarios: NSLayoutConstraint!
    @IBOutlet weak var altoAnalisisCaso: NSLayoutConstraint!
    @IBOutlet weak var altoProximoControl: NSLayoutConstraint!
    @IBOutlet weak var altoRequerimientos: NSLayoutConstraint!
    @IBOutlet weak var altoNotas: NSLayoutConstraint!
    @IBOutlet weak var altoRecomendaciones: NSLayoutConstraint!
    @IBOutlet weak var altoContenidoRequerimientos: NSLayoutConstraint!
    @IBOutlet weak var altoSolicitudExamenes: NSLayoutConstraint!
    @IBOutlet weak var altoContenidoSolicitudExamenes: NSLayoutConstraint!
    @IBOutlet weak var altoFormulacion: NSLayoutConstraint!
    @IBOutlet weak var altoContenidoFormulacion: NSLayoutConstraint!
    @IBOutlet weak var altoMipres: NSLayoutConstraint!
    
    
    // Variables para almacenar alto inicial.
    var analisisLesionHeight: CGFloat!;
    var diagnosticoPrincipalHeight: CGFloat!;
    var motivoRemisionHeight: CGFloat!;
    var comentariosHeight: CGFloat!;
    var analisisCasoHeight: CGFloat!;
    var proximoControlHeight: CGFloat!;
    var requerimientosHeight: CGFloat!;
    var notasHeight: CGFloat!;
    var recomendacionesHeight: CGFloat!;
    var solicitudExamenesHeight: CGFloat!;
    var formulacionHeight: CGFloat!;
    var mipresHeight: CGFloat!;
    
    // Variables para gestionar la información
    var consulta: ConsultaMedica!;
    var listaControles = [ControlMedico]();
    var listaRazones = [ConstanteValor]();
    
    // Base de datos interna
    let conexion = Conexion();
    
    // Descarga de imágenes
    let imagenCargando = UIImage(named: "cargando");
    let fileManager = FileManager.default;
    var imagenRespuesta: ImagenLesion?;
    
    let presenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.20)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .darkGray
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajuste de estilos
        self.btnControles.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnControles.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnControles.layer.borderColor = Constantes.BORDE_COLOR;
        
        self.vistaAnalisisLesion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaDiagnosticoPrincipal.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaMotivoRemision.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaComentarios.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaAnalisisCaso.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaRequerimientos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaNotas.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaProximoControl.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaRecomendaciones.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.imgEspecialista.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnEspecialista.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaNotaEspecialista.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnVerMipres.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCompartirMipres.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaFormulacion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaMipres.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaSolicitudExamenes.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.motivoRemisionHeight = self.altoMotivoRemision.constant;
        self.comentariosHeight = self.altoComentarios.constant;
        self.analisisLesionHeight = self.altoAnalisisLesion.constant;
        self.diagnosticoPrincipalHeight = self.altoDiagnosticoPrincipal.constant;
        self.analisisCasoHeight = self.altoAnalisisCaso.constant;
        self.proximoControlHeight = self.altoProximoControl.constant;
        self.notasHeight = self.altoNotas.constant;
        self.recomendacionesHeight = self.altoRecomendaciones.constant;
        self.mipresHeight = self.altoMipres.constant;
        
        // Se asigna la posición del control seleccionado.
        self.btnControles.tag = MemoriaHistoriaClinica.posicionControlActivo;
        
        self.ocultarSecciones();
        
        self.cargarInformacionSelectores();
    }
    
    private func ocultarSecciones () {
        
        self.requerimientosHeight = 65.0;
        self.solicitudExamenesHeight = 65.0;
        self.formulacionHeight = 65.0;
        self.altoRequerimientos.constant = 0;
        self.altoSolicitudExamenes.constant = 0;
        self.altoFormulacion.constant = 0;
        
        // Pendiente
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaAnalisisCaso, altoInicial: self.altoAnalisisCaso, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaProximoControl, altoInicial: self.altoProximoControl, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaRequerimientos, altoInicial: self.altoRequerimientos, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaNotas, altoInicial: self.altoNotas, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaAnalisisLesion, altoInicial: self.altoAnalisisLesion, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaDiagnosticoPrincipal, altoInicial: self.altoDiagnosticoPrincipal, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaMotivoRemision, altoInicial: self.altoMotivoRemision, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaComentarios, altoInicial: self.altoComentarios, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaRecomendaciones, altoInicial: self.altoRecomendaciones, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaSolicitudExamenes, altoInicial: self.altoSolicitudExamenes, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaFormulacion, altoInicial: self.altoFormulacion, animado: false);
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaMipres, altoInicial: self.altoMipres, animado: false);
        
        // Botón compartir
        self.btnCompartirMipres.isHidden = true;
    }
    
    /**
     Permite consultar en la base de datos, la información que se debe mostrar en las listas desplegables.
     */
    private func cargarInformacionSelectores () {
        // Se carga información de razones
        self.conexion.conectarBaseDatos();
        self.listaRazones = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "reason");
        // Se consulta el ID del médico que ha iniciado sesión.
        let doctorId = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as! Int;
        // Se obtienen las consultas internas por doctor.
        let internas = MemoriaHistoriaClinica.controlesMedicos.filter({$0.consultation_id == self.consulta.id}).filter({$0.doctor_id == doctorId});
        
        if (internas.count > 0) {
            for interna in internas {
                // Ingresa control padre
                //self.listaControles.append(interna);
                
                let control = MemoriaHistoriaClinica.controlesMedicos.filter({$0.consultation_control_id == interna.id});
                if (control.count > 0) {
                    // Ingresa controles hijos
                    self.listaControles += control;
                }
            }
            
            // Se ordena de forma ascendente.
            let sortedControles = self.listaControles.sorted {$0.id! < $1.id!};
            self.listaControles = sortedControles;
        }
        
        // Se declara un objeto por defecto.
        let controlDefault = ControlMedico();
        controlDefault.id = 0;
        controlDefault.created_at = Mensajes.CAMPO_SELECCIONAR;
        
        self.listaControles.insert(controlDefault, at: 0);
        
        if (self.listaControles.count == 1) {
            self.btnControles.isEnabled = false;
        }
        
        // Se valida si el usuario ha seleccionado un control entre las pestañas.
        self.cargarInformacionControl();
    }
    
    /**
     Permite mostrar un modal para la selección de las opciones de tipo de profesional.
     No requiere de parámetros y no retorna.
     */
    private func mostrarPickerSelectores (titulo: String) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200));
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        // si es mayor a cero es que ya ha sido seleccionado y se ubica en el selector.
        if (self.btnControles.tag > 0) {
            pickerView.selectRow(self.btnControles.tag, inComponent: 0, animated: true);
        }
        
        vc.view.addSubview(pickerView);
        
        let opcionesAlert = UIAlertController(title: titulo, message: nil, preferredStyle: UIAlertController.Style.alert);
        opcionesAlert.setValue(vc, forKey: "contentViewController");
        opcionesAlert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil));
        
        self.present(opcionesAlert, animated: true);
    }
    
    private func cargarInformacionControl () {
        
        let control = self.listaControles[self.btnControles.tag];
        let texto = control.created_at!;
        
        Funcionales.ajustarTextoBotonSelector(boton: self.btnControles, texto: texto);
        self.imgEspecialista.image = UIImage(named: "cargando");
        self.ocultarSecciones();
        
        var respuestaEspecialista: RespuestaEspecialista? = nil;
        var especialistaRespuesta: Especialista? = nil;
        
        // Variables para mostrar la información que devuelva el control o la consulta
        var textoAnalisisLesion: String?;
        var textoAnalisisCaso: String?;
        var textoProximoControl: String?;
        var textoRecomendaciones: String?;
        var textoDiagnosticoPrincipal: String?;
        var textoMotivoRemision: String?;
        var textoComentarios: String?;
        var requerimientosFinal = [Requerimiento]();
        var examenesSolicitadosFinal = [ExamenSolicitado]();
        var formulasFinal = [Formula]();
        
        // Se ocultan todas las secciones y me muestran según información disponible.
        self.ocultarSecciones();
        
        if (self.btnControles.tag > 0) {
            let controlSeleccionado = self.listaControles[self.btnControles.tag];
            
            if let respuesta = MemoriaHistoriaClinica.respuestasEspecialistas.first(where: {$0.consultation_control_id == controlSeleccionado.consultation_control_id}) {
                if let especialista = MemoriaHistoriaClinica.especialista.first(where: {$0.id == respuesta.specialist_id}) {
                    respuestaEspecialista = respuesta;
                    especialistaRespuesta = especialista;
                }
            }
            
            // Se valida si hay lesiones con respuesta.
            let lesiones = MemoriaHistoriaClinica.lesiones.filter({$0.consultation_control_id == controlSeleccionado.consultation_control_id});
            if (lesiones.count > 0) {
                for lesion in lesiones {
                    if let imagenLesion = MemoriaHistoriaClinica.imagenesLesiones.first(where: {$0.injury_id == lesion.id && $0.edited_photo != nil}) {
                        imagenRespuesta = imagenLesion;
                        break;
                    }
                }
            }
            
            // Sección y validación de requerimientos asociados a la consulta.
            // Se valida existencia de requerimientos
            if (MemoriaHistoriaClinica.requerimientos.count > 0) {
                requerimientosFinal = MemoriaHistoriaClinica.requerimientos.filter{
                    req in
                    return req.medical_control_id == controlSeleccionado.id
                }
            }
            
            if let controlPadre = MemoriaHistoriaClinica.controlesMedicos.first(where: {$0.id == controlSeleccionado.consultation_control_id}) {
                if let recomendaciones = controlPadre.treatment {
                    textoRecomendaciones = recomendaciones;
                }
            }
            
        } else {
            // Aplica para información de una consulta.
            
            if let respuesta = MemoriaHistoriaClinica.respuestasEspecialistas.first(where: {$0.consultation_id == self.consulta.id}) {
                
                if let especialista = MemoriaHistoriaClinica.especialista.first(where: {$0.id == respuesta.specialist_id}) {
                    
                    respuestaEspecialista = respuesta;
                    especialistaRespuesta = especialista;
                }
            }
            
            // Se valida si hay lesiones con respuesta.
            let lesiones = MemoriaHistoriaClinica.lesiones.filter({$0.consultation_id == consulta.id});
            if (lesiones.count > 0) {
                for lesion in lesiones {
                    if let imagenLesion = MemoriaHistoriaClinica.imagenesLesiones.first(where: {$0.injury_id == lesion.id && $0.edited_photo != nil}) {
                        imagenRespuesta = imagenLesion;
                        break;
                    }
                }
            }
            
            // Sección y validación de requerimientos asociados a la consulta.
            // Se valida existencia de requerimientos
            if (MemoriaHistoriaClinica.requerimientos.count > 0) {
                requerimientosFinal = MemoriaHistoriaClinica.requerimientos.filter{
                    req in
                    return req.consultation_id == self.consulta.id!
                }
            }
            
            if let recomendaciones = consulta.treatment {
                textoRecomendaciones = recomendaciones;
            }
        }
        
        // Se valida la información adicional si la tiene para que muestre.
        
        if let analisisLesion = respuestaEspecialista?.case_analysis {
            textoAnalisisLesion = analisisLesion;
        }
        if let analisisCaso = respuestaEspecialista?.analysis_description {
            textoAnalisisCaso = analisisCaso;
        }
        
        if let proximoControl = respuestaEspecialista?.control_recommended {
            textoProximoControl = proximoControl;
        }
        
        
        if (respuestaEspecialista != nil) {
            
            // Exámenes solicitados
            examenesSolicitadosFinal = MemoriaHistoriaClinica.examenesSolicitados.filter({$0.specialist_response_id == respuestaEspecialista?.id});
            
            // Fórmulas relacionadas
            formulasFinal = MemoriaHistoriaClinica.formulas.filter({$0.specialist_response_id == respuestaEspecialista?.id});
            
            // Mipres
            if let mipres = MemoriaHistoriaClinica.mipres.first(where: {$0.specialist_response_id == respuestaEspecialista?.id}) {
                self.btnVerMipres.tag = mipres.id!;
                self.btnCompartirMipres.tag = mipres.id!;
                
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaMipres, altoInicial: self.altoMipres, altoAuxiliar: self.mipresHeight, animado: true);
            }
            
            // Diagnósticos
            let diagnosticos = MemoriaHistoriaClinica.diagnosticos.filter({$0.specialist_response_id == respuestaEspecialista!.id});
            var textoDiagnosticos = "";
            if (diagnosticos.count > 0) {
                for (indice, diagnostico) in diagnosticos.enumerated() {
                    textoDiagnosticos += "\((indice + 1).description). \(diagnostico.disease ?? "")\n";
                    textoDiagnosticos += "\((indice + 2).description). \(diagnostico.type_diagnostic ?? "")\n";
                }
                textoDiagnosticoPrincipal = textoDiagnosticos;
            }
        }
        
        // Creando la lista de exámenes solicitados.
        if (examenesSolicitadosFinal.count > 0) {
            var contadorExamenes = 0;
            let altoExamen = CGFloat(21.0);
            var totalAltosExamen: CGFloat = 0;
            
            for examenSolicitado in examenesSolicitadosFinal {
                let posicionExamen = totalAltosExamen;
                let frameExamenSolicitado = CGRect(x: 0, y: posicionExamen, width: self.vistaSolicitudExamenesContenido.frame.width, height: altoExamen);
                // Se pinta el examen
                let labelExamen = UILabel(frame: frameExamenSolicitado);
                labelExamen.text = examenSolicitado.name_type_exam;
                labelExamen.textColor = UIColor.darkGray;
                labelExamen.adjustsFontSizeToFitWidth = true;
                
                // Se añade la nueva vista
                self.vistaSolicitudExamenesContenido.addSubview(labelExamen);
                
                contadorExamenes += 1;
                if (contadorExamenes <= examenesSolicitadosFinal.count) {
                    totalAltosExamen += altoExamen + 8;
                }
            }
            // Se muestra la vista de requerimientos con la información cargada.
            self.altoContenidoSolicitudExamenes.constant = totalAltosExamen;
            self.solicitudExamenesHeight = self.solicitudExamenesHeight + self.altoContenidoSolicitudExamenes.constant;
            
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaSolicitudExamenes, altoInicial: self.altoSolicitudExamenes, altoAuxiliar: self.solicitudExamenesHeight, animado: true);
        }
        
        // Creando la lista de fórmulas.
        if (formulasFinal.count > 0) {
            var contadorFormulas = 0;
            let altoFormula = CGFloat(50.0);
            var totalAltosFormulas: CGFloat = 0;
            
            for formula in formulasFinal {
                let posicionFormula = totalAltosFormulas;
                let frameFormula = CGRect(x: 0, y: posicionFormula, width: self.vistaFormulacionContenido.frame.width, height: altoFormula);
                // Se pinta el botón para ver el detalle de cada fórmula
                let btnVerFormula = UIButton(frame: frameFormula);
                btnVerFormula.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
                btnVerFormula.setTitleColor(.white, for: .normal);
                btnVerFormula.setTitle("Ver Fórmula \(contadorFormulas + 1)", for: .normal);
                btnVerFormula.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
                btnVerFormula.tag = formula.id!;
                btnVerFormula.addTarget(self, action: #selector(self.accionVerFormula(_:)), for: .touchUpInside);
                
                // Se añade la nueva vista
                self.vistaFormulacionContenido.addSubview(btnVerFormula);
                
                contadorFormulas += 1;
                if (contadorFormulas <= formulasFinal.count) {
                    totalAltosFormulas += altoFormula + 8;
                }
            }
            // Se muestra la vista de requerimientos con la información cargada.
            self.altoContenidoFormulacion.constant = totalAltosFormulas;
            self.formulacionHeight = self.formulacionHeight + self.altoContenidoFormulacion.constant;
            
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaFormulacion, altoInicial: self.altoFormulacion, altoAuxiliar: self.formulacionHeight, animado: true);
        }
        
        if (requerimientosFinal.count > 0) {
            var contadorRequerimientos = 0;
            let altoNumeral = CGFloat(21);
            let altoSeparador = CGFloat(1.0);
            let altoMedicoLabel = CGFloat(21.0);
            let altoMedico = CGFloat(21.0);
            let altoTarjetaProfesionalLabel = CGFloat(21.0);
            let altoTarjetaProfesional = CGFloat(21.0);
            let altoFechaLabel = CGFloat(21.0);
            let altoFecha = CGFloat(21.0);
            let altoDescripcionLabel = CGFloat(21.0);
            let altoDescripcion = CGFloat(70.0);
            let altoComentariosLabel = CGFloat(21.0);
            let altoComentarios = CGFloat(70.0);
            let altoBotonDescartar = CGFloat(50.0);
            let altoBotonResolver = CGFloat(50.0);
            let altoRequerimientoDescartadoLabel = CGFloat(21.0);
            let altoRequerimientoDescartado = CGFloat(21.0);
            let altoRequerimientoDescartadoOtraRazonLabel = CGFloat(21.0);
            let altoRequerimientoDescartadoOtraRazon = CGFloat(21.0);
            
            var totalAltos: CGFloat = 0;
            
            for requerimiento in requerimientosFinal {
                // Datos relacionados
                let medico = MemoriaHistoriaClinica.especialista.first(where: {$0.id == requerimiento.specialist_id})
                
                let posicionNumeralY = totalAltos;
                let posicionSeparadorY = posicionNumeralY + altoNumeral;
                let posicionMedicoLabelY = posicionSeparadorY + altoSeparador + 10;
                let posicionMedicoY = posicionMedicoLabelY + altoMedicoLabel + 5;
                let posicionTarjetaProfesionalLabelY = posicionMedicoY + altoMedico + 10;
                let posicionTarjetaProfesionalY = posicionTarjetaProfesionalLabelY + altoTarjetaProfesionalLabel + 5;
                let posicionFechaLabelY = posicionTarjetaProfesionalY + altoTarjetaProfesional + 10;
                let posicionFechaY = posicionFechaLabelY + altoFechaLabel + 5;
                let posicionDescripcionLabelY = posicionFechaY + altoFecha + 10;
                let posicionDescripcionY = posicionDescripcionLabelY + altoDescripcionLabel + 5;
                let posicionComentariosLabelY = posicionDescripcionY + altoDescripcion + 10;
                let posicionComentariosY = posicionComentariosLabelY + altoComentariosLabel + 5;
                let posicionRequerimientoDescartadoLabelY = posicionComentariosY + altoComentarios + 10;
                let posicionRequerimientoDescartadoY = posicionRequerimientoDescartadoLabelY + altoRequerimientoDescartadoLabel + 5;
                let posicionRequerimientoDescartadoOtraRazonLabelY = posicionRequerimientoDescartadoY + altoRequerimientoDescartado + 10;
                let posicionRequerimientoDescartadoOtraRazonY = posicionRequerimientoDescartadoOtraRazonLabelY + altoRequerimientoDescartadoOtraRazonLabel + 5;
                
                // Los botones irán después de los comentarios.
                let posicionBotonDescartarY = posicionComentariosY + altoComentarios + 5;
                let posicionBotonResolverY = posicionBotonDescartarY + altoBotonDescartar + 5;
                
                let frameNumeral = CGRect(x: 0, y: posicionNumeralY, width: self.vistaRequerimientoContenido.frame.width, height: altoNumeral);
                let frameSeparador = CGRect(x: 0, y: posicionSeparadorY, width: self.vistaRequerimientoContenido.frame.width, height: altoSeparador);
                let frameMedicoLabel = CGRect(x: 0, y: posicionMedicoLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoMedicoLabel);
                let frameMedico = CGRect(x: 0, y: posicionMedicoY, width: self.vistaRequerimientoContenido.frame.width, height: altoMedico);
                let frameTarjetaProfesionalLabel = CGRect(x: 0, y: posicionTarjetaProfesionalLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoTarjetaProfesionalLabel);
                let frameTarjetaProfesional = CGRect(x: 0, y: posicionTarjetaProfesionalY, width: self.vistaRequerimientoContenido.frame.width, height: altoTarjetaProfesional);
                let frameFechaLabel = CGRect(x: 0, y: posicionFechaLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoFechaLabel);
                let frameFecha = CGRect(x: 0, y: posicionFechaY, width: self.vistaRequerimientoContenido.frame.width, height: altoFecha);
                let frameDescripcionLabel = CGRect(x: 0, y: posicionDescripcionLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoDescripcionLabel);
                let frameDescripcion = CGRect(x: 0, y: posicionDescripcionY, width: self.vistaRequerimientoContenido.frame.width, height: altoDescripcion);
                let frameComentariosLabel = CGRect(x: 0, y: posicionComentariosLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoComentariosLabel);
                let frameComentarios = CGRect(x: 0, y: posicionComentariosY, width: self.vistaRequerimientoContenido.frame.width, height: altoComentarios);
                
                let frameRequerimientoDescartadoLabel = CGRect(x: 0, y: posicionRequerimientoDescartadoLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoRequerimientoDescartadoLabel);
                let frameRequerimientoDescartado = CGRect(x: 0, y: posicionRequerimientoDescartadoY, width: self.vistaRequerimientoContenido.frame.width, height: altoRequerimientoDescartado);
                let frameRequerimientoDescartadoOtraRazonLabel = CGRect(x: 0, y: posicionRequerimientoDescartadoOtraRazonLabelY, width: self.vistaRequerimientoContenido.frame.width, height: altoRequerimientoDescartadoOtraRazonLabel);
                let frameRequerimientoDescartadoOtraRazon = CGRect(x: 0, y: posicionRequerimientoDescartadoOtraRazonY, width: self.vistaRequerimientoContenido.frame.width, height: altoRequerimientoDescartadoOtraRazon);
                
                let frameBotonDescartar = CGRect(x: 0, y: posicionBotonDescartarY, width: self.vistaRequerimientoContenido.frame.width, height: altoBotonDescartar);
                let frameBotonResolver = CGRect(x: 0, y: posicionBotonResolverY, width: self.vistaRequerimientoContenido.frame.width, height: altoBotonResolver);
                
                // Se pinta el numeral
                let labelNumeral = UILabel(frame: frameNumeral);
                labelNumeral.text = "# \(contadorRequerimientos + 1)";
                labelNumeral.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                
                // Se agrega separador
                let separador = UIView(frame: frameSeparador);
                separador.layer.borderWidth = 1.0;
                separador.layer.borderColor = UIColor.darkGray.cgColor;
                
                // Se agrega información del médico
                let labelMedicoTitulo = UILabel(frame: frameMedicoLabel);
                labelMedicoTitulo.text = "Médico:";
                labelMedicoTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                
                let labelMedico = UILabel(frame: frameMedico);
                labelMedico.text = "\(medico?.name ?? "") \(medico?.surnames ?? "")";
                labelMedico.adjustsFontSizeToFitWidth = true;
                labelMedico.textColor = UIColor.darkGray;
                
                let labelTarjetaProfesionalTitulo = UILabel(frame: frameTarjetaProfesionalLabel);
                labelTarjetaProfesionalTitulo.text = "Tarjeta profesional:";
                labelTarjetaProfesionalTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                
                let labelTarjetaProfesional = UILabel(frame: frameTarjetaProfesional);
                labelTarjetaProfesional.text = medico?.professional_card;
                labelTarjetaProfesional.adjustsFontSizeToFitWidth = true;
                labelTarjetaProfesional.textColor = UIColor.darkGray;
                
                // Datos del requerimiento
                
                let labelFechaTitulo = UILabel(frame: frameFechaLabel);
                labelFechaTitulo.text = "Fecha:";
                labelFechaTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                
                let labelFecha = UILabel(frame: frameFecha);
                labelFecha.text = requerimiento.created_at;
                labelFecha.adjustsFontSizeToFitWidth = true;
                labelFecha.textColor = UIColor.darkGray;
                
                let labelDescripcionTitulo = UILabel(frame: frameDescripcionLabel);
                labelDescripcionTitulo.text = "Tipo de requerimiento:";
                labelDescripcionTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                
                let labelDescripcion = UITextView(frame: frameDescripcion)
                labelDescripcion.text = requerimiento.type_request;
                labelDescripcion.textColor = UIColor.darkGray;
                labelDescripcion.textAlignment = .natural;
                labelDescripcion.backgroundColor = .none;
                
                let labelComentariosTitulo = UILabel(frame: frameComentariosLabel);
                labelComentariosTitulo.text = "Comentarios:";
                labelComentariosTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                
                let labelComentarios = UITextView(frame: frameComentarios)
                labelComentarios.text = requerimiento.comment;
                labelComentarios.textColor = UIColor.darkGray;
                labelComentarios.textAlignment = .natural;
                labelComentarios.backgroundColor = .none;
                
                
                // Se añade la nueva vista
                self.vistaRequerimientoContenido.addSubview(labelNumeral);
                self.vistaRequerimientoContenido.addSubview(separador);
                self.vistaRequerimientoContenido.addSubview(labelMedicoTitulo);
                self.vistaRequerimientoContenido.addSubview(labelMedico);
                self.vistaRequerimientoContenido.addSubview(labelTarjetaProfesionalTitulo);
                self.vistaRequerimientoContenido.addSubview(labelTarjetaProfesional);
                self.vistaRequerimientoContenido.addSubview(labelFechaTitulo);
                self.vistaRequerimientoContenido.addSubview(labelFecha);
                self.vistaRequerimientoContenido.addSubview(labelDescripcionTitulo);
                self.vistaRequerimientoContenido.addSubview(labelDescripcion);
                self.vistaRequerimientoContenido.addSubview(labelComentariosTitulo);
                self.vistaRequerimientoContenido.addSubview(labelComentarios);
                
                if (requerimiento.reason == nil) {
                    let botonDescartar = UIButton(frame: frameBotonDescartar);
                    botonDescartar.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
                    botonDescartar.setTitleColor(.white, for: .normal);
                    botonDescartar.setTitle("Descartar", for: .normal);
                    botonDescartar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
                    botonDescartar.tag = requerimiento.id!;
                    botonDescartar.addTarget(self, action: #selector(self.descartarRequerimiento(sender:)), for: .touchUpInside);
                    
                    let botonResolver = UIButton(frame: frameBotonResolver);
                    botonResolver.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
                    botonResolver.setTitleColor(.white, for: .normal);
                    botonResolver.setTitle("Resolver", for: .normal);
                    botonResolver.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
                    botonResolver.tag = requerimiento.id!;
                    botonResolver.addTarget(self, action: #selector(self.resolverRequerimiento(sender:)), for: .touchUpInside);
                    
                    self.vistaRequerimientoContenido.addSubview(botonResolver);
                    self.vistaRequerimientoContenido.addSubview(botonDescartar);
                    
                } else {
                    let labelRequerimientoDescartadoTitulo = UILabel(frame: frameRequerimientoDescartadoLabel);
                    labelRequerimientoDescartadoTitulo.text = "Requerimiento descartado:";
                    labelRequerimientoDescartadoTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                    
                    let razonDescartado = self.listaRazones.first(where: {$0.value == requerimiento.reason});
                    let labelRequerimientoDescartado = UITextView(frame: frameRequerimientoDescartado)
                    labelRequerimientoDescartado.text = razonDescartado?.title;
                    labelRequerimientoDescartado.textColor = UIColor.darkGray;
                    labelRequerimientoDescartado.textAlignment = .natural;
                    labelRequerimientoDescartado.backgroundColor = .none;
                    
                    let labelRequerimientoDescartadoOtraRazonTitulo = UILabel(frame: frameRequerimientoDescartadoOtraRazonLabel);
                    labelRequerimientoDescartadoOtraRazonTitulo.text = "Requerimiento descartado otra razón:";
                    labelRequerimientoDescartadoOtraRazonTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                    
                    let labelRequerimientoDescartadoOtraRazon = UITextView(frame: frameRequerimientoDescartadoOtraRazon)
                    labelRequerimientoDescartadoOtraRazon.text = requerimiento.other_reason;
                    labelRequerimientoDescartadoOtraRazon.textColor = UIColor.darkGray;
                    labelRequerimientoDescartadoOtraRazon.textAlignment = .natural;
                    labelRequerimientoDescartadoOtraRazon.backgroundColor = .none;
                    
                    self.vistaRequerimientoContenido.addSubview(labelRequerimientoDescartadoTitulo);
                    self.vistaRequerimientoContenido.addSubview(labelRequerimientoDescartado);
                    
                    self.vistaRequerimientoContenido.addSubview(labelRequerimientoDescartadoOtraRazonTitulo);
                    self.vistaRequerimientoContenido.addSubview(labelRequerimientoDescartadoOtraRazon);
                }
                contadorRequerimientos += 1;
                
                if (contadorRequerimientos <= requerimientosFinal.count) {
                    // 80 porque son 8 elementos para mostrar
                    totalAltos += altoNumeral + altoSeparador + altoMedicoLabel + altoMedico + altoTarjetaProfesionalLabel + altoTarjetaProfesional + altoFechaLabel + altoFecha + altoDescripcionLabel + altoDescripcion + altoComentariosLabel + altoComentarios + 75;
                    
                    if (requerimiento.reason == nil) {
                        totalAltos += altoBotonResolver + altoBotonDescartar;
                    } else {
                        totalAltos += altoRequerimientoDescartadoLabel + altoRequerimientoDescartado + altoRequerimientoDescartadoOtraRazonLabel + altoRequerimientoDescartadoOtraRazon + 25;
                    }
                }
            }
            // Se muestra la vista de requerimientos con la información cargada.
            self.altoContenidoRequerimientos.constant = totalAltos;
            self.requerimientosHeight = self.requerimientosHeight + self.altoContenidoRequerimientos.constant;
            
            self.mostrarOcultarRequerimientos(mostrar: true);
            
        }
        
        
        if let motivoRemision = self.consulta.type_remission {
            textoMotivoRemision = motivoRemision;
        }
        if let comentarios = self.consulta.remission_comments {
            textoComentarios = comentarios;
        }
        
        /*if let consultaPadreControl = MemoriaHistoriaClinica.consultasMedicas.first(where: {$0.id == controlSeleccionado.consultation_control_id}) {
         // Sólo para controles.
         textoMotivoRemision = consultaPadreControl.type_remission;
         textoComentarios = consultaPadreControl.remission_comments;
         }*/
        
        if (textoMotivoRemision != nil) {
            self.lblMotivoRemision.text = textoMotivoRemision;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaMotivoRemision, altoInicial: self.altoMotivoRemision, altoAuxiliar: self.motivoRemisionHeight, animado: true);
        }
        if (textoComentarios != nil) {
            self.lblComentarios.text = textoComentarios;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaComentarios, altoInicial: self.altoComentarios, altoAuxiliar: self.comentariosHeight, animado: true);
        }
        if (textoAnalisisLesion != nil) {
            self.lblAnalisisLesion.text = textoAnalisisLesion;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaAnalisisLesion, altoInicial: self.altoAnalisisLesion, altoAuxiliar: self.analisisLesionHeight, animado: true);
        }
        if (textoAnalisisCaso != nil) {
            self.lblAnalisisCaso.text = textoAnalisisCaso;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaAnalisisCaso, altoInicial: self.altoAnalisisCaso, altoAuxiliar: self.analisisCasoHeight, animado: true);
        }
        if (textoProximoControl != nil) {
            self.lblProximoControl.text = textoProximoControl;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaProximoControl, altoInicial: self.altoProximoControl, altoAuxiliar: self.proximoControlHeight, animado: true);
        }
        if (textoRecomendaciones != nil) {
            self.lblRecomendaciones.text = textoRecomendaciones;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaRecomendaciones, altoInicial: self.altoRecomendaciones, altoAuxiliar: self.recomendacionesHeight, animado: true);
        }
        if (textoDiagnosticoPrincipal != nil) {
            self.lblDiagnosticoPrincipal.text = textoDiagnosticoPrincipal;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaDiagnosticoPrincipal, altoInicial: self.altoDiagnosticoPrincipal, altoAuxiliar: self.diagnosticoPrincipalHeight, animado: true);
        }
        if (imagenRespuesta != nil) {
            self.descargarImagenNota(imagenNota: imagenRespuesta!);
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaNotas, altoInicial: self.altoNotas, altoAuxiliar: self.notasHeight, animado: true);
        }
        if (respuestaEspecialista != nil && especialistaRespuesta != nil) {
            self.lblNombreEspecialista.text = "\(especialistaRespuesta!.name ?? "") \(especialistaRespuesta!.surnames ?? "")";
            self.lblTarjetaProfesional.text = especialistaRespuesta!.professional_card;
            self.lblFecha.text = "\(respuestaEspecialista!.created_at ?? "") - \(respuestaEspecialista!.hour ?? "")";
        }
    }
    
    /**
     Permite descargar las imágenes de notas de la respuesta de consulta o controles y actualizar la vista de la colección.
     - Parameter imagenUrl: Corresponde a la url desde donde se descarga la imagen.
     - Parameter nombre: Corresponde al texto del nombre con el cual se guarda la imagen en el dispositivo.
     - Parameter padre: Corresponde a la imagen lesión padre a la cual pertenece.
     */
    private func descargarImagenNota (imagenNota: ImagenLesion) {
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = Funcionales.descargarImagenSincrono(imagenUrl: imagenNota.edited_photo!);
            DispatchQueue.main.async(execute: {
                switch (resultado.result) {
                case let .success(image):
                    self.imgEspecialista.image = image;
                    break;
                    
                case let .failure(error):
                    print(error);
                    self.imgEspecialista.image = UIImage(named: "error_cargar");
                    break;
                }
            });
        });
    }
    
    /**
     Permite mostrar u ocultar la vista de requerimientos.
     - Parameter mostrar: Corresponde a un valor booleano para saber si se muestra (TRUE) o no (FALSE).
     */
    private func mostrarOcultarRequerimientos (mostrar: Bool) {
        if (mostrar) {
            //self.lblTituloRequerimientos.isHidden = false;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaRequerimientos, altoInicial: self.altoRequerimientos, altoAuxiliar: self.requerimientosHeight, animado: false);
        } else {
            //self.lblTituloRequerimientos.isHidden = true;
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaRequerimientos, altoInicial: self.altoRequerimientos, animado: false);
        }
    }
    
    /**
     Permite descartar un requerimiento específico.
     El ID del requerimiento se encuentra en la propiedad TAG.
     */
    @objc func descartarRequerimiento (sender: UIButton) {        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_custom_requerimiento_descartar") as! CustomRequerimientoDescartarViewController;
        vc.requerimientoId = sender.tag;
        
        presenter.presentationType = .popup;
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil);
    }
    
    /**
     Permite resolver un requerimiento específico.
     El ID del requerimiento se encuentra en la propiedad TAG.
     */
    @objc func resolverRequerimiento (sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_custom_requerimiento_resolver") as! CustomRequerimientoResolverViewController;
        vc.requerimiento = MemoriaHistoriaClinica.requerimientos.first(where: {$0.id == sender.tag});
        
        presenter.presentationType = .popup;
        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionVerNota(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_imagen_historia_clinica") as! ImagenHistoriaClinicaViewController;
        
        vc.imagenPrincipal = self.imgEspecialista.image;
        vc.listaImagenesPadre = [1 : self.imgEspecialista.image!];
        vc.listaImagenesHijas = [:];
        vc.orden = [1];
        vc.comentariosRespuesta = self.imagenRespuesta?.descriptions;
        
        self.present(vc, animated: true, completion: nil);
    }
    
    @objc func accionVerFormula(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_formula") as! FormulaViewController;
        if let formula = MemoriaHistoriaClinica.formulas.first(where: {$0.id == sender.tag}) {
            vc.codigoMedicamento = formula.medication_code;
            vc.tipoMedicamento = formula.type_medicament;
            vc.nombreGenerico = formula.generic_name_medicament;
            vc.formaFarmaceutica = formula.pharmaceutical_form;
            vc.concentracionMedicamento = formula.drug_concentration;
            vc.unidadMedida = formula.unit_measure_medication;
            vc.numeroUnidades = formula.number_of_units;
            vc.descripcion = formula.commentations;
            
            presenter.presentationType = .popup;
            customPresentViewController(presenter, viewController: vc, animated: true, completion: nil);
        }
    }
    
    @IBAction func accionControl(_ sender: UIButton) {
        self.mostrarPickerSelectores(titulo: Mensajes.SELECCIONAR_CONTROL);
    }
    
    @IBAction func accionVerMipres(_ sender: UIButton) {
        if (Funcionales.dispositivoEstaConectado) {
            if (sender.tag > 0) {
                if let mipres = MemoriaHistoriaClinica.mipres.first(where: {$0.id == sender.tag}) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_web") as! WebViewController;
                    vc.url = mipres.mipres;
                    vc.titulo = "Mipres";
                    
                    self.present(vc, animated: true, completion: nil);
                } else {
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: "No se puede cargar Mipres");
                }
            }
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_INTERNET);
        }
    }
    
    @IBAction func accionCompartirMipres(_ sender: UIButton) {
    }
}

extension InternoRespuestaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listaControles.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listaControles[row].created_at;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.btnControles.tag = row;
        MemoriaHistoriaClinica.posicionControlActivo = row;
        self.cargarInformacionControl();
    }
    
}
