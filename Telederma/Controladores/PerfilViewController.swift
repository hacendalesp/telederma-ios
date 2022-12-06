//
//  PerfilViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 11/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class PerfilViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var btnFirma: UIButton!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var lblUsuario: UILabel!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPasswordActual: UITextField!
    @IBOutlet weak var txtNuevoPassword: UITextField!
    @IBOutlet weak var txtConfirmarNuevoPassword: UITextField!
    @IBOutlet weak var switchNuevoPassword: UISwitch!
    
    // Declaración de variables para esconder nueva contraseña
    @IBOutlet weak var altoVistaNuevoPassword: NSLayoutConstraint!
    @IBOutlet weak var vistaNuevoPassword: UIView!
    
    // Variables para manejar el alto de la vista de nueva contraseña
    var altoAuxiliarVisible: CGFloat?;
    
    // Variable para la foto de perfil
    var imgFotoPerfil: UIImage?;
    
    // Variable estática para el manejo de la firma.
    static var imgFirma: UIImage?;
    
    // Conexión con la base de datos interna
    let conexion = Conexion();
    var usuarioLogueado: Usuario?;
    
    // Adecuación de url para imágenes
    let str = Constantes.URL_BASE;
    var urlBaseImagenes: String!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.urlBaseImagenes = String(self.str.prefix((str.count - 1)));
        self.inits();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let perfilExiste = self.imgFotoPerfil {
            self.imgPerfil.image = perfilExiste;
        }
    }
    
    private func inits () {
        // Establecer conexión
        conexion.conectarBaseDatos();
        
        // Ajustar estilos
        self.btnFirma.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnGuardar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        // Inicialización condiciones para nueva contraseña
        self.altoAuxiliarVisible = self.altoVistaNuevoPassword.constant;
        self.altoVistaNuevoPassword.constant = 0;
        self.vistaNuevoPassword.isHidden = true;
        
        Funcionales.redondearVista(view: self.imgPerfil);
        
        self.recuperarEspacioTeclado();
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        self.obtenerDatosUsuarioLogueado();
    }
    
    /**
     Permite aumentar el scroll de la vista para recuperar algo del espacio que ocupa el teclado.
     */
    private func recuperarEspacioTeclado () {
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    /**
     Permite obtener de la base de datos interna, la información del usuario que ha iniciado sesión.
     */
    private func obtenerDatosUsuarioLogueado () {
        if let usuarioExiste = FachadaIndependientesSQL.seleccionarPorIdUsuario(conexion: conexion, idRegistro: Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as! Int){
            
            self.usuarioLogueado = usuarioExiste;
            
            self.lblUsuario.text = self.usuarioLogueado!.number_document;
            self.txtNombre.text = self.usuarioLogueado!.name;
            self.txtApellidos.text = self.usuarioLogueado!.surnames;
            self.txtTelefono.text = self.usuarioLogueado!.phone;
            self.txtCorreo.text = self.usuarioLogueado!.email;
            
            self.cargarImagenes();
        } else {
            Funcionales.mostrarAlerta(view: self, mensaje: "Su información no se ha cargado de forma correcta. Por favor cierre sesión e iníciela nuevamente.");
        }
    }
    
    /**
     Permite verificar si las imágenes asociadas al actual usuario se encuentran listas para ser cargadas en al vista de perfil y de la firma.
     Se basa en el número del documento, y el grupo de imágenes.
     */
    private func cargarImagenes () {
        let fileManager = FileManager.default;
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            // Se busca imagen de perfil.
            // GRUPO DOCUMENTO_USUARIO_LOGUEADO NOMBRE_IMAGEN
            if let numeroDocumento = self.usuarioLogueado!.number_document {
                if let data = try? Data(contentsOf: tDocumentDirectory.appendingPathComponent("\(Constantes.GRUPO_USUARIO)\(numeroDocumento)_photo.png")) {
                    if let image = UIImage(data: data) {
                        self.imgFotoPerfil = image;
                        self.imgPerfil.image = self.imgFotoPerfil;
                    }
                } else {
                    self.imgPerfil.image = UIImage(named: "perfil_defecto");
                }
                
                // Se busca imagen de firma.
                if let data = try? Data(contentsOf: tDocumentDirectory.appendingPathComponent("\(Constantes.GRUPO_USUARIO)\(numeroDocumento)_image_digital.png")) {
                    if let image = UIImage(data: data) {
                        PerfilViewController.imgFirma = image;
                    }
                }
            }
            
        }
    }
    
    /**
     Permite validar todos los campos del formulario.
     */
    private func validarCampos () -> Bool {
        var campos: [UITextField] = [self.txtNombre, self.txtApellidos, self.txtTelefono, self.txtCorreo, self.txtPasswordActual];
        
        // Si está activa cambiar contraseña, entonces se validan los nuevos campos.
        if(self.switchNuevoPassword.isOn) {
            campos.append(self.txtNuevoPassword);
            campos.append(self.txtConfirmarNuevoPassword);
        } else {
            Funcionales.vaciarCamposTexto(campos: [self.txtNuevoPassword, txtConfirmarNuevoPassword]);
        }
        
        // Priimero se valida si los campos están vacíos.
        if (Validacion.sonCamposVacios(textos: campos)) {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            return false;
        }
        
        // Se valida si es correo electrónico válido.
        let camposEmailOK = Validacion.esCampoEmail(email: self.txtCorreo);
        // Si no pasa la validación de correo electrónico, no continúa con la siguiente.
        if !camposEmailOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_CORREO);
            return false;
        }
        
        // Si el usuario desea cambiar el password, aplican validaciones.
        if(self.switchNuevoPassword.isOn) {
            // Se evalúa número mínimo de caracteres.
            let camposMinimosOK = Validacion.sonCamposCaracteresMinimos(campos: [self.txtNuevoPassword, self.txtConfirmarNuevoPassword], min: 6);
            // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
            if !camposMinimosOK {
                Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MINIMO_CARACTERES) 6");
                return false;
            }
            
            // Se evalúa si las cadenas de password son iguales.
            let camposPasswordIguaesOK = Validacion.sonCamposTextoIguales(campos: [self.txtNuevoPassword, self.txtConfirmarNuevoPassword]);
            // Si no pasa la validación no continúa con la siguiente.
            if !camposPasswordIguaesOK {
                Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.PASSWORD_CONFIRMAR_IGUALES);
                return false;
            }
        }
        
        // Si pasa todas las validaciones entonces retorna verdadero para continuar.
        return true;
    }
    
    /**
     Permite actualizar la información del usuario después de actualizar la información.
     - Parameter usuarioActualizado: Corresponde al objeto usuario con al nueva información.
     - Parameter mensaje: Corresponde al mensaje de actualización.
     */
    private func actualizarBaseDatos (usuarioActualizado: Usuario, mensaje: String) {
        // Se actualiza el estado del usuario.
        usuarioActualizado.sincronizado = true;
        
        let actualizado = FachadaIndependientesSQL.actualizarRegistroUsuario(conexion: self.conexion, idRegistro: (self.usuarioLogueado?.id)!, data: usuarioActualizado);
        
        if(actualizado == 0) {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_ACTUALIZACIÓN_DATA);
        } else {
            // Se actualiza la variable de instacia.
            self.usuarioLogueado = usuarioActualizado;
            
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                
                // Se descargan las imágenes
                Funcionales.descargarImagenesUsuario(usuario: usuarioActualizado);
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    // Se cargan las imágenes
                    self.cargarImagenes();
                });
            });
            
            // Se actualizan los valores de la sesión UserDefaults
            Funcionales.guardarUserDefaults(valor: self.usuarioLogueado!.authentication_token!, llave: Constantes.SETTINGS_ACCESS_TOKEN);
            Funcionales.guardarUserDefaults(valor: self.usuarioLogueado!.name!, llave: Constantes.SETTINGS_NOMBRE);
            Funcionales.guardarUserDefaults(valor: self.usuarioLogueado!.email!, llave: Constantes.SETTINGS_EMAIL);
            // Se notifica al usuario.
            Funcionales.mostrarAlerta(view: self, mensaje: mensaje);
        }
    }
    
    /**
     Permite enviar la información sin incluir imágenes.
     - Parameter user: Corresponde al diccionario con la información del usuario.
     - Parameter adicionales: Corresponde a los datos de verificación de usuario que se añaden a la información del formulario.
     */
    private func actualizarPerfilSinImagenes (user: [String: Any], adicionales: [String: String]) {
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.actualizarPerfilUsuario(usuario: user, adicionales: adicionales);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case let .success(data):
                    print(data);
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["error"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            if(!(json[0]["error"].array != nil)) {
                                Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                            } else {
                                Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONVERSION_DATA);
                            }
                        }
                    } else {
                        // Se actualiza la información en la base de datos
                        if let usuarioActualizado = Usuario(JSONString: json[0]["user"].description){
                            
                            self.actualizarBaseDatos(usuarioActualizado: usuarioActualizado, mensaje: json[0]["message"].description);
                            
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_ACTUALIZACIÓN_DATA);
                        }
                    }
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnGuardar, texto: "Guardar Cambios", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnGuardar, texto: "Guardar Cambios", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            }
        }
    }
    
    /**
     Permite enviar la información con imágenes.
     - Parameter user: Corresponde al diccionario con la información del usuario.
     - Parameter adicionales: Corresponde a los datos de verificación de usuario que se añaden a la información del formulario.
     - Parameter imagenes: Corresponde a un diccionario con el nombre y archivo.
     */
    private func actualizarPerfilConImagenes (user: [String: String], adicionales: [String: String]) {
        var imagenesFinales = [String: UIImage]();
        
        if(self.imgFotoPerfil != nil) {
            imagenesFinales["photo"] = self.imgFotoPerfil!;
        }
        
        if(PerfilViewController.imgFirma != nil) {
            imagenesFinales["image_digital"] = PerfilViewController.imgFirma!;
        }
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.actualizarPerfilUsuarioConImagenes(usuario: user, adicionales: adicionales, imagenes: imagenesFinales);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case .success(let upload, _, _):
                    upload.responseSwiftyJSON { response in
                        switch (response.result) {
                        case let .success(data):
                            print(data);
                            let json = JSON(arrayLiteral: data);
                            if(json[0]["error"] != nil) {
                                if let mensajes = json[0]["error"].dictionary {
                                    Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                                } else {
                                    if(!(json[0]["error"].array != nil)) {
                                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: json[0]["error"].description);
                                    } else {
                                        Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONVERSION_DATA);
                                    }
                                }
                            } else {
                                // Se crea un objeto a partir de la respuesta JSON.
                                // Se actualiza la información en la base de datos
                                if let usuarioActualizado = Usuario(JSONString: json[0]["user"].description){
                                    
                                    // Se debe actualizar las rutas de las imágenes si cambiaron.
                                    usuarioActualizado.image_digital = self.urlBaseImagenes + json[0]["user"]["image_digital"]["url"].description;
                                    usuarioActualizado.photo = self.urlBaseImagenes + json[0]["user"]["photo"]["url"].description;
                                    
                                    // Funcionales.imprimirObjetoConPropiedades(objeto: usuarioActualizado, titulo: "Objeto actualizado");
                                    
                                    self.actualizarBaseDatos(usuarioActualizado: usuarioActualizado, mensaje: json[0]["message"].description);
                                } else {
                                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_ACTUALIZACIÓN_DATA);
                                }
                            }
                            // Se activa el botón guardar
                            Funcionales.activarDesactivarBoton(boton: self.btnGuardar, texto: "Guardar Cambios", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                        case .failure(_):
                            // Se activa el botón guardar
                            Funcionales.activarDesactivarBoton(boton: self.btnGuardar, texto: "Guardar Cambios", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                            
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                        }
                        
                    }
                case .failure(_):
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnGuardar, texto: "Guardar Cambios", color: Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            }
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
    @IBAction func accionFotoPerfil(_ sender: UIButton) {
        let vc = UIImagePickerController();
        vc.sourceType = .camera;
        vc.allowsEditing = true;
        vc.delegate = self;
        present(vc, animated: true);
    }
    
    @IBAction func accionCambiarPassword(_ sender: UISwitch) {
        if(sender.isOn){
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaNuevoPassword, altoInicial: self.altoVistaNuevoPassword, altoAuxiliar: self.altoAuxiliarVisible!, animado: true);
        } else {
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaNuevoPassword, altoInicial: self.altoVistaNuevoPassword, animado: true);
        }
    }
    
    @IBAction func accionFirma(_ sender: UIButton) {
        FirmaViewController.estaEnModoPerfil = true;
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_firma") as! FirmaViewController;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionGuardar(_ sender: UIButton) {
        if(self.validarCampos()) {
            // Se inactiva botón guardar.
            Funcionales.activarDesactivarBoton(boton: self.btnGuardar, texto: "Enviando ...", color: .lightGray, activo: false);
            
            // Se crea la estructura que requiere la API con la información del usuario.
            var user = Dictionary<String, String>();
            user["name"] = self.txtNombre.text;
            user["surnames"] = self.txtApellidos.text;
            user["email"] = self.txtCorreo.text;
            user["phone"] = self.txtTelefono.text;
            user["current_password"] = self.txtPasswordActual.text;
            
            if(self.switchNuevoPassword.isOn) {
                user["password"] = self.txtNuevoPassword.text;
                user["password_confirmation"] = self.txtConfirmarNuevoPassword.text;
            }
            
            var adicionales = [String: String]();
            adicionales["user_email"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_EMAIL) as? String;
            adicionales["user_token"] = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ACCESS_TOKEN) as? String;
            
            // Se verifica si se hizo algún cambio de imágenes: foto o firma
            if(self.imgFotoPerfil != nil || PerfilViewController.imgFirma != nil) {
                self.actualizarPerfilConImagenes(user: user, adicionales: adicionales);
            } else {
                self.actualizarPerfilSinImagenes(user: user, adicionales: adicionales);
            }
        } else {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        }
    }
    
}

extension PerfilViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.imgFotoPerfil = UIImage(data: image.jpegData(compressionQuality: 0.5)!);
    }
}
