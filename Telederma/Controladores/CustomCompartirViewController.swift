//
//  CustomCompartirViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/09/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomCompartirViewController: UIViewController {
    
    @IBOutlet weak var vistaConsultasPaciente: UIView!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var scrollDiagnosticos: UIScrollView!
    

    // Información de consultas
    var listaConsultas: [ConsultaMedica]!;
    
    // Lleva el control de los botones seleccionados
    var diagnosticosSeleccionados = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        self.btnEnviar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCancelar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vistaConsultasPaciente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.crearDiagnosticos();
    }
    
    /**
     Permite enviar la consulta compartida con los diagnósticos seleccionados
     */
    private func compartirConsultas () {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviando ...", color: .lightGray, activo: false);
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.compartirConsulta(consultaIds: self.diagnosticosSeleccionados);
            
            DispatchQueue.main.async(execute: {
                
                switch  resultado {
                case let .success(data):
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
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
                        Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.ARCHIVAR_MENSAJE_REVISAR_CORREO);
                        self.dismiss(animated: true, completion: nil);
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            });
        });
    }
    
    /**
     Permite crear la lista de evoluciones desde la base de datos interna.
     */
    private func crearDiagnosticos () {
        
        let cantidadDiagnosticos = self.listaConsultas.count;
        if (cantidadDiagnosticos > 0) {
            var altoSiguienteBoton = 0;
            let anchoBoton = Constantes.BOTON_DINAMICO_ANCHO;
            let altoBoton = Constantes.BOTON_DINAMICO_ALTO + 25;
            
            for (index, item) in self.listaConsultas.enumerated() {
                let button = UIButton(type: .custom);
                button.setTitle(item.diagnostic_impression, for: .normal);
                button.setTitleColor(.darkGray, for: .normal);
                button.frame = CGRect(x: Constantes.BOTON_DINAMICO_X, y: altoSiguienteBoton, width: anchoBoton, height: altoBoton);
                button.contentHorizontalAlignment = .left;
                button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
                button.tag = item.id!;
                button.titleLabel?.font = UIFont(name: "System", size: 7);
                button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
                button.tintColor = .darkGray;
                button.titleEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO;
                button.imageEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN;
                button.addTarget(self, action: #selector(self.accionCambiarEvolucion(sender:)), for: .touchUpInside);
                
                // Posición en Y para el siguiente botón
                altoSiguienteBoton += altoBoton + Constantes.BOTON_DINAMICO_SIGUIENTE_BOTON_Y;
                
                self.vistaConsultasPaciente.addSubview(button);
                // Al último se le agregan constraints para activar el scroll.
                if (index == (self.listaConsultas.count - 1)) {
                    let verConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self.vistaConsultasPaciente, attribute: .bottomMargin, multiplier: 0.9, constant: 0.0);
                    
                    self.vistaConsultasPaciente.addConstraint(verConstraint);
                }
            }
        }
    }
    
    /**
     Permite controlar la elección de evoluciones y actualizar el boton para mostrarse según la acción del usuario: seleccionado o no.
     */
    @objc func accionCambiarEvolucion(sender: UIButton!) {
        // Si el id del evolución ya se encuentra en los seleccionados ...
        if let index = self.diagnosticosSeleccionados.firstIndex(of: sender.tag.description) {
            sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
            self.diagnosticosSeleccionados.remove(at: index);
        } else {
            sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_ON), for: .normal);
            self.diagnosticosSeleccionados.append(sender.tag.description);
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
    
    @IBAction func accionEnviar(_ sender: UIButton) {
        if (self.diagnosticosSeleccionados.count == 0) {
            Validacion.pintarErrorCampoFormulario(view: self.vistaConsultasPaciente);
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.vistaConsultasPaciente, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
            self.compartirConsultas();
        }
    }
    
    @IBAction func accionCancelar(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
