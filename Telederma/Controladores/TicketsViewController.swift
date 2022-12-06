//
//  TicketsViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 25/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class TicketsViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var vistaCabecera: UIView!
    @IBOutlet weak var tablaTickets: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    // Variables locales
    var listaTickets = [HelpDesk]();
    var refreshControl = UIRefreshControl();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes en estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.vistaCabecera.layer.borderColor = Constantes.COLOR_BOTON_SECUNDARIO.cgColor;
        self.vistaCabecera.layer.borderWidth = 1.0;
        
        self.loading.hidesWhenStopped = true;
        
        self.tablaTickets.delegate = self;
        self.tablaTickets.dataSource = self;
                
        // Se configura pull para refrescar la tabla
        self.refreshControl.attributedTitle = NSAttributedString(string: "Recargando")
        self.refreshControl.addTarget(self, action: #selector(self.recargar(_:)), for: .valueChanged);
        self.tablaTickets.addSubview(self.refreshControl);
        
        // Se obtiene la información del servidor.
        self.obtenerTicketsHttp();
        
    }
    
    @objc func recargar(_ sender: AnyObject) {
       // Code to refresh table view
        self.obtenerTicketsHttp();
    }
    
    private func obtenerTicketsHttp () {
        self.loading.startAnimating();
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.obtenerTodoHttpTickets();
            
            DispatchQueue.main.async(execute: {
                switch (resultado) {
                case let .success(data):
                    print(data);
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
                        if(json[0].arrayValue.count > 0) {
                            // Se inicializa la lista de tickets.
                            self.listaTickets = [];
                            
                            // Se almacena en base de datos
                            let conexion = Conexion();
                            conexion.conectarBaseDatos();
                            
                            for helpDesk in json[0].arrayValue {
                                if let ticket = HelpDesk(JSONString: helpDesk.description) {
                                    self.listaTickets.append(ticket);
                                    
                                    let insertar = FachadaDependientesSQL.insertarRegistrosHelpDesk(conexion: conexion, data: [ticket]);
                                    
                                    if (insertar < 1) {
                                        let _ = FachadaDependientesSQL.actualizarRegistroHelpDesk(conexion: conexion, idRegistro: ticket.id!, data: ticket);
                                    }
                                }
                            }
                            self.tablaTickets.reloadData();
                                                                                
                        }
                    }
                    self.loading.stopAnimating();
                    self.refreshControl.endRefreshing();
                    break;
                case let .failure(error):
                    print(error);
                    self.loading.stopAnimating();
                    self.refreshControl.endRefreshing();
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    break;
                }
            });
        });
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
    
}

extension TicketsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listaTickets.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ticket = self.listaTickets[indexPath.row];
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda_ticket") as! TicketTableViewCell;
        celda.lblTicket.text = ticket.ticket;
        celda.lblAsunto.text = ticket.subject;
        celda.lblEstado.text = Constantes.ESTADO_HELPDESK_TEXTO[ticket.status!];
        celda.imgEstado.image = UIImage(named: Constantes.ESTADO_HELPDESK_IMAGEN[ticket.status!] ?? "sin_enviar");
        
        celda.selectionStyle = .none;
        
        return celda;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticket = self.listaTickets[indexPath.row];
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_detalle_ticket") as! DetalleTicketViewController;
        vc.ticketId = ticket.id;
        self.present(vc, animated: true, completion: nil);
    }
    
    
}
