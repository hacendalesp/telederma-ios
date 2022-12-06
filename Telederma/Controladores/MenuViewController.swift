//
//  MenuViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 29/05/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    
    // Variables para la información del usuario.
    var imgFotoPerfil: UIImage?;
    var nombrePerfil: String?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes estilos
        Funcionales.redondearVista(view: self.imgPerfil);
        
        // Se obtienen los datos de la sesión.
        let nombreSesion = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_NOMBRE) as? String;
        let documentoSesion = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_DOCUMENTO) as? String;
        
        if (self.nombrePerfil == nil) {
            // Se carga el nombre del usuario, desde el fichero de configuración.
            self.nombrePerfil = nombreSesion;
        }
        self.lblNombre.text = self.nombrePerfil;
        
        if (self.imgFotoPerfil == nil) {
            let fileManager = FileManager.default;
            // Se valida el gestor de archivos
            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                // Se busca imagen de perfil.
                if let data = try? Data(contentsOf: tDocumentDirectory.appendingPathComponent("\(Constantes.GRUPO_USUARIO)\(documentoSesion ?? "")_photo.png")) {
                    if let image = UIImage(data: data) {
                        self.imgFotoPerfil = image;
                    }
                } else {
                    self.imgFotoPerfil = UIImage(named: "perfil_defecto");
                }
            }
        }
        
        self.imgPerfil.image = self.imgFotoPerfil;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionCerrarSesion(_ sender: UIButton) {
        let accionConfirmar = UIAlertAction(title: "Cerrar Sesión", style: .destructive, handler: {
            (UIAlertAction) in
            //let conexion = Conexion();
            
            // Eliminar información de la sesión.
            Funcionales.iniciarCerrarSesion(usuario: nil, estaIniciando: false);
            
            //conexion.borrarBaseDeDatos();
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_login") as! LoginViewController;
            self.present(vc, animated: true, completion: nil);
        });
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil);
        
        let alerta = UIAlertController(title: "Cerrar Sesión", message: "¿Desea salir y cerrar su sesión en el dispositivo?", preferredStyle: .alert);
        alerta.addAction(accionConfirmar);
        alerta.addAction(accionCancelar);
        
        self.present(alerta, animated: true, completion: nil);
    }
    
}
