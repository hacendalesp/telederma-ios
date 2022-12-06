//
//  OlvideContraseniaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class OlvideContraseniaViewController: UIViewController {
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var lblFooter: UIView!
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var txtUsuario: UITextField!
    
    let navigationBarAppearace = UINavigationBar.appearance();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inits();
    }
    
    /**
     Permite inicializar y preparar algunas funciones y parte de la estética.
     */
    private func inits() {
        // Ajustes de estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.btnEnviar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.lblFooter.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionEnviar(_ sender: UIButton) {
        // Se valida que el campo no esté vacío
        if (Validacion.esCampoTextoVacio(view: self.txtUsuario)) {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        } else {
            // Se inactiva el botón enviar.
            Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviando ...", color: .lightGray, activo: false);
            
            let documento = self.txtUsuario.text!;
            DispatchQueue.global(qos: .userInitiated).async {
                let httpUsuario = FachadaHTTPDependientes.restablecerPassword(documento: documento);
                
                DispatchQueue.main.async {
                    // Se evalúa la respuesta del servicio.
                    switch httpUsuario {
                    case let .success(data):
                        print(data);
                        // Se convierte la respuesta JSON
                        let json = JSON(arrayLiteral: data);
                        // Se valida si existe algún error en la respuesta.
                        if (json[0]["error"] != nil ) {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                        } else {
                            Funcionales.vaciarCamposTexto(campos: [self.txtUsuario]);
                            Funcionales.mostrarAlerta(view: self, mensaje: json[0]["message"].description);
                        }
                        
                        // Se activa nuevamente el botón enviar.
                        Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color: .systemBlue, activo: true);
                        
                    case let .failure(error):
                        print(error);
                        // Se activa nuevamente el botón enviar.
                        Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color: .systemBlue, activo: true);
                        
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    }
                }
            }
        }
    }
    
}
