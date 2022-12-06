//
//  ConsultaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 12/04/20.
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
import SwiftyJSON
import Presentr

class ConsultaViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnResueltas: UIButton!
    @IBOutlet weak var btnPendientes: UIButton!
    @IBOutlet weak var btnArchivadas: UIButton!
    @IBOutlet weak var lblRecargar: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var vistaCabecera: UIView!
    @IBOutlet weak var btnBuscarPaciente: UIButton!
    
    // Variable para manejo de tabs
    // A cada tab se le asigna el conjunto de estados que abarca.
    var tabActiva = 1;
    // Se usa para asingar los estados en cada tab.
    var consultasPorEstado = [Int: [Int]]();
    
    @IBOutlet weak var altoCabecera: NSLayoutConstraint!
    @IBOutlet weak var altoRecargar: NSLayoutConstraint!
    @IBOutlet weak var tablaConsultas: UITableView!
    
    // Variables para manejo de información en memoria.
    var listaPacientes = [Paciente]();
    var diccionarioInformacionPaciente = [Int: [InformacionPaciente]]();
    var diccionarioConsultas = [Int: [ConsultaMedica]]();
    
    // Altos mostrar consultas internas
    let selectedCellHeight: CGFloat = 340.0;
    let unselectedCellHeight: CGFloat = 84.3;
    var selectedCellIndexPath = [IndexPath]();
    
    // Altos vistas a ocultar
    var cabeceraHeight: CGFloat!;
    var recargarHeight: CGFloat!;
    
    // Control para actualizar tablas
    var refreshControl = UIRefreshControl();
    
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
        
        // Ajustes de estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.vistaCabecera.layer.borderColor = Constantes.BORDE_COLOR;
        self.vistaCabecera.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnBuscarPaciente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnBuscarPaciente.isHidden = true;
        
        self.loading.hidesWhenStopped = true;
        self.tablaConsultas.delegate = self;
        self.tablaConsultas.dataSource = self;
        
        // Se cargan los estados permitidos
        self.asignarEstadosPermitidos();
        
        // Se guardan los altos para ocultar la información de recarga.
        self.recargarHeight = self.altoRecargar.constant;
        self.cabeceraHeight = self.altoCabecera.constant;
        
        // Se configura pull para refrescar la tabla
        self.refreshControl.attributedTitle = NSAttributedString(string: "Recargando")
        self.refreshControl.addTarget(self, action: #selector(self.recargar(_:)), for: .valueChanged);
        self.tablaConsultas.addSubview(self.refreshControl);
        
        // Siempre inicia en resueltas.
        self.tabActiva = 1;
        
        // La primera vez se busca por estado resuelto
        if (Funcionales.dispositivoEstaConectado) {
            self.obtenerConsultasPorEstado();
        } else {
            self.obtenerConsultasPorEstadoOffline();
        }
        
        // Se inactiva los controles.
        MemoriaHistoriaClinica.posicionControlActivo = 0;
        // Se valida si hay imágenes pendientes por enviar.
        if (Funcionales.dispositivoEstaConectado) {
            Funcionales.sincronizarInformacion();            
        }
    }
    
    /**
     Permite agrupar los estados que se deben listar por tab.
     Se utiliza para cargar el icono correspondiente según el estado.
     */
    private func asignarEstadosPermitidos () {
        self.consultasPorEstado[1] = [1, 2, 7];
        self.consultasPorEstado[2] = [3, 5, 6, 8];
        self.consultasPorEstado[3] = [4];
    }
    
    /**
     Permite cargar la información de la tabla y mostrarla.
     */
    private func inicializarTabla () {
        if (self.listaPacientes.count > 0) {
            self.tablaConsultas.reloadData();
            self.tablaConsultas.isHidden = false;
        }
    }
    
    /**
     Permite recargar la información usando el gesto pull hacia abajo.
     */
    @objc func recargar(_ sender: AnyObject) {
        self.refreshControl.beginRefreshing();
        // Code to refresh table view
        if (Funcionales.dispositivoEstaConectado) {
            self.obtenerConsultasPorEstado();
        } else {
            self.obtenerConsultasPorEstadoOffline();
        }
    }
    
    
    
    /**
     Permite consultar la infomación desde el servidor.
     */
    private func obtenerConsultasPorEstado () {
        self.loading.startAnimating();
        
        self.listaPacientes = [];
        self.diccionarioConsultas = [:];
        self.diccionarioInformacionPaciente = [:];
        
        let parametros: [String: Any] = [
            "status": self.consultasPorEstado[self.tabActiva]!,
            "number_document": Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_DOCUMENTO) as! String
        ];
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.obtenerHttpTodoConsultaMedica(parametros: parametros);
            
            DispatchQueue.main.async(execute: {
                switch (resultado) {
                case let .success(data):
                    let json = JSON(arrayLiteral: data);
                    
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
                            for item in json[0].arrayValue {
                                if let paciente = Paciente(JSONString: item["patient"].description){
                                    paciente.sincronizado = true;
                                    
                                    Funcionales.imprimirObjetoConPropiedades(objeto: paciente, titulo: "Paciente online")
                                    
                                    self.listaPacientes.append(paciente);
                                    
                                    // Se valida si existe el paciente para saber si se actualiza o se ingresa.
                                    if (FachadaDependientesSQL.seleccionarPorIdPaciente(conexion: conexion, idRegistro: paciente.id!) != nil) {
                                        let _ = FachadaDependientesSQL.actualizarRegistroPaciente(conexion: conexion, idRegistro: paciente.id!, data: paciente);
                                    } else {
                                        let _ = FachadaDependientesSQL.insertarRegistroPaciente(conexion: conexion, data: paciente);
                                    }
                                }
                                
                                if (item["patient"]["consultants"].arrayValue.count > 0) {
                                    
                                    var consultasAux = [ConsultaMedica]();
                                    var informacionPacienteAux = [InformacionPaciente]();
                                    
                                    for itemConsulta in item["patient"]["consultants"].arrayValue {
                                        
                                        if let consulta = ConsultaMedica(JSONString: itemConsulta.description) {
                                            consulta.sincronizado = true;
                                            
                                            Funcionales.imprimirObjetoConPropiedades(objeto: consulta, titulo: "Consulta paciente online");
                                            
                                            consultasAux.append(consulta);
                                            
                                            // Se valida si existe la consulta para saber si se actualiza o se ingresa
                                            if (FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).first(where: {$0.id == consulta.id}) != nil) {
                                                let _ = FachadaDependientesSQL.actualizarRegistroConsultaMedica(conexion: conexion, idRegistro: consulta.id!, data: consulta);
                                            } else {
                                                let _ = FachadaDependientesSQL.insertarRegistroConsultaMedica(conexion: conexion, data: consulta);
                                            }
                                            
                                            if (itemConsulta["patient_information"] != nil) {
                                                
                                                if let informacionPaciente = InformacionPaciente(JSONString: itemConsulta["patient_information"].description) {
                                                    informacionPaciente.sincronizado = true;
                                                    
                                                    informacionPacienteAux.append(informacionPaciente);
                                                    
                                                    // Se valida si existe un registro de información paciente para saber si se actualiza o se ingresa.
                                                    if (FachadaDependientesSQL.seleccionarPorIdInformacionPaciente(conexion: conexion, idRegistro: informacionPaciente.id!) != nil) {
                                                        let _ = FachadaDependientesSQL.actualizarRegistroInformacionPaciente(conexion: conexion, idRegistro: informacionPaciente.id!, data: informacionPaciente);
                                                    } else {
                                                        let _ = FachadaDependientesSQL.insertarRegistroInformacionPaciente(conexion: conexion, data: informacionPaciente);
                                                    }
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    self.diccionarioConsultas[item["patient"]["id"].int!] = consultasAux;
                                    self.diccionarioInformacionPaciente[item["patient"]["id"].int!] = informacionPacienteAux;
                                }
                            }
                            print("Pacientes online: \(self.listaPacientes.count)")
                            self.ordenarConsultas();
                            if (self.refreshControl.isRefreshing) {
                                self.refreshControl.endRefreshing();
                                // Ocultar la etiqueta de recarga.
                                Funcionales.ocultarSeccion(vistaController: self.view, vista: self.lblRecargar, altoInicial: self.altoRecargar, animado: true);
                            }
                            self.inicializarTabla();
                        }
                    }
                    self.loading.stopAnimating();
                    break;
                case let.failure(error):
                    print(error);
                    self.loading.stopAnimating();
                    if (self.refreshControl.isRefreshing) {
                        self.refreshControl.endRefreshing();
                        // Ocultar la etiqueta de recarga.
                        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.lblRecargar, altoInicial: self.altoRecargar, animado: true);
                    }
                    break;
                }
            });
        });
    }
    
    /**
     Permite cargar la información a partir de la base de datos interna.
     */
    private func obtenerConsultasPorEstadoOffline () {
        self.loading.startAnimating();
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        self.listaPacientes = [];
        self.diccionarioConsultas = [:];
        self.diccionarioInformacionPaciente = [:];
        
        // Se obtienen los pacientes de la base de datos
        let pacientes = FachadaDependientesSQL.seleccionarTodoPaciente(conexion: conexion);
        if (pacientes.count > 0) {
            let doctorId = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as! Int;
            for paciente in pacientes {
                
                // Se consulta la información del paciente
                let informacionPaciente = FachadaDependientesSQL.seleccionarTodoInformacionPaciente(conexion: conexion).filter({$0.patient_id == paciente.id});
                // Se obtienen las consultas asociadas a cada paciente.
                
                let consultas = FachadaDependientesSQL.seleccionarTodoConsultaMedica(conexion: conexion).filter({$0.patient_id == paciente.id && $0.doctor_id == doctorId}).filter({(self.consultasPorEstado[self.tabActiva]!.contains($0.status ?? 0))});
                
                if (informacionPaciente.count > 0) {
                    if (paciente.id != nil) {
                        self.diccionarioInformacionPaciente[paciente.id!] = [InformacionPaciente]();
                    }
                    
                    for informacion in informacionPaciente {
                        // Se añade la información del paciente al diccionario.
                        if (paciente.id != nil && informacion.id != nil) {
                            self.diccionarioInformacionPaciente[paciente.id!]?.append(informacion);
                        }
                    }
                }
                
                if (consultas.count > 0) {
                    if (paciente.id != nil) {
                        self.diccionarioConsultas[paciente.id!] = [ConsultaMedica]();
                    }
                    for consulta in consultas {
                        // Se añade la información de la consulta al diccionario
                        if (paciente.id != nil) {
                            self.diccionarioConsultas[paciente.id!]?.append(consulta);
                        }
                    }
                    
                    // Se añade el paciente a la lista local.
                    // Se añade una vez se compruebe que tiene consultas de lo contrario aparece en resueltas.
                    self.listaPacientes.append(paciente);
                }
                
            }
            
            self.ordenarConsultas();
            if (self.refreshControl.isRefreshing) {
                self.refreshControl.endRefreshing();
                // Ocultar la etiqueta de recarga.
                Funcionales.ocultarSeccion(vistaController: self.view, vista: self.lblRecargar, altoInicial: self.altoRecargar, animado: true);
            }
        }
        self.inicializarTabla();
        self.loading.stopAnimating();
    }
    
    /**
     Permite ordenar las consultas médicas asociadas a cada paciente.
     */
    private func ordenarConsultas () {
        if (self.listaPacientes.count > 0) {
            self.listaPacientes = self.listaPacientes.sorted(by: {$0.id! < $1.id!});
            for paciente in self.listaPacientes {
                
                // Se ordenan las consultas
                if (self.diccionarioConsultas[paciente.id!] != nil) {
                    let sortedConsultas = self.diccionarioConsultas[paciente.id!]!.sorted {$0.id! > $1.id!};
                    self.diccionarioConsultas[paciente.id!]! = sortedConsultas;
                }
                
                // Se ordena la información del paciente
                if(self.diccionarioInformacionPaciente[paciente.id!] != nil) {
                    let sortedInformacionPaciente = self.diccionarioInformacionPaciente[paciente.id!]!.sorted {$0.id! > $1.id!};
                    self.diccionarioInformacionPaciente[paciente.id!]! = sortedInformacionPaciente;
                }
            }
        }
    }
    
    /**
     Permite cambiar los botones de las pestañas al color por defecto.
     */
    private func desactivarBotones () {
        self.tablaConsultas.isHidden = true;
        self.btnResueltas.backgroundColor = .systemBlue;
        self.btnPendientes.backgroundColor = .systemBlue;
        self.btnArchivadas.backgroundColor = .systemBlue;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionResueltas(_ sender: UIButton) {
        // Muestra label recargar
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.lblRecargar, altoInicial: self.altoRecargar, altoAuxiliar: self.recargarHeight, animado: true);
        
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaCabecera, altoInicial: self.altoCabecera, altoAuxiliar: self.cabeceraHeight, animado: true);
        
        // Estilos
        self.btnBuscarPaciente.isHidden = true;
        self.desactivarBotones();
        self.btnResueltas.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        
        self.tabActiva = 1;
        
        if (Funcionales.dispositivoEstaConectado) {
            self.obtenerConsultasPorEstado();
        } else {
            self.obtenerConsultasPorEstadoOffline();
        }
    }
    @IBAction func accionPendientes(_ sender: UIButton) {
        // Muestra label recargar y cabecera
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.lblRecargar, altoInicial: self.altoRecargar, altoAuxiliar: self.recargarHeight, animado: true);
        
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaCabecera, altoInicial: self.altoCabecera, altoAuxiliar: self.cabeceraHeight, animado: true);
        
        // Estilos
        self.btnBuscarPaciente.isHidden = true;
        self.desactivarBotones();
        self.btnPendientes.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        
        self.tabActiva = 2;
        
        if (Funcionales.dispositivoEstaConectado) {
            self.obtenerConsultasPorEstado();
        } else {
            self.obtenerConsultasPorEstadoOffline();
        }
    }
    @IBAction func accionArchivadas(_ sender: UIButton) {
        self.tabActiva = 3;
        // Se oculta label recargar y cabecera
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.lblRecargar, altoInicial: self.altoRecargar, animado: false);
        
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaCabecera, altoInicial: self.altoCabecera, animado: false);
        
        // Estilos
        self.desactivarBotones();
        self.btnArchivadas.backgroundColor = Constantes.COLOR_BOTON_SECUNDARIO;
        self.tablaConsultas.isHidden = true;
        self.btnBuscarPaciente.isHidden = false;
    }
    
    @IBAction func accionBuscarPaciente(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_paciente") as! PacienteViewController;
        self.present(vc, animated: true, completion: nil);
    }
    
    @objc func archivarCompartirConsulta(sender: CustomLongPress) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: self.tablaConsultas);
            if let _ = self.tablaConsultas.indexPathForRow(at: touchPoint) {
                if let consultas = sender.consultas {
                    if (consultas.count > 0) {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_custom_archivar_compartir_consulta") as! CustomArchivarCompartirConsultaViewController;
                        vc.consultas = consultas;
                        presenter.presentationType = .alert;
                        customPresentViewController(presenter, viewController: vc, animated: true, completion: nil);
                    }
                } else {
                    Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE);
                }
            }
        } else {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE);
        }
    }
    
}

extension ConsultaViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listaPacientes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda_consulta") as! ConsultaTableViewCell;
        
        if (self.listaPacientes.count > indexPath.row) {
            let paciente = self.listaPacientes[indexPath.row];
            
            celda.lblNombre.text = "\(paciente.name!) \(paciente.last_name!)";
            celda.lblFecha.text = self.diccionarioConsultas[paciente.id!]?.first?.created_at;
            celda.imgEstado.image = UIImage(named: Constantes.ESTADO_CONSULTA_IMAGEN[self.tabActiva] ?? "sin_enviar");
            celda.lblEstado.text = Constantes.ESTADO_CONSULTA_TEXTO[self.tabActiva];
            
            celda.selectionStyle = .none;
            
            if (celda.paciente == nil) {
                celda.paciente = paciente;
            }
            if (celda.informacionPaciente == nil) {
                celda.informacionPaciente = self.diccionarioInformacionPaciente[paciente.id!]!.last;
            }
            if (celda.diccionarioConsultas[paciente.id!] == nil) {
                celda.diccionarioConsultas[paciente.id!] = self.diccionarioConsultas[paciente.id!];
            }
            if (celda.padreViewController == nil) {
                celda.padreViewController = self;
            }
            
            // Para pestaña resueltos
            if(self.tabActiva == 1) {
                celda.estaAgregarConsultaVisible = true;
            } else {
                celda.estaAgregarConsultaVisible = false;
            }
            
            let longPressRecognizer = CustomLongPress(target: self, action: #selector(self.archivarCompartirConsulta(sender:)));
            // Se envían solo las consultas con estado resuelto
            longPressRecognizer.consultas = self.diccionarioConsultas[paciente.id!]?.filter({$0.status == 1});
            self.tablaConsultas.addGestureRecognizer(longPressRecognizer);
            
            // Al recargar la tabla se cierran las secciones de todas las celdas.
            if(celda.estaAdicionalesVisible) {
                celda.mostrarOcultarAdicionales();
                if let index = selectedCellIndexPath.firstIndex(of: indexPath) {
                    selectedCellIndexPath.remove(at: index);
                }
            }
            
            celda.activarDelegados();
        }
        
        return celda;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.visibleCells.count > 0) {
            for cell in tableView.visibleCells {
                let celda = cell as! ConsultaTableViewCell;
                Funcionales.ocultarSeccion(vistaController: (celda.padreViewController?.view)!, vista: celda.vistaAgregarConsulta, altoInicial: celda.altoVistaAgregarConsulta, animado: true);
            }
        }
        
        let celda = tableView.cellForRow(at: indexPath) as! ConsultaTableViewCell;
        
        tableView.beginUpdates();
        
        if let index = selectedCellIndexPath.firstIndex(of: indexPath) {
            selectedCellIndexPath.remove(at: index);
        } else {
            selectedCellIndexPath.removeAll();
            selectedCellIndexPath.append(indexPath);
            celda.tablaInternos.reloadData();
            celda.estaAdicionalesVisible = false;
        }
        
        // Al tocar se oculta o muestra la sección de adicionales.
        celda.mostrarOcultarAdicionales();
        
        tableView.endUpdates();
        
        if selectedCellIndexPath.contains(indexPath) {
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedCellIndexPath.contains(indexPath) {
            return selectedCellHeight;
        }
        return unselectedCellHeight;
    }
}
