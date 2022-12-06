//
//  WalletViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 14/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class WalletViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var imgWallet: UIImageView!
    @IBOutlet weak var lblCreditosCargados: UILabel!
    @IBOutlet weak var lblCreditosDisponibles: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes en estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.loading.hidesWhenStopped = true;
        
        // Obtener la informaición de créditos del cliente.
        self.obtenerCreditosCliente();
    }
    
    /**
     Obtiene la información desde el servidor.
     */
    private func obtenerCreditosCliente () {
        self.loading.startAnimating();
        
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            let resultado = FachadaHTTPDependientes.obtenerHttpCreditosCliente();
            
            DispatchQueue.main.async(execute: {
                switch (resultado) {
                case let .success(data):
                    let json = JSON(arrayLiteral: data);
                    
                    if (json[0]["total"] != nil) {
                        let formatter = NumberFormatter();
                        formatter.numberStyle = .decimal;
                        formatter.maximumFractionDigits = 0;
                        
                        self.lblCreditosCargados.text = formatter.string(from: NSNumber(value: Int(json[0]["total"].description)!));
                        self.lblCreditosDisponibles.text = formatter.string(from: NSNumber(value: Int(json[0]["consumidos"].description)!));

                    } else {
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    }
                    self.loading.stopAnimating();
                    break;
                case let .failure(error):
                    print("Error http creditos: \(error)");
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    
                    self.loading.stopAnimating();
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
