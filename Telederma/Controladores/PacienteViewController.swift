//
//  PacienteViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 12/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class PacienteViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var btnBuscar: UIButton!
    @IBOutlet weak var txtPaciente: UITextField!
    @IBOutlet weak var lblNoResultados: UILabel!
    @IBOutlet weak var vistaCabeceraResultados: UIView!
    @IBOutlet weak var vistaResultadoEncontrado: UIView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var imgEstado: UIImageView!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var btnNuevoPaciente: UIButton!
    
    
    // Altos para esconder elementos
    @IBOutlet weak var altoNoResultados: NSLayoutConstraint!
    @IBOutlet weak var altoResultadoEncontrado: NSLayoutConstraint!
    @IBOutlet weak var altoBotonNuevoPaciente: NSLayoutConstraint!
    
    // Se declara variable paciente para usarse si el resultado existe.
    var pacienteLocal: Paciente?;
    var informacionPacienteLocal: InformacionPaciente?;
    
    // Altos temporales
    var noResultadoHeightVisible: CGFloat!;
    var resultadoEncontradoHeightVisible: CGFloat!;
    var botonNuevoPacienteHeightVisible: CGFloat!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustando estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnBuscar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaCabeceraResultados.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.vistaCabeceraResultados.layer.borderColor = UIColor.darkGray.cgColor;
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Se agregar evento para el buscador
        self.txtPaciente.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        // Se oculta el botón nuevo paciente
        self.botonNuevoPacienteHeightVisible = self.altoBotonNuevoPaciente.constant;
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.btnNuevoPaciente, altoInicial: self.altoBotonNuevoPaciente, animado: false);
        
        // Altos de las vistas antes de ocultarse
        self.noResultadoHeightVisible = self.altoNoResultados.constant;
        
        self.resultadoEncontradoHeightVisible = self.altoResultadoEncontrado.constant;
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaResultadoEncontrado, altoInicial: self.altoResultadoEncontrado, animado: false);
        
        // Se reinician las variables en Memoria para paciente.
        MemoriaRegistroPaciente.reiniciarVariables();
        
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
    }
    
    /**
     Permite crear un botón para nuevo paciente cuando no hay resultado en la búsqueda.
     */
    private func crearBotonNuevoPaciente () {
        self.btnNuevoPaciente.setTitle("Nuevo paciente", for: .normal);
        self.btnNuevoPaciente.setImage(UIImage(systemName: "person.badge.plus.fill"), for: .normal);
        self.btnNuevoPaciente.isHidden = false;
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.btnNuevoPaciente, altoInicial: self.altoBotonNuevoPaciente, altoAuxiliar: self.botonNuevoPacienteHeightVisible, animado: true);
    }
    
    /**
     Permite crear un botón para nueva consulta cambiando sólo estilos.
     Esto aplica cuando se encuentra un paciente.
     */
    private func crearBotonNuevaConsulta () {
        self.btnNuevoPaciente.setTitle("Nueva consulta", for: .normal);
        self.btnNuevoPaciente.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal);
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.btnNuevoPaciente, altoInicial: self.altoBotonNuevoPaciente, altoAuxiliar: self.botonNuevoPacienteHeightVisible, animado: true);
    }
    
    /**
     Permite realizar la búsqueda con la información del campo de texto ya validada.
     */
    private func buscarPaciente () {
        // Se inactiva el botón de búsqueda
        Funcionales.activarDesactivarBoton(boton: self.btnBuscar, texto: "Buscando ...", color: .lightGray, activo: false);
        
        let documento = self.txtPaciente.text!;
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.obtenerHttpPacientePorDocumento(documento: documento);
            
            DispatchQueue.main.async(execute: {
                switch resultado {
                case let .success(data):
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    if (json[0]["error"] != nil) {
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                    } else {
                        let paciente = Paciente(JSONString: json[0]["patient"].description);
                        let informacionPaciente = InformacionPaciente(JSONString: json[0]["patient_information"].description);
                        
                        // Si el paciente regresa con información, se oculta no resultados y se muestra la información del paciente.
                        if (paciente?.id != nil) {
                            paciente?.sincronizado = true;
                            informacionPaciente?.sincronizado = true;
                            
                            Funcionales.imprimirObjetoConPropiedades(objeto: paciente!, titulo: "Paciente búsqueda");
                            Funcionales.imprimirObjetoConPropiedades(objeto: informacionPaciente!, titulo: "Información búsqueda");
                            
                            self.pacienteLocal = paciente;
                            self.informacionPacienteLocal = informacionPaciente;
                            
                            // Se guarda el paciente en la base de datos
                            let conexion = Conexion();
                            conexion.conectarBaseDatos();
                            // Se valida si paciente ya existe para saber si se registra o actualiza
                            if (FachadaDependientesSQL.seleccionarPorIdPaciente(conexion: conexion, idRegistro: (paciente?.id)!) != nil) {
                                let _ = FachadaDependientesSQL.actualizarRegistroPaciente(conexion: conexion, idRegistro: (paciente?.id)!, data: paciente!);
                            } else {
                                let _ = FachadaDependientesSQL.insertarRegistroPaciente(conexion: conexion, data: paciente!);
                            }
                            
                            // Se valida si información paciente ya existe para saber si se registra o actualiza
                            if (FachadaDependientesSQL.seleccionarPorIdInformacionPaciente(conexion: conexion, idRegistro: (informacionPaciente?.id)!) != nil) {
                                let _ = FachadaDependientesSQL.actualizarRegistroInformacionPaciente(conexion: conexion, idRegistro: (informacionPaciente?.id)!, data: informacionPaciente!);
                            } else {
                                let _ = FachadaDependientesSQL.insertarRegistroInformacionPaciente(conexion: conexion, data: informacionPaciente!);
                            }
                            
                            self.llenarBorrarInformacionPacienteEncontrado(estaLlenando: true);
                            
                        } else {
                            self.llenarBorrarInformacionPacienteEncontrado(estaLlenando: false);
                        }
                    }
                    // Se activa nuevamente el botón buscar
                    Funcionales.activarDesactivarBoton(boton: self.btnBuscar, texto: "Buscar", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    break;
                case let .failure(error):
                    print(error);
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    
                    // Se activa nuevamente el botón buscar
                    Funcionales.activarDesactivarBoton(boton: self.btnBuscar, texto: "Buscar", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    break;
                }
            });
        });
    }
    
    /**
     Permite buscar un paciente en la base de datos.
     */
    private func buscarPacienteOffline() {

        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        if let pacienteEncontrado = FachadaDependientesSQL.seleccionarTodoPaciente(conexion: conexion).first(where: {$0.number_document == self.txtPaciente.text}) {
            self.pacienteLocal = pacienteEncontrado;
            
            Funcionales.imprimirObjetoConPropiedades(objeto: pacienteEncontrado, titulo: "Paciente búsqueda")
            
            if let informacionPacienteEncontrado = FachadaDependientesSQL.seleccionarTodoInformacionPaciente(conexion: conexion).first(where: {$0.patient_id == pacienteEncontrado.id || $0.id_patient_local == pacienteEncontrado.id_local}) {
                
                Funcionales.imprimirObjetoConPropiedades(objeto: informacionPacienteEncontrado, titulo: "Información paciente");
                
                self.informacionPacienteLocal = informacionPacienteEncontrado;
                
                self.llenarBorrarInformacionPacienteEncontrado(estaLlenando: true);
            } else {
                self.llenarBorrarInformacionPacienteEncontrado(estaLlenando: false);
            }
        } else {
            self.llenarBorrarInformacionPacienteEncontrado(estaLlenando: false);
        }
    }
    
    /**
     Se usa para precargar o borrar la información de las vistas cuando se encuentra un resultado.
     - Parameter estaLlenando: Corresponde a un valor booleano para saber si se llenan o se borran los datos.
     */
    private func llenarBorrarInformacionPacienteEncontrado (estaLlenando: Bool) {
        if(estaLlenando) {
            // Ocultar No Resultados
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.lblNoResultados, altoInicial: self.altoNoResultados, animado: true);
            
            // Se muestra vista resultado
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaResultadoEncontrado, altoInicial: self.altoResultadoEncontrado, altoAuxiliar: self.resultadoEncontradoHeightVisible, animado: true);
            
            // Se agrega borde a la vista resultado encontrado.
            Funcionales.agregarBorde(lado: .Bottom, color: UIColor.lightGray.cgColor, grosor: 1.0, vista: self.vistaResultadoEncontrado);
            
            self.lblNombre.text = "\(self.pacienteLocal?.name ?? "") \(self.pacienteLocal?.second_name ?? "") \(self.pacienteLocal?.last_name ?? "") \(self.pacienteLocal?.second_surname ?? "")";
            // Pendiente fecha.
            self.lblFecha.text = self.pacienteLocal?.created_at;
            // Pendiente el estado.
            self.lblEstado.text = "Sin enviar"; //self.pacienteLocal?.status?.description;
            
            // Se hace que la vista resultado maneje eventos.
            let evento = UITapGestureRecognizer(target: self, action:  #selector (self.iniciarConsultaPacienteEncontrado(_:)));
            
            self.vistaResultadoEncontrado.addGestureRecognizer(evento);
            self.crearBotonNuevaConsulta();
        } else {
            self.lblNombre.text = "----";
            self.lblEstado.text = "----";
            
            // Se muestra vista no resultado
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.lblNoResultados, altoInicial: self.altoNoResultados, altoAuxiliar: self.noResultadoHeightVisible, animado: true);
            
            // Ocultar Resultados
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaResultadoEncontrado, altoInicial: self.altoResultadoEncontrado, animado: true);
            
            // Se borra la información de las variables locales
            self.pacienteLocal = nil;
            self.informacionPacienteLocal = nil;
            
            self.crearBotonNuevoPaciente();
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // Si el documento cambia se oculta la vista de resultados encontrados.
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaResultadoEncontrado, altoInicial: self.altoResultadoEncontrado, animado: true);
        
        // Se muestra la vista de resultados no encontrados.
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.lblNoResultados, altoInicial: self.altoNoResultados, altoAuxiliar: self.noResultadoHeightVisible, animado: true);
        
        // Se oculta el botón buscar paciente
        self.crearBotonNuevoPaciente();
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.btnNuevoPaciente, altoInicial: self.altoBotonNuevoPaciente, animado: true);
    }
    
    /**
     Se inicia la vista de consultas con la información precargada.
     */
    @objc private func iniciarConsultaPacienteEncontrado(_ sender:UITapGestureRecognizer){
        MemoriaRegistroPaciente.paciente = self.pacienteLocal;
        MemoriaRegistroPaciente.informacionPaciente = self.informacionPacienteLocal;
        MemoriaRegistroPaciente.busquedaVacia = false;
        
        self.siguienteVista();
    }
    
    /**
     Permite continuar a la vista de información del paciente, con o sin información precargada según resultados de la búsqueda.
     */
    private func siguienteVista () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_1") as! RegistroPacienteViewController1;
        vc.busquedaIdentificacion = self.txtPaciente.text;
        self.present(vc, animated: true, completion: nil);
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionBuscarPaciente(_ sender: UIButton) {
        // Ocultar teclado.
        self.view.endEditing(true);
        
        if (self.txtPaciente.text == "") {
            let accionContinuar = UIAlertAction(title: "Continuar", style: .default, handler: {
                (UIAlertAction) in
                
                MemoriaRegistroPaciente.paciente = nil;
                MemoriaRegistroPaciente.informacionPaciente = nil;
                MemoriaRegistroPaciente.busquedaVacia = true;
                
                self.siguienteVista();
            });
            let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil);
            let alerta = UIAlertController(title: Mensajes.TITULO_CONFIRMACION, message: Mensajes.MENSAJE_CONFIRMACION, preferredStyle: .alert);
            alerta.addAction(accionContinuar);
            alerta.addAction(accionCancelar);
            self.present(alerta, animated: true, completion: nil);
        } else {
            if (Funcionales.dispositivoEstaConectado) {
                self.buscarPaciente();
            } else {
                self.buscarPacienteOffline();
            }
        }
    }
    
    @IBAction func accionNuevoPaciente(_ sender: UIButton) {
        MemoriaRegistroPaciente.paciente = nil;
        MemoriaRegistroPaciente.informacionPaciente = nil;
        MemoriaRegistroPaciente.busquedaVacia = true;
        
        self.siguienteVista();
    }
    
    
}

