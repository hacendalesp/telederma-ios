//
//  CustomArchivarCompartirConsultaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/09/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Presentr

class CustomArchivarCompartirConsultaViewController: UIViewController {
    
    @IBOutlet weak var btnCompartirConsulta: UIButton!
    @IBOutlet weak var btnArchivarConsulta: UIButton!
    
    // Información paciente
    var consultas: [ConsultaMedica]!;
    
    let presenter: Presentr = {
        let width = ModalSize.custom(size: 300.0)
        let height = ModalSize.custom(size: 240.0)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .darkGray
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = false
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        self.btnArchivarConsulta.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCompartirConsulta.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
    }
    
    /**
     Permite archivar una consulta que se encuentra en estado Resuelto
     */
    private func archivarConsulta (consultaId: Int) {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnArchivarConsulta, texto: "", color: nil, activo: false);
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.archivarDesarchivarConsulta(consultaId: consultaId, esArchivar: true);
            
            DispatchQueue.main.async(execute: {
                
                switch  resultado {
                case let .success(data):
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnArchivarConsulta, texto: "", color:  Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
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
                        Funcionales.mostrarAlerta(view: self, mensaje: json[0]["message"].description);
                    }
                    
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnArchivarConsulta, texto: "", color:  Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
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
    @IBAction func accionCompartirConsulta(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_custom_compartir_consulta") as! CustomCompartirViewController;
        vc.listaConsultas = self.consultas;
        self.presenter.presentationType = .popup;
        self.customPresentViewController(self.presenter, viewController: vc, animated: true, completion: nil);
    }
    
    @IBAction func accionArchivarConsulta(_ sender: UIButton) {
        if (self.consultas.count > 0) {
            if let consulta = self.consultas.sorted(by: {$0.id! < $1.id!}).first {
                self.archivarConsulta(consultaId: consulta.id!);
            } else {
                Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE);
            }
        } else {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.ARCHIVAR_MENSAJE_CONSULTA_PENDIENTE);
        }
    }
    
}
