//
//  ImagenDetalleViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 23/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class ImagenDetalleViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var imgFotoDetalle: UIImageView!
    
    var imagenFotoDetalle: UIImage?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.imgFotoDetalle.image = self.imagenFotoDetalle;
    }
    
    private func inits () {
        // Ajustes en estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
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
        self.imagenFotoDetalle = nil;
        self.imgFotoDetalle.image = self.imagenFotoDetalle;
        self.dismiss(animated: true, completion: nil);
    }
    
}
