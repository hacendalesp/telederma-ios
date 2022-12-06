//
//  CertificacionViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 17/08/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class CertificacionViewController: UIViewController {
    
    @IBOutlet weak var vista1: UIView!
    @IBOutlet weak var vista2: UIView!
    @IBOutlet weak var vista3: UIView!
    @IBOutlet weak var vista4: UIView!
    @IBOutlet weak var vista5: UIView!
    @IBOutlet weak var vista6: UIView!
    @IBOutlet weak var vista7: UIView!
    @IBOutlet weak var vista8: UIView!
    @IBOutlet weak var vista9: UIView!
    @IBOutlet weak var vista10: UIView!
    
    @IBOutlet weak var btn1a: UIButton!
    @IBOutlet weak var btn1b: UIButton!
    @IBOutlet weak var btn1c: UIButton!
    @IBOutlet weak var btn1d: UIButton!
    
    @IBOutlet weak var btn2a: UIButton!
    @IBOutlet weak var btn2b: UIButton!
    @IBOutlet weak var btn2c: UIButton!
    @IBOutlet weak var btn2d: UIButton!
    
    @IBOutlet weak var btn3a: UIButton!
    @IBOutlet weak var btn3b: UIButton!
    @IBOutlet weak var btn3c: UIButton!
    @IBOutlet weak var btn3d: UIButton!
    
    @IBOutlet weak var btn4a: UIButton!
    @IBOutlet weak var btn4b: UIButton!
    @IBOutlet weak var btn4c: UIButton!
    @IBOutlet weak var btn4d: UIButton!
    
    @IBOutlet weak var btn5a: UIButton!
    @IBOutlet weak var btn5b: UIButton!
    @IBOutlet weak var btn5c: UIButton!
    @IBOutlet weak var btn5d: UIButton!
    
    @IBOutlet weak var btn6a: UIButton!
    @IBOutlet weak var btn6b: UIButton!
    @IBOutlet weak var btn6c: UIButton!
    @IBOutlet weak var btn6d: UIButton!
    
    @IBOutlet weak var btn7verdadero: UIButton!
    @IBOutlet weak var btn7falso: UIButton!
    
    @IBOutlet weak var btn8verdadero: UIButton!
    @IBOutlet weak var btn8falso: UIButton!
    
    @IBOutlet weak var btn9a: UIButton!
    @IBOutlet weak var btn9b: UIButton!
    @IBOutlet weak var btn9c: UIButton!
    @IBOutlet weak var btn9d: UIButton!
    
    @IBOutlet weak var btn10a: UIButton!
    @IBOutlet weak var btn10b: UIButton!
    @IBOutlet weak var btn10c: UIButton!
    @IBOutlet weak var btn10d: UIButton!
    
    @IBOutlet weak var btnEnviar: UIButton!
    
    // Variables de selección
    var seleccionados = [Int: String]();
    var respuestas = [
        1: "1",
        2: "4",
        3: "4",
        4: "2",
        5: "1",
        6: "2",
        7: "1",
        8: "1",
        9: "2",
        10: "3"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes de estilos
        self.btnEnviar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.vista1.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista2.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista3.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista4.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista5.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista6.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista7.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista8.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista9.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.vista10.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.btn1a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn1b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn1c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn1d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn2a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn2b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn2c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn2d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn3a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn3b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn3c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn3d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn4a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn4b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn4c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn4d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn5a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn5b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn5c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn5d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn6a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn6b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn6c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn6d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn7verdadero.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn7falso.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn8verdadero.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn8falso.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn9a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn9b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn9c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn9d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn10a.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn10b.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn10c.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
        self.btn10d.addTarget(self, action: #selector(self.accionSeleccionarOpcion(sender:)), for: .touchUpInside);
    }
    
    /**
     Permite controlar la selección de las diferentes opciones del cuestionario.
     */
    @objc func accionSeleccionarOpcion(sender: UIButton!) {
        
        // Son las preguntas de 1 hasta 9
        let pregunta = String(sender.tag);
        if (pregunta.count < 3) {
            switch pregunta.first {
            case "1":
                self.btn1a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn1b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn1c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn1d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[1] = String(pregunta.last!);
            case "2":
                self.btn2a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn2b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn2c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn2d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[2] = String(pregunta.last!);
            case "3":
                self.btn3a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn3b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn3c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn3d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[3] = String(pregunta.last!);
            case "4":
                self.btn4a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn4b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn4c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn4d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[4] = String(pregunta.last!);
            case "5":
                self.btn5a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn5b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn5c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn5d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[5] = String(pregunta.last!);
            case "6":
                self.btn6a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn6b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn6c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn6d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[6] = String(pregunta.last!);
            case "7":
                self.btn7verdadero.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn7falso.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[7] = String(pregunta.last!);
            case "8":
                self.btn8verdadero.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn8falso.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[8] = String(pregunta.last!);
            case "9":
                self.btn9a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn9b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn9c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.btn9d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                self.seleccionados[9] = String(pregunta.last!);
            default:
                break;
            }
        } else {
            // Es la pregunta 10
            self.btn10a.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            self.btn10b.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            self.btn10c.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            self.btn10d.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            self.seleccionados[10] = String(pregunta.last!);
        }
        
        sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
    }
    
    private func enviarCalificacion () {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviando ...", color: nil, activo: false);
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.certificarUsuario();
            
            DispatchQueue.main.async(execute: {
                
                switch  resultado {
                case let .success(data):
                    print(data);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["user"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONVERSION_DATA);
                        }
                    } else {
                        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: {
                            (UIAlertAction) in
                            self.dismiss(animated: true, completion: nil);
                        });
                        
                        let alerta = UIAlertController(title: "Certificación", message: json[0]["message"].description, preferredStyle: .alert);
                        alerta.addAction(accion);
                        
                        self.present(alerta, animated: true, completion: nil);
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar respuestas", color:  Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
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
    
    @IBAction func accionEnviar(_ sender: UIButton) {
        var contador = 0;
        
        if (self.seleccionados.count >= 7) {
            for (index, respuesta) in self.seleccionados {
                if (self.respuestas[index] == respuesta) {
                    contador += 1;
                }
            }
        }
        
        if (contador < 7) {
            let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: {
                (UIAlertAction) in
                self.dismiss(animated: true, completion: nil);
            });
            
            let alerta = UIAlertController(title: "Certificación", message: Mensajes.MENSAJE_CERTIFICACION_MAL, preferredStyle: .alert);
            alerta.addAction(accionAceptar);
            
            self.present(alerta, animated: true, completion: nil);
        } else {
            // Se envían el usuario para la certificación.
            self.enviarCalificacion();
        }
    }
    
    
}
