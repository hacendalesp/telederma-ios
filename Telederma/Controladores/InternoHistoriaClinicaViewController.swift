//
//  InternoHistoriaClinicaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 1/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class InternoHistoriaClinicaViewController: UIViewController {
    
    // Elementos individuales
    @IBOutlet weak var lblNombrePaciente: UILabel!
    @IBOutlet weak var lblEdadPaciente: UILabel!
    @IBOutlet weak var lblDocumentoPaciente: UILabel!
    @IBOutlet weak var btnVerMas: UIButton!
    
    @IBOutlet weak var btnControles: UIButton!
    @IBOutlet weak var lblControlNombreMedico: UILabel!
    @IBOutlet weak var lblControlTarjetaProfesional: UILabel!
    @IBOutlet weak var lblControlFecha: UILabel!
    @IBOutlet weak var lblControlMejoraSubjetiva: UILabel!
    @IBOutlet weak var lblControlTratamientoIndicaciones: UILabel!
    @IBOutlet weak var lblControlToleraMedicamentos: UILabel!
    @IBOutlet weak var lblControlExamenFisico: UILabel!
    @IBOutlet weak var lblControlAnexos: UILabel!
    
    @IBOutlet weak var lblHistoriaNombreMedico: UILabel!
    @IBOutlet weak var lblHistoriaTarjetaProfesional: UILabel!
    @IBOutlet weak var lblHistoriaFecha: UILabel!
    @IBOutlet weak var lblHistoriaPeso: UILabel!
    @IBOutlet weak var lblHistoriaTiempoEvolucion: UILabel!
    @IBOutlet weak var lblHistoriaNumeroLesiones: UILabel!
    @IBOutlet weak var lblHistoriaEvolucionLesiones: UILabel!
    @IBOutlet weak var lblHistoriaSangran: UILabel!
    @IBOutlet weak var lblHistoriaExudan: UILabel!
    @IBOutlet weak var lblHistoriaSupuran: UILabel!
    @IBOutlet weak var lblHistoriaSintomas: UILabel!
    @IBOutlet weak var lblHistoriaSintomasCambian: UILabel!
    @IBOutlet weak var lblHistoriaOtrosFactores: UILabel!
    @IBOutlet weak var lblHistoriaAntecedentesPersonales: UILabel!
    @IBOutlet weak var lblHistoriaAntecedentesFamiliares: UILabel!
    @IBOutlet weak var lblHistoriaTratamiento: UILabel!
    @IBOutlet weak var lblHistoriaOtrasSustancias: UILabel!
    @IBOutlet weak var lblHistoriaEfectosTratamiento: UILabel!
    @IBOutlet weak var lblHistoriaExamenFisico: UILabel!
    @IBOutlet weak var lblHistoriaAnexos: UILabel!
    @IBOutlet weak var lblHistoriaImpresionDiagnostica: UILabel!
    @IBOutlet weak var lblTituloRequerimientos: UILabel!
    
    // Vistas
    @IBOutlet weak var vistaCompletaControl: UIView!
    @IBOutlet weak var vistaControl: UIView!
    @IBOutlet weak var vistaControlMejora: UIView!
    @IBOutlet weak var vistaControlTratamientoIndicaciones: UIView!
    @IBOutlet weak var vistaControlToleraMedicamentos: UIView!
    @IBOutlet weak var vistaControlExamenFisico: UIView!
    @IBOutlet weak var vistaControlAnexos: UIView!
    @IBOutlet weak var vistaControlMedico: UIView!
    
    @IBOutlet weak var vistaHistoriaMedico: UIView!
    @IBOutlet weak var vistaHistoriaPeso: UIView!
    @IBOutlet weak var vistaHistoriaTiempoEvolucion: UIView!
    @IBOutlet weak var vistaHistoriaNumeroLesiones: UIView!
    @IBOutlet weak var vistaHistoriaEvolucionLesiones: UIView!
    @IBOutlet weak var vistaHistoriaCambiosEvidentes: UIView!
    @IBOutlet weak var vistaHistoriaSintomas: UIView!
    @IBOutlet weak var vistaHistoriaSintomasCambianDia: UIView!
    @IBOutlet weak var vistaHistoriaOtrosFactores: UIView!
    @IBOutlet weak var vistaHistoriaAntecedentes: UIView!
    @IBOutlet weak var vistaHistoriaTratamientoRecibido: UIView!
    @IBOutlet weak var vistaHistoriaOtrasSustancias: UIView!
    @IBOutlet weak var vistaHistoriaEfectosTratamiento: UIView!
    @IBOutlet weak var vistaHistoriaExamenFisico: UIView!
    @IBOutlet weak var vistaHistoriaAnexos: UIView!
    @IBOutlet weak var vistaHistoriaImpresionDiagnostica: UIView!
    @IBOutlet weak var vistaRequerimientos: UIView!
    @IBOutlet weak var vistaContenidoRequerimientos: UIView!
    
    // Altos de los elementos a ocultar
    @IBOutlet weak var altoControl: NSLayoutConstraint!
    @IBOutlet weak var altoVistaRequerimientos: NSLayoutConstraint!
    @IBOutlet weak var altoContenidoRequerimientos: NSLayoutConstraint!
    
    // Variables para el almacenamiento en memoria del alto inicial
    var controlHeight: CGFloat!;
    var vistaRequerimientosHeight: CGFloat!;
    
    // Variables para cargar información independiente, desde la base de datos
    var conexion = Conexion();
    // El ID de la consulta general
    var consultaId: Int!;
    var listaUnidadMedida = [ConstanteValor]();
    var listaNumeroLesiones = [ConstanteValor]();
    var listaEvolucionLesiones = [ConstanteValor]();
    var listaSintomas = [ConstanteValor]();
    var listaCambioSintomas = [ConstanteValor]();
    var listaToleranciaMedicamentos = [ConstanteValor]();
    var listaControles = [ControlMedico]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.controlHeight = self.altoControl.constant;
        self.altoControl.constant = 0;
        self.vistaControl.isHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.inits();
    }
    
    private func inits() {
        // Ajustes de estilos
        self.btnControles.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnControles.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnControles.layer.borderColor = Constantes.BORDE_COLOR;
        
        self.vistaCompletaControl.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaCompletaControl.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.vistaCompletaControl.layer.borderColor = Constantes.BORDE_COLOR;
        
        self.vistaControlMejora.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaControlTratamientoIndicaciones.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaControlToleraMedicamentos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaControlExamenFisico.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaControlAnexos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.vistaHistoriaPeso.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaTiempoEvolucion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaNumeroLesiones.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaCambiosEvidentes.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaSintomas.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaSintomasCambianDia.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaOtrosFactores.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaAntecedentes.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaTratamientoRecibido.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaOtrasSustancias.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaEfectosTratamiento.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaExamenFisico.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaAnexos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaHistoriaImpresionDiagnostica.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaRequerimientos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        // Se oculta la vista de requerimientos hasta que se compruebe que la consulta tiene al menos un requerimiento.
        self.vistaRequerimientosHeight = 65;
        self.altoVistaRequerimientos.constant = 0;
        self.mostrarOcultarRequerimientos(mostrar: false);
        
        // Se asigna la posición del control que ha sido seleccionado previamente.
        self.btnControles.tag = MemoriaHistoriaClinica.posicionControlActivo;
        
        self.conexion.conectarBaseDatos();
        self.cargarInformacionBase();
    }
    
    /**
     Permite precargar información base almacenada en la base de datos interna.
     */
    private func cargarInformacionBase () {
        self.listaUnidadMedida = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "unit_measurement");
        self.listaNumeroLesiones = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "number_injuries");
        self.listaEvolucionLesiones = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "evolution_injuries");
        self.listaSintomas = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "symptom");
        self.listaCambioSintomas = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "change_symptom");
        self.listaToleranciaMedicamentos = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: conexion, grupo: "tolerate_medications");
        
        self.cargarInformacionCompleta();
    }
    
    /**
     Permite cargar la información asociada a la historia clínica.
     */
    private func cargarInformacionCompleta () {
        self.cargarInformacionPaciente();
        self.cargarInformacionMedico();
        self.cargarInformacionConsulta();
        self.cargarInformacionSelectores();
    }
    
    /**
     Permite consultar en la base de datos, la información que se debe mostrar en las listas desplegables.
     */
    private func cargarInformacionSelectores () {
        // Se inicializa la lista.
        self.listaControles = [];
        // Se consulta el ID del médico que ha iniciado sesión.
        let doctorId = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as! Int;
        // Se obtienen de la memoria las consultas internas por doctor.
        let internas = MemoriaHistoriaClinica.controlesMedicos.filter({$0.consultation_id == self.consultaId}).filter({$0.doctor_id == doctorId});
        
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
     Permite cargar únicamente la información base del paciente.
     */
    private func cargarInformacionPaciente () {
        if let paciente = MemoriaHistoriaClinica.paciente {
            self.lblNombrePaciente.text = "\(paciente.name ?? "") \(paciente.last_name ?? "")";
            self.lblDocumentoPaciente.text = paciente.number_document;
            
            // Convertir la fecha de nacimiento en edad.
            let dateFormat = DateFormatter();
            dateFormat.dateFormat = "yyyy-MM-dd";
            let edad = Funcionales.calcularEdad(nacimiento: dateFormat.date(from: paciente.birthdate!)!, listaUnidadMedida: self.listaUnidadMedida, enTexto: true);
            
            if let (cantidad, unidad) = edad {
                self.lblEdadPaciente.text = "\(cantidad) \(unidad)";
            }
        }
    }
    
    /**
     Permite cargar únicamente la información del médico, tomado de consulta general.
     */
    private func cargarInformacionMedico () {
        if (MemoriaHistoriaClinica.consultasMedicas.count > 0) {
            if let consulta = MemoriaHistoriaClinica.consultasMedicas.filter({ $0.id == self.consultaId }).first {
                if let medico = MemoriaHistoriaClinica.medico.first(where: {$0.id == consulta.doctor_id} ) {
                    self.lblHistoriaNombreMedico.text = "\(medico.name ?? "") \(medico.surnames ?? "")";
                    self.lblHistoriaTarjetaProfesional.text = medico.professional_card;
                    self.lblHistoriaFecha.text = consulta.created_at;
                    
                    self.lblControlNombreMedico.text = "\(medico.name ?? "") \(medico.surnames ?? "")";
                    self.lblControlTarjetaProfesional.text = medico.professional_card;
                    self.lblControlFecha.text = consulta.created_at;
                }
            }
        }
    }
    
    /**
     Permite cargar la información completa de la consulta, tomando la consulta interna seleccionada.
     */
    private func cargarInformacionConsulta () {
        if (MemoriaHistoriaClinica.consultasMedicas.count > 0) {
            if let consulta = MemoriaHistoriaClinica.consultasMedicas.filter({ $0.consultation_id == self.consultaId }).first {
                
                var textoUnidadMedida = "";
                var textoNumeroLesiones = "";
                var textoEvolucionLesiones = "";
                var textoSintomas = "";
                var textoSintomasCambian = "";
                var textoAnexos = "";
                var textoImpresionDiagnostica = "";
                
                if (consulta.unit_measurement != nil) {
                    textoUnidadMedida = self.listaUnidadMedida.first(where: {$0.value == consulta.unit_measurement})?.title ?? "";
                }
                
                if (consulta.number_injuries != nil) {
                    textoNumeroLesiones = self.listaNumeroLesiones.first(where: {$0.value == consulta.number_injuries})?.title ?? "";
                }
                
                if (consulta.evolution_injuries != nil) {
                    let evolucionLesiones = consulta.evolution_injuries!.split(separator: ",");
                
                    if(evolucionLesiones.count > 0) {
                        for evolucion in evolucionLesiones {
                            if (evolucion.description != "") {
                                let valor = Int(evolucion.description);
                                textoEvolucionLesiones += "\(self.listaEvolucionLesiones.first(where: {$0.value == valor})?.title ?? "") ";
                            }
                        }
                    }
                }
                
                // Se valida existencia de requerimientos
                if (MemoriaHistoriaClinica.requerimientos.count > 0) {
                    let requerimientos = MemoriaHistoriaClinica.requerimientos.filter{
                        req in
                        return req.consultation_id == self.consultaId && req.doctor_id != nil
                    }
                    
                    if (requerimientos.count > 0) {
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
                        
                        var totalAltos: CGFloat = 0;
                        
                        for requerimiento in requerimientos {
                            // Datos relacionados
                            let medico = MemoriaHistoriaClinica.medico.first(where: {$0.id == requerimiento.doctor_id})
                            
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
                            
                            let frameNumeral = CGRect(x: 0, y: posicionNumeralY, width: self.vistaContenidoRequerimientos.frame.width, height: altoNumeral);
                            let frameSeparador = CGRect(x: 0, y: posicionSeparadorY, width: self.vistaContenidoRequerimientos.frame.width, height: altoSeparador);
                            let frameMedicoLabel = CGRect(x: 0, y: posicionMedicoLabelY, width: self.vistaContenidoRequerimientos.frame.width, height: altoMedicoLabel);
                            let frameMedico = CGRect(x: 0, y: posicionMedicoY, width: self.vistaContenidoRequerimientos.frame.width, height: altoMedico);
                            let frameTarjetaProfesionalLabel = CGRect(x: 0, y: posicionTarjetaProfesionalLabelY, width: self.vistaContenidoRequerimientos.frame.width, height: altoTarjetaProfesionalLabel);
                            let frameTarjetaProfesional = CGRect(x: 0, y: posicionTarjetaProfesionalY, width: self.vistaContenidoRequerimientos.frame.width, height: altoTarjetaProfesional);
                            let frameFechaLabel = CGRect(x: 0, y: posicionFechaLabelY, width: self.vistaContenidoRequerimientos.frame.width, height: altoFechaLabel);
                            let frameFecha = CGRect(x: 0, y: posicionFechaY, width: self.vistaContenidoRequerimientos.frame.width, height: altoFecha);
                            let frameDescripcionLabel = CGRect(x: 0, y: posicionDescripcionLabelY, width: self.vistaContenidoRequerimientos.frame.width, height: altoDescripcionLabel);
                            let frameDescripcion = CGRect(x: 0, y: posicionDescripcionY, width: self.vistaContenidoRequerimientos.frame.width, height: altoDescripcion);
                            
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
                            labelDescripcionTitulo.text = "Historia clínica:";
                            labelDescripcionTitulo.textColor = Constantes.COLOR_BOTON_SECUNDARIO;
                            
                            let labelDescripcion = UITextView(frame: frameDescripcion)
                            labelDescripcion.text = requerimiento.description_request;
                            labelDescripcion.textColor = UIColor.darkGray;
                            labelDescripcion.textAlignment = .natural;
                            labelDescripcion.backgroundColor = .none;
                            
                            // Se añade la nueva vista
                            self.vistaContenidoRequerimientos.addSubview(labelNumeral);
                            self.vistaContenidoRequerimientos.addSubview(separador);
                            self.vistaContenidoRequerimientos.addSubview(labelMedicoTitulo);
                            self.vistaContenidoRequerimientos.addSubview(labelMedico);
                            self.vistaContenidoRequerimientos.addSubview(labelTarjetaProfesionalTitulo);
                            self.vistaContenidoRequerimientos.addSubview(labelTarjetaProfesional);
                            self.vistaContenidoRequerimientos.addSubview(labelFechaTitulo);
                            self.vistaContenidoRequerimientos.addSubview(labelFecha);
                            self.vistaContenidoRequerimientos.addSubview(labelDescripcionTitulo);
                            self.vistaContenidoRequerimientos.addSubview(labelDescripcion);
                            contadorRequerimientos += 1;
                            
                            if (contadorRequerimientos <= requerimientos.count) {
                                // 80 porque son 8 elementos para mostrar
                                totalAltos += altoNumeral + altoSeparador + altoMedicoLabel + altoMedico + altoTarjetaProfesionalLabel + altoTarjetaProfesional + altoFechaLabel + altoFecha + altoDescripcionLabel + altoDescripcion + 75;
                            }
                        }
                        // Se muestra la vista de requerimientos con la información cargada.
                        self.altoContenidoRequerimientos.constant = totalAltos;
                        self.vistaRequerimientosHeight = self.vistaRequerimientosHeight + self.altoContenidoRequerimientos.constant;
                        
                        self.mostrarOcultarRequerimientos(mostrar: true);
                    }
                }
                
                if (consulta.symptom != nil) {
                    let sintomas = consulta.symptom!.split(separator: ",");
                    
                        if(sintomas.count > 0) {
                            for sintoma in sintomas {
                                if (sintoma.description != "") {
                                    let valor = Int(sintoma.description);
                                    textoSintomas += "\(self.listaSintomas.first(where: {$0.value == valor})?.title ?? "") ";
                                }
                            }
                        }
                }
                
                if (consulta.change_symptom != nil) {
                    let cambios = Int(consulta.change_symptom!);
                    textoSintomasCambian = self.listaCambioSintomas.first(where: {$0.value == cambios})?.title ?? "";
                }
                
                // Información que se toma de la consulta padre
                if let consultaGeneral = MemoriaHistoriaClinica.consultasMedicas.first(where: {$0.id == self.consultaId}) {
                    
                    textoAnexos = consultaGeneral.annex_description ?? "Ninguno";
                    textoImpresionDiagnostica = consultaGeneral.diagnostic_impression ?? consulta.diagnostic_impression!;
                }
                
                self.lblHistoriaPeso.text = consulta.weight;
                self.lblHistoriaTiempoEvolucion.text = "\(consulta.evolution_time?.description ?? "") \(textoUnidadMedida)";
                self.lblHistoriaNumeroLesiones.text = textoNumeroLesiones;
                self.lblHistoriaEvolucionLesiones.text = textoEvolucionLesiones;
                self.lblHistoriaExudan.text = consulta.exude! ? "Si" : "No";
                self.lblHistoriaSupuran.text = consulta.suppurate! ? "Si" : "No";
                self.lblHistoriaSangran.text = consulta.blood! ? "Si" : "No";
                self.lblHistoriaSintomas.text = textoSintomas;
                self.lblHistoriaSintomasCambian.text = textoSintomasCambian;
                self.lblHistoriaOtrosFactores.text = (consulta.other_factors_symptom == "") ? "Ninguno" : consulta.other_factors_symptom;
                self.lblHistoriaAntecedentesPersonales.text = consulta.personal_history;
                self.lblHistoriaAntecedentesFamiliares.text = consulta.family_background;
                self.lblHistoriaTratamiento.text = consulta.treatment_received;
                self.lblHistoriaOtrasSustancias.text = consulta.applied_substances;
                self.lblHistoriaEfectosTratamiento.text = consulta.treatment_effects;
                self.lblHistoriaExamenFisico.text = consulta.description_physical_examination;
                self.lblHistoriaAnexos.text = textoAnexos;
                self.lblHistoriaImpresionDiagnostica.text = textoImpresionDiagnostica;
            }
        }
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
        
        let medico = MemoriaHistoriaClinica.medico.first(where: {$0.id == control.doctor_id});
        let toleranciaMedicamentos = self.listaToleranciaMedicamentos.first(where: {$0.value == control.tolerated_medications});
        
        self.lblControlFecha.text = control.created_at;
        self.lblControlAnexos.text = control.annex_description;
        self.lblControlNombreMedico.text = "\(medico?.name ?? "") \(medico?.surnames ?? "")";
        self.lblControlMejoraSubjetiva.text = control.subjetive_improvement;
        self.lblControlTarjetaProfesional.text = medico?.professional_card;
        self.lblControlToleraMedicamentos.text = toleranciaMedicamentos?.title;
        self.lblControlTratamientoIndicaciones.text = control.did_treatment == true ? "Si" : "No";
        self.lblControlExamenFisico.text = control.clinic_description;
        
        if (self.btnControles.tag > 0) {
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaControl, altoInicial: self.altoControl, altoAuxiliar: self.controlHeight, animado: true);
        } else {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaControl, altoInicial: self.altoControl, animado: true);
        }
    }
    
    private func mostrarOcultarRequerimientos (mostrar: Bool) {
        if (mostrar) {
            self.lblTituloRequerimientos.isHidden = false;
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaRequerimientos, altoInicial: self.altoVistaRequerimientos, altoAuxiliar: self.vistaRequerimientosHeight, animado: false);
        } else {
            self.lblTituloRequerimientos.isHidden = true;
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaRequerimientos, altoInicial: self.altoVistaRequerimientos, animado: false);
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
    
    @IBAction func accionVerMasPaciente(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_informacion_paciente") as! InformacionPacienteViewController;
        vc.consultaId = self.consultaId;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionControles(_ sender: UIButton) {
        self.mostrarPickerSelectores(titulo: Mensajes.SELECCIONAR_CONTROL);
    }
    
}

extension InternoHistoriaClinicaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
