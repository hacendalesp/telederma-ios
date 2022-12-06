//
//  AprendeViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 19/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import PDFKit

class AprendeViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var btnTelederma: UIButton!
    @IBOutlet weak var btnTutorial: UIButton!
    @IBOutlet weak var btnImagenes: UIButton!
    @IBOutlet weak var btnSemiologia: UIButton!
    @IBOutlet weak var btnTomaBiopsia: UIButton!
    @IBOutlet weak var btnCertificacion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.btnTelederma.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTutorial.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnImagenes.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnSemiologia.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTomaBiopsia.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnCertificacion.layer.cornerRadius = Constantes.BORDE_GROSOR;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func accionQueEsTelederma(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_visor_pdf") as! VisorPDFViewController;
        vc.urlDocumento = "que_es_telederma";
        vc.tituloHeader = "¿Qué es Telederma?";
        self.present(vc, animated: true, completion: nil);
    }
    
    
    @IBAction func accionTomaImagenes(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_visor_pdf") as! VisorPDFViewController;
        vc.urlDocumento = "toma_de_imagenes";
        vc.tituloHeader = "Toma de imágenes";
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionSemiologia(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_visor_pdf") as! VisorPDFViewController;
        vc.urlDocumento = "semiologia_anexos";
        vc.tituloHeader = "Semiología cutánea";
        self.present(vc, animated: true, completion: nil);
    }
    
}
