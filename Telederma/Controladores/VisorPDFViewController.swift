//
//  VisorPDFViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/08/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import PDFKit

class VisorPDFViewController: UIViewController {

    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var vistaPDF: UIView!
    
    // Variables para el manejo de los documentos
    var urlDocumento: String!;
    var tituloHeader: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Do any additional setup after loading the view.
        self.header.topItem?.title = self.tituloHeader;
        self.header.standardAppearance.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.cargarDocumento();
    }
    
    private func cargarDocumento () {
        // Add PDFView to view controller.
        let pdfView = PDFView(frame: self.view.bounds);
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.vistaPDF.addSubview(pdfView);
        
        // Fit content in PDFView.
        pdfView.autoScales = true;
        
        // Load Sample.pdf file from app bundle.
        let fileURL = Bundle.main.url(forResource: self.urlDocumento, withExtension: "pdf");
        pdfView.document = PDFDocument(url: fileURL!);
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
