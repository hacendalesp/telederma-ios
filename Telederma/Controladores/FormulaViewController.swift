//
//  FormulaViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 20/10/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class FormulaViewController: UIViewController {

    @IBOutlet weak var lblCodigoMedicamento: UILabel!
    @IBOutlet weak var lblTipoMedicamento: UILabel!
    @IBOutlet weak var lblNombreGenerico: UILabel!
    @IBOutlet weak var lblFormaFarmaceutica: UILabel!
    @IBOutlet weak var lblConcentracionMedicamento: UILabel!
    @IBOutlet weak var lblUnidadMedida: UILabel!
    @IBOutlet weak var lblNumeroUnidades: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    
    // Variables locales para asignar valores a elementos UI
    var codigoMedicamento: String?;
    var tipoMedicamento: String?;
    var nombreGenerico: String?;
    var formaFarmaceutica: String?;
    var concentracionMedicamento: String?;
    var unidadMedida: String?;
    var numeroUnidades: String?;
    var descripcion: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lblConcentracionMedicamento.text = (self.codigoMedicamento != nil && self.codigoMedicamento != "") ? self.codigoMedicamento : "Ninguno";
        self.lblTipoMedicamento.text = self.tipoMedicamento;
        self.lblNombreGenerico.text = self.nombreGenerico;
        self.lblFormaFarmaceutica.text = self.formaFarmaceutica;
        self.lblConcentracionMedicamento.text = self.concentracionMedicamento;
        self.lblUnidadMedida.text = self.unidadMedida;
        self.lblNumeroUnidades.text = self.numeroUnidades;
        self.lblDescripcion.text = self.descripcion;
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
