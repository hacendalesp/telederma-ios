//
//  LoginViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/02/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var btnIngresar: UIButton!
    @IBOutlet weak var btnNuevo: UIButton!
    @IBOutlet weak var btnOlvideContrasenia: UIButton!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblBienvenido: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    /**
     El método permite incializar estilos o cualquier tipo de acción al momento de iniciar el View.
     Es el único método que se llama desde el método viewDidLoad.
     */
    private func inits(){
        // Aplicar estilos a los bordes
        self.btnIngresar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnNuevo.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtUsuario.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtPassword.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.recuperarEspacioTeclado();
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        
    }
    
    private func recuperarEspacioTeclado () {
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    /**
     Permite validar que los campos no estén vacíos.
     - Returns: Devuelve TRUE si los campos son válidos, es decir no están vacíos. FALSE en caso contrario.
     */
    private func validarCampos () -> Bool {
        var camposValidos = false;
        camposValidos = !Validacion.sonCamposVacios(textos: [self.txtUsuario, self.txtPassword]);
        return camposValidos;
    }
    
    /**
     Permite guardar la información en la base de datos loca, del usuario quien inicia sesión, e inicia la vista de consultas.
     - Parameter usuario: Corresponde al objeto usuario que contiene toda la información del servidor.
     */
    private func finalizarInicioSesion (usuario: Usuario) {
        var guardado = false;
        // Se crea la conexión para la consulta con base de datos.
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        // Se comprueba si el usuario se encuentra en la base de datos local.
        // Si el usuario ya existe, se actualiza la información.
        if (FachadaIndependientesSQL.seleccionarPorIdUsuario(conexion: conexion, idRegistro: usuario.id!) != nil) {
            let actualizado = FachadaIndependientesSQL.actualizarRegistroUsuario(conexion: conexion, idRegistro: usuario.id!, data: usuario);
            if (actualizado > 0) {
                guardado = true;
            }
        } else {
            // Si no existe, se registra.
            let insertado = FachadaIndependientesSQL.insertarRegistrosUsuario(conexion: conexion, data: [usuario]);
            if (insertado > 0) {
                guardado = true;
            }
        }
        
        if(guardado) {
            // Se guarda la información del usuario logueado en los ficheros del dispositivo UserDefaults.
            Funcionales.iniciarCerrarSesion(usuario: usuario, estaIniciando: true);
            
            // Se inicia el proceso de descarga de imágenes asociadas al usuario: firma y perfil.
            Funcionales.descargarImagenesUsuario(usuario: usuario);
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_consulta") as! ConsultaViewController;
            self.present(vc, animated: true, completion: nil);
        }
        
    }
    
    // Comportamiento teclado para que se recupere el espacio que ocupa al aparecer
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return;
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height + 50;
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func accionIngresar(_ sender: UIButton) {
        if(self.validarCampos()){
            
            // Se inhabilita del botón iniciar sesión.
            Funcionales.activarDesactivarBoton(boton: self.btnIngresar, texto: "Iniciando ...", color: .lightGray, activo: false);
            
            let documento = self.txtUsuario.text!;
            let password = self.txtPassword.text!;
            
            DispatchQueue.global(qos: .userInitiated).async {
                let request = FachadaHTTPDependientes.iniciarSesion(documento: documento, password: password);
                
                DispatchQueue.main.async {
                    switch request {
                    case let .success(data):
                        print(data);
                        // Se transforma la información en un arreglo.
                        let json = JSON(arrayLiteral: data);
                        if (json[0]["error"] != nil) {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                        } else {
                            let usuario = Usuario(JSONString: json[0]["user"].description);
                            // Se almacenan las rutas de los archivos por separado.
                            usuario?.image_digital = json[0]["user"]["image_digital"]["url"].description;
                            usuario?.photo = json[0]["user"]["photo"]["url"].description;
                            usuario?.sincronizado = true;
                            
                            self.finalizarInicioSesion(usuario: usuario!);
                        }
                        
                        // Se activa nuevamente el botón
                        Funcionales.activarDesactivarBoton(boton: self.btnIngresar, texto: "Ingresar", color: Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                        
                    case let .failure(error):
                        print("Error: \(error)");
                        // Se activa nuevamente el botón
                        Funcionales.activarDesactivarBoton(boton: self.btnIngresar, texto: "Ingresar", color: Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                        
                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                    }
                }
            }                        
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        }
    }
}

