//
//  GestionViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 14/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class GestionViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var btnPerfil: UIButton!
    @IBOutlet weak var btnMesaAyuda: UIButton!
    @IBOutlet weak var btnCreditos: UIButton!
    @IBOutlet weak var btnAvisoLegal: UIButton!
    
    @IBOutlet weak var btnAcerca: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.btnPerfil.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnMesaAyuda.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCreditos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnAvisoLegal.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func accionAcercaTelederma(_ sender: UIButton) {
    }
    
    @IBAction func accionAvisoLegal(_ sender: UIButton) {
    }
    
}
