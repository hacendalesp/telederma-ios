//
//  MesaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 23/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class MesaViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inits();
    }

    private func inits () {
        // Ajustes en estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnEnviar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTickets.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_gestion") as! GestionViewController;
        self.present(vc, animated: true, completion: nil);
    }
    
}
