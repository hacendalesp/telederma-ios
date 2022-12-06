//
//  CustomRequerimientoDescartarViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/09/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CustomRequerimientoDescartarViewController: UIViewController {
    
    @IBOutlet weak var vistaRazones: UIView!
    @IBOutlet weak var txtOtro: UITextField!
    @IBOutlet weak var btnDescartar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    

    let conexion = Conexion();
    var listaRazones = [ConstanteValor]();
    var razonSeleccionada = 0;
    var botonesRazones = [UIButton]();
    var requerimientoId: Int!;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        self.btnDescartar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCancelar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.conexion.conectarBaseDatos();
        self.crearRazones();
    }

    /**
     Permite crear la lista de síntomas desde la base de datos interna.
     */
    private func crearRazones () {
        self.listaRazones = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "reason");
        let cantidadRazones = self.listaRazones.count;
        if (cantidadRazones > 0) {
            var altoSiguienteBoton = 0;
            let anchoBoton = Constantes.BOTON_DINAMICO_ANCHO;
            let altoBoton = Constantes.BOTON_DINAMICO_ALTO;
            
            for (index, item) in self.listaRazones.enumerated() {
                let button = UIButton(type: .custom);
                button.setTitle(item.title, for: .normal);
                button.setTitleColor(.darkGray, for: .normal);
                button.frame = CGRect(x: Constantes.BOTON_DINAMICO_X, y: altoSiguienteBoton, width: anchoBoton, height: altoBoton);
                button.contentHorizontalAlignment = .left;
                
                if (item.value == 3 && MemoriaRegistroConsulta.controlMedico == nil) {
                    if (MemoriaRegistroConsulta.consultaMedica == nil || MemoriaRegistroConsulta.consultaMedica?.change_symptom == 3) {
                        
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
                        self.razonSeleccionada = item.value!;
                    } else {
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                    }
                } else {
                    button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                }
                button.tag = item.value!;
                button.tintColor = .darkGray;
                button.titleEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO;
                button.imageEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN;
                button.addTarget(self, action: #selector(self.accionCambiarEmpeora(sender:)), for: .touchUpInside);
                self.botonesRazones.append(button);
                
                altoSiguienteBoton += altoBoton + Constantes.BOTON_DINAMICO_SIGUIENTE_BOTON_Y;
                
                
                self.vistaRazones.addSubview(button);
                // Al último se le agregan constraints para activar el scroll.
                if (index == (self.listaRazones.count - 1)) {
                    let verConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self.vistaRazones, attribute: .bottomMargin,                     multiplier: 1.0, constant: 0.0);
                    
                    self.vistaRazones.addConstraint(verConstraint);
                }
            } // End for
        }
    }
    
    private func quitarSeleccionBotonesEmpeoran () {
        // Los botones no se eliminan de la lista, se usan para desactivarlos.
        if (self.botonesRazones.count > 0) {
            for boton in self.botonesRazones {
                boton.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            }
            self.razonSeleccionada = 0;
        }
    }
    
    /**
     Permite controlar la elección de empeora y actualizar el boton para mostrarse según la acción del usuario: seleccionado o no.
     */
    @objc func accionCambiarEmpeora(sender: UIButton!) {
        self.quitarSeleccionBotonesEmpeoran();
        
        sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
        self.razonSeleccionada = sender.tag;
    }
    
    /**
     Permite enviar la información.
     - Parameter adicionales: Corresponde a los datos de verificación de usuario que se añaden a la información del formulario.
     */
    private func descartarRequerimiento (adicionales: [String: Any]) {
        // Se inactiva el botón de envío de la petición.
        Funcionales.activarDesactivarBoton(boton: self.btnDescartar, texto: "Enviando ...", color: Constantes.COLOR_BOTON_SECUNDARIO, activo: false);
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.descartarRequerimiento(adicionales: adicionales);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case let .success(data):
                    print(data);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta contiene un error ...
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
                        self.dismiss(animated: true, completion: nil);
                    }
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnDescartar, texto: "Descartar requerimiento", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnDescartar, texto: "Descartar requerimiento", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
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
    @IBAction func accionDescartar(_ sender: UIButton) {
        var adicionales = [String: Any]();
        adicionales["request[id]"] = self.requerimientoId;
        adicionales["request[reason]"] = self.razonSeleccionada;
        adicionales["request[other_reason] "] = self.txtOtro.text;
        
        self.descartarRequerimiento(adicionales: adicionales);
    }
    
    @IBAction func accionCancelar(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
