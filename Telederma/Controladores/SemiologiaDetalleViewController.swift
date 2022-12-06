//
//  SemiologiaDetalleViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/08/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class SemiologiaDetalleViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var imgIlustracion: UIImageView!
    @IBOutlet weak var lblTexto: UITextView!
    
    var titulo: String!;
    var imagen: UIImage!;
    var ilustracion: UIImage!;
    var texto: String!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        self.header.topItem?.title = self.titulo;
        self.imgImagen.image = self.imagen;
        self.imgIlustracion.image = self.ilustracion;
        self.lblTexto.text = self.texto;
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
