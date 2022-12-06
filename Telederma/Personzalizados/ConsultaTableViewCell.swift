//
//  ConsultaTableViewCell.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 28/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

/**
 ESTADO_CONSULTA_SIN_ENVIAR = 0;
 ESTADO_CONSULTA_RESUELTO = 1;
 ESTADO_CONSULTA_REQUERIMIENTO = 2;
 ESTADO_CONSULTA_PENDIENTE = 3;
 ESTADO_CONSULTA_ARCHIVADO = 4;
 ESTADO_CONSULTA_PROCESO = 5;
 ESTADO_CONSULTA_SIN_CREDITOS = 6;
 ESTADO_CONSULTA_REMISION = 7;
 ESTADO_CONSULTA_EVALUANDO = 8;
 
 */

import UIKit
import Presentr

class ConsultaTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var imgEstado: UIImageView!
    @IBOutlet weak var vistaAdicionales: UIView!
    @IBOutlet weak var tablaInternos: UITableView!
    @IBOutlet weak var altoVistaAdicionales: NSLayoutConstraint!
    @IBOutlet weak var vistaAgregarConsulta: UIView!
    @IBOutlet weak var altoVistaAgregarConsulta: NSLayoutConstraint!
    
    var adicionalesHeight: CGFloat!;
    var agregarConsultaHeight: CGFloat!;
    
    // Se necesita saber si estamos mostrando controles o consultas
    var esConsulta: Bool = true;
    // La consulta médica se utiliza para agrupar los controles
    var consultaMedica: ConsultaMedica?;
    
    // Los siguientes aplican cuando son consultas médicas
    var paciente: Paciente? = nil;
    var informacionPaciente: InformacionPaciente? = nil;
    var diccionarioConsultas = [Int: [ConsultaMedica]]();
    
    // Aplica cuando son controles
    var diccionarioControles = [Int: [ControlMedico]]();
    
    // Variables para consultas al desplegar
    var estaAdicionalesVisible = true;
    var estaAgregarConsultaVisible = false;
    
    var padreViewController: UIViewController?;
    
    // Modales
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.inits();
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        self.paciente = nil;
    }
    
    private func inits () {
        self.adicionalesHeight = self.altoVistaAdicionales.constant;
        
        if (self.altoVistaAgregarConsulta != nil){
            self.agregarConsultaHeight = self.altoVistaAgregarConsulta.constant;
            
            // Se añade evento a la vista de agregar consulta
            let eventoConsultaMedica = UITapGestureRecognizer(target: self, action:  #selector (self.consultaMedica(_:)))
            self.vistaAgregarConsulta.addGestureRecognizer(eventoConsultaMedica);
        }
        
        // Se oculta para la primera vez.
        self.mostrarOcultarAdicionales();
    }
    
    /**
     Evento para la vista de agregar consulta cuando se muestra el botón azul adicional para las consultas que están resueltas.
     */
    @objc func consultaMedica(_ sender:UITapGestureRecognizer){
        
        if let viewController = self.padreViewController {
            // Para controlar ventanas activas.
            MemoriaHistoriaClinica.paciente = self.paciente;
            MemoriaRegistroPaciente.paciente = self.paciente;
            MemoriaRegistroPaciente.informacionPaciente = self.informacionPaciente;
            
            let vc = viewController.storyboard!.instantiateViewController(withIdentifier: "view_registro_paciente_1") as! RegistroPacienteViewController1;
            
            viewController.present(vc, animated: true, completion: nil);
        }
    }
    
    /**
     Permite mostrar u ocultar los elementos que le pertenecen a la fila.
     */
    func mostrarOcultarAdicionales () {
        self.estaAdicionalesVisible = !self.estaAdicionalesVisible;
        
        if (self.estaAdicionalesVisible) {
            Funcionales.mostrarSeccion(vistaController: self.contentView, vistaMostrar: self.vistaAdicionales, altoInicial: self.altoVistaAdicionales, altoAuxiliar: self.adicionalesHeight, animado: true);
            
            if (self.estaAgregarConsultaVisible) {
                Funcionales.mostrarSeccion(vistaController: self.contentView, vistaMostrar: self.vistaAgregarConsulta, altoInicial: self.altoVistaAgregarConsulta, altoAuxiliar: self.agregarConsultaHeight, animado: true);
            }
            
        } else {
            Funcionales.ocultarSeccion(vistaController: self.contentView, vista: self.vistaAdicionales, altoInicial: self.altoVistaAdicionales, animado: true);
            
            if (self.vistaAgregarConsulta != nil) {
                Funcionales.ocultarSeccion(vistaController: self.contentView, vista: self.vistaAgregarConsulta, altoInicial: self.altoVistaAgregarConsulta, animado: true);
            }
        }
    }
    
    @objc func archivarCompartirConsulta(sender: CustomLongPress) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tablaInternos);
            if let _ = self.tablaInternos.indexPathForRow(at: touchPoint) {
                if let consultas = sender.consultas {
                    if (consultas.count > 0) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil);
                        let vc = storyboard.instantiateViewController(withIdentifier: "view_custom_archivar_compartir_consulta") as! CustomArchivarCompartirConsultaViewController;
                        vc.consultas = consultas;
                        self.presenter.presentationType = .alert;
                        self.padreViewController?.customPresentViewController(self.presenter, viewController: vc, animated: true);
                    } else {
                        Funcionales.mostrarAlerta(view: self.padreViewController!, mensaje: Mensajes.ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE);
                    }
                } else {
                    Funcionales.mostrarAlerta(view: self.padreViewController!, mensaje: Mensajes.ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE);
                }
            }
            
        }
    }
    
    /**
     La asignación de los delegados se hace por medio de un método independiente puesto que al crearse la celda no puede reconocer los parámetros que se asignan previa publicación de la celda.
     */
    func activarDelegados () {
        self.tablaInternos.delegate = self;
        self.tablaInternos.dataSource = self;
    }
}


extension ConsultaTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.esConsulta) {
            if (self.diccionarioConsultas[self.paciente!.id!] != nil) {
                return self.diccionarioConsultas[self.paciente!.id!]!.count;
            } else {
                return 0;
            }
        } else {
            if (self.diccionarioControles[self.consultaMedica!.id!] != nil) {
                return self.diccionarioControles[self.consultaMedica!.id!]!.count;
            } else {
                return 0;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Texto para la primera columna de la izquierda
        var textoDiagnostico: String!;
        var fecha: String!;
        var estado: Int!;
        var numeroControles = "";
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda_interna") as! FilaInternaTableViewCell;
        var registroConsulta: ConsultaMedica?;
        var registroControl: ControlMedico?;
        
        // && self.diccionarioConsultas[self.paciente!.id!] != nil
        if (self.esConsulta && self.diccionarioConsultas[self.paciente!.id!] != nil && self.diccionarioConsultas[self.paciente!.id!]!.count > indexPath.row) {
            registroConsulta = self.diccionarioConsultas[self.paciente!.id!]![indexPath.row];
            textoDiagnostico = registroConsulta!.diagnostic_impression;
            fecha = registroConsulta?.created_at;
            estado = registroConsulta?.status;
            numeroControles = "Controles: \(registroConsulta!.count_controls ?? 0)";
            // numeroControles = "Controles: \(registroConsulta!.count_controls ?? 0) / (\(registroConsulta!.status?.description ?? "") - \(registroConsulta!.id?.description ?? ""))";
            
            let respuestasEspecialista = MemoriaHistoriaClinica.respuestasEspecialistas.filter({$0.consultation_id == registroConsulta!.id});
            if (respuestasEspecialista.count > 0) {
                for respuesta in respuestasEspecialista {
                    let diagnosticos = MemoriaHistoriaClinica.diagnosticos.filter({$0.specialist_response_id == respuesta.id});
                    if (diagnosticos.count > 0) {
                        if let diagnostico = diagnosticos.first(where: {$0.status?.lowercased() == Mensajes.ESTADO_ACTIVO.lowercased()}) {
                            textoDiagnostico = diagnostico.disease;
                            break;
                        }
                    }
                }
            }
            
            let longPressRecognizer = CustomLongPress(target: self, action: #selector(self.archivarCompartirConsulta(sender:)));
            if let paciente = self.paciente {
                longPressRecognizer.consultas = self.diccionarioConsultas[paciente.id!]!.filter({$0.status == 1});
            } else {
                longPressRecognizer.consultas = [ConsultaMedica]();
            }
            self.tablaInternos.addGestureRecognizer(longPressRecognizer);
        } else {
            if (self.consultaMedica != nil) {
                registroControl = self.diccionarioControles[self.consultaMedica!.id!]![indexPath.row];
                textoDiagnostico = "Control \(indexPath.row + 1)";
                fecha = registroControl?.created_at;
                estado = MemoriaHistoriaClinica.consultasMedicas.first(where: {$0.id == registroControl?.consultation_control_id})?.status;
            } else {
                estado = 0;
            }
        }
        
        celda.lblNumeroControles.text = numeroControles;
        celda.lblDiagnostico.text = textoDiagnostico;
        celda.lblFecha.text = fecha;
        celda.imgEstado.image = UIImage(named: Constantes.ESTADO_CONSULTA_IMAGEN[estado!] ?? "sin_enviar");
        celda.selectionStyle = .none;
        
        return celda;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.padreViewController?.storyboard?.instantiateViewController(withIdentifier: "view_historia_clinica") as! HistoriaClinicaViewController;
        
        if (!esConsulta) {
            MemoriaHistoriaClinica.posicionControlActivo = indexPath.row + 1;
            vc.consultaId = self.consultaMedica?.id;
        } else {
            vc.consultaId = self.diccionarioConsultas[self.paciente!.id!]![indexPath.row].id;
        }
        
        self.padreViewController?.present(vc, animated: true, completion: nil);
    }
    
}
