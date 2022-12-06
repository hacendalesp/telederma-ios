//
//  DetalleTicketViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 26/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class DetalleTicketViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblAsunto: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    
    @IBOutlet weak var vistaASunto: UIView!
    @IBOutlet weak var vistaDescripcion: UIView!
    
    @IBOutlet weak var vistaImagenUsuario: UIView!
    @IBOutlet weak var imgUsuario: UIImageView!
    
    @IBOutlet weak var vistaRespuesta: UIView!
    @IBOutlet weak var lblRespuesta: UILabel!
    
    @IBOutlet weak var vistaImagenRespuesta: UIView!
    @IBOutlet weak var imgRespuesta: UIImageView!
    
    @IBOutlet weak var altoImagenUsuario: NSLayoutConstraint!
    @IBOutlet weak var altoRespuesta: NSLayoutConstraint!
    @IBOutlet weak var altoImagenRespuesta: NSLayoutConstraint!
    
    // Variables locales para el manejo del alto inicial
    var imagenUsuarioHeight: CGFloat!;
    var respuestaHeight: CGFloat!;
    var imagenRespuestaHeight: CGFloat!;
    
    // Variables para gestión de los datos
    var ticketId: Int?;
    let fileManager = FileManager.default;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes en estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.vistaASunto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaASunto.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        self.vistaDescripcion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaDescripcion.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        self.vistaRespuesta.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaRespuesta.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        self.vistaImagenUsuario.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaImagenUsuario.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        self.vistaImagenRespuesta.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaImagenRespuesta.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        // Se asignan los altos inciales
        self.imagenUsuarioHeight = self.altoImagenUsuario.constant;
        self.respuestaHeight = self.altoRespuesta.constant;
        self.imagenRespuestaHeight = self.altoImagenRespuesta.constant;
        
        // Se ocultan los elementos que no son obligatorios
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaImagenUsuario, altoInicial: self.altoImagenUsuario, animado: true);
        
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaRespuesta, altoInicial: self.altoRespuesta, animado: true);
        
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaImagenRespuesta, altoInicial: self.altoImagenRespuesta, animado: true);
        
        self.obtenerDetalleTicket();
    }
    
    @objc func verImagenDetalle(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView;
        // And some actions
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_imagen_detalle") as! ImagenDetalleViewController;
        vc.imagenFotoDetalle = tappedImage.image;
        self.present(vc, animated: true, completion: nil);
    }
    
    /**
     Permite consultar la información de un ticket desde la base de datos interna, y descargar la imagen si existe.
     */
    private func obtenerDetalleTicket () {
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        if let ticket = FachadaDependientesSQL.seleccionarPorIdHelpDesk(conexion: conexion, idRegistro: self.ticketId!) {
            
            self.lblAsunto.text = ticket.subject;
            self.lblDescripcion.text = ticket.descriptions;
            
            if let respuesta = ticket.response_ticket {
                self.lblRespuesta.text = respuesta;
                
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaRespuesta, altoInicial: self.altoRespuesta, altoAuxiliar: self.respuestaHeight, animado: true);
            }
            
            if let imagen_usuario = ticket.image_user {
                // Se muestra la vista de la imagen
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaImagenUsuario, altoInicial: self.altoImagenUsuario, altoAuxiliar: self.imagenUsuarioHeight, animado: true);
                
                self.descargarImagen(imagenUrl: imagen_usuario, grupo: Constantes.GRUPO_MESA_AYUDA, identificador: ticket.ticket!, nombre: "image_user", ticket: ticket.ticket!);
            }
            
            if let imagen_admin = ticket.image_admin {
                // Se muestra la vista de la imagen
                Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaImagenRespuesta, altoInicial: self.altoImagenRespuesta, altoAuxiliar: self.imagenRespuestaHeight, animado: true);
                
                self.descargarImagen(imagenUrl: imagen_admin, grupo: Constantes.GRUPO_MESA_AYUDA, identificador: ticket.ticket!, nombre: "image_admin", ticket: ticket.ticket!);
            }
        }
    }
    
    /**
     Permite descargar una imagen para mostrarla en el detalle del ticket.
     - Parameter imageUrl: Corresponde al la dirección electrónica desde la cual se descarga la imagen.
     - Parameter grupo: Corresponde al grupo al cuál pertenecerá la imagen.
     - Parameter identificador: Corresponde al valor al cual se asociará el recurso dentro del grupo.
     - Parameter nombre: Corresponde al nombre del campo imagen según modelo.
     - Parameter ticket: Corresponde al valor del campo ticket del objeto.
     */
    private func descargarImagen (imagenUrl: String, grupo: String, identificador: String, nombre: String, ticket: String) {
        
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                let resultado = Funcionales.descargarImagenSincrono(imagenUrl: imagenUrl);
                
                DispatchQueue.main.async(execute: {
                    
                    switch (resultado.result) {
                    case let .success(image):
                        print("image downloaded: \(image)")
                        
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
                                self.cargarImagen(ticket: ticket, campoImagen: nombre);
                                print("En disco imagen: \(filename)");
                            } catch {
                                self.errorCargarImagen(campoImagen: nombre);
                                print("Error imagen: \(error)");
                            }
                        }
                        break;
                        
                    case let .failure(error):
                        print(error);
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                        break;
                    }
                });
            });
        }
    }
    
    private func errorCargarImagen (campoImagen: String) {
        let imagenError = UIImage(named: "error_cargar");
        if (campoImagen == "image_user") {
            self.imgUsuario.image = imagenError;
        } else {
            self.imgRespuesta.image = imagenError;
        }
    }
    
    private func cargarImagen (ticket: String, campoImagen: String) {
        let fileManager = FileManager.default;
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // Se busca imagen de usuario.
            if let data = try? Data(contentsOf: tDocumentDirectory.appendingPathComponent("\(Constantes.GRUPO_MESA_AYUDA)\(ticket)_\(campoImagen).png")) {
                if let image = UIImage(data: data) {
                    
                    // Se añade evento a la imagen
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.verImagenDetalle(tapGestureRecognizer:)));
                                        
                    if (campoImagen == "image_user") {
                        self.imgUsuario.contentMode = .scaleAspectFill;
                        self.imgUsuario.image = image;
                        
                        self.imgUsuario.isUserInteractionEnabled = true;
                        self.imgUsuario.addGestureRecognizer(tapGestureRecognizer);
                    } else {
                        self.imgRespuesta.contentMode = .scaleAspectFill;
                        self.imgRespuesta.image = image;
                        
                        self.imgRespuesta.isUserInteractionEnabled = true;
                        self.imgRespuesta.addGestureRecognizer(tapGestureRecognizer);
                    }
                }
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
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
