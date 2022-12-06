//
//  RegistroPacienteController4ViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 28/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class RegistroPacienteViewController4: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var btnCuerpo: UIButton!
    
    let conexion = Conexion();
    var listaGeneros = [ConstanteValor]();
    var cuerpoDeFrente = true;
    var paciente: Paciente?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Para control médico no se muestra el título paso 4
        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
            self.lblTituloHeader.isHidden = true;
            self.paciente = MemoriaHistoriaClinica.paciente;
        } else {
            self.paciente = MemoriaRegistroPaciente.paciente;
        }
        
        self.conexion.conectarBaseDatos();
        self.cargarInformacionBase();
    }
    
    private func cargarInformacionBase (){
        self.listaGeneros = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "genre");
        self.rotarCuerpo();
    }
    
    private func rotarCuerpo () {
        if let paciente = self.paciente {
            if let genero = self.listaGeneros.first(where: {$0.value == paciente.genre}) {
                if (self.cuerpoDeFrente) {
                    self.btnCuerpo.setBackgroundImage(UIImage(named: "\(genero.title?.lowercased() ?? "masculino")_frente"), for: .normal);
                } else {
                    self.btnCuerpo.setBackgroundImage(UIImage(named: "\(genero.title?.lowercased() ?? "masculino")_espalda"), for: .normal);
                }
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionRotarCuerpo(_ sender: UIButton) {
        self.cuerpoDeFrente = !self.cuerpoDeFrente;
        self.rotarCuerpo();
    }
    @IBAction func accionTomarImagenes(_ sender: UIButton) {
        // Se guarda el id del cuerpo 182
        MemoriaRegistroConsulta.lesion = Lesion();
        MemoriaRegistroConsulta.lesion?.body_area_id = 182;
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        if (MemoriaRegistroConsulta.estaControlMedicoActivo) {
            // Se eliminan las imágnes de anexos y se activa modo anexos.
            MemoriaRegistroConsulta.listaFotosAnexos = [];
            MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos = [];
            self.dismiss(animated: true, completion: nil);
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_3") as! RegistroPacienteViewController3;
            self.present(vc, animated: true, completion: nil);
        }
    }
}
