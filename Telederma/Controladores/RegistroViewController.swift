//
//  RegistroViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 16/03/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegistroViewController: UIViewController {
    
    // Declaración de objetos de la vista.
    @IBOutlet weak var btnFirma: UIButton!
    @IBOutlet weak var btnRegistro: UIButton!
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var switchTerminos: UISwitch!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtIdentificacion: UITextField!
    @IBOutlet weak var btnTipoProfesional: UIButton!
    @IBOutlet weak var txtTarjetaProfesional: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmarPassword: UITextField!
    @IBOutlet weak var imgPerfil: UIImageView!
    
    // Se declaran variables estáticas para el manejo de la firma y la foto.
    static var imgFirma: UIImage?;
    var imgFotoCamaraPerfil: UIImage?;
    
    // Declaración de variables de instancia
    // Se agrega tabulación a los textos de las opciones para una mejor presentación en el botón.
    let tipoProfesionales = ["Seleccione una opción", "Médico"];
    var pickerView = UIPickerView();
    var tipoProfesionalSeleccionado = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.imgFotoCamaraPerfil != nil) {
            self.imgPerfil.image = self.imgFotoCamaraPerfil;
        } else {
            self.imgPerfil.image = UIImage(named: "perfil_defecto");
        }
    }
    
    /**
     Utilizada para inicializar los componentes y funcionalidades por defecto apenas inicie la vista.
     */
    private func inits () {
        // Ajustes de estilos.
        self.btnFirma.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnRegistro.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnTipoProfesional.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTipoProfesional.layer.borderColor = Constantes.BORDE_COLOR;
        self.btnTipoProfesional.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        Funcionales.redondearVista(view: self.imgPerfil);
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        
    }
    
    /**
     Permite mostrar un modal para la selección de las opciones de tipo de profesional.
     No requiere de parámetros y no retorna.
     */
    private func mostrarPickerTipoProfesional () {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        // Se selecciona una opción de manera automática si ya lo había hecho el usuario.
        pickerView.selectRow(self.tipoProfesionalSeleccionado, inComponent: 0, animated: true);
        
        vc.view.addSubview(pickerView);
        
        let opcionesAlert = UIAlertController(title: "Tipo de Profesional", message: nil, preferredStyle: UIAlertController.Style.alert);
        opcionesAlert.setValue(vc, forKey: "contentViewController");
        opcionesAlert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil));
        
        self.present(opcionesAlert, animated: true);
    }
    
    /**
     Permite realizar todas las validaciones al formulario: tipos de datos, vacíos, tamaños, etc.
     No requiere parámetros de entrada.
     - Returns: True si todas las validaciones pasan, False en caso contrario.
     */
    private func validarCampos () -> Bool {
        let todosCampos: [UITextField] = [self.txtUsuario, self.txtIdentificacion, self.txtTarjetaProfesional, self.txtNombres, self.txtApellidos, self.txtTelefono, self.txtCorreo, self.txtPassword, self.txtConfirmarPassword];
        
        // Primero se evalúa si son vacíos.
        let camposVaciosOK = !Validacion.sonCamposVacios(textos: todosCampos);
        // Si no pasa la validación de campos vacíos no continúa con la siguientes validaciones.
        if !camposVaciosOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            return false;
        }
        
        // Se evalúan los campos numéricos
        let camposNumericosOK = Validacion.sonCamposNumericos(textos: [self.txtUsuario, self.txtIdentificacion, self.txtTarjetaProfesional]);
        // Si no pasa la validación de campos numéricos no contnúa con la siguiente.
        if !camposNumericosOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_NUMEROS);
            return false;
        }
        
        // Se evalúa los campos Email.
        let camposEmailOK = Validacion.esCampoEmail(email: self.txtCorreo);
        // Si no pasa la validación de correo electrónico, no continúa con la siguiente.
        if !camposEmailOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.SOLO_CORREO);
            return false;
        }
        
        // Se evalúa número mínimo de caracteres.
        let camposMinimosOK = Validacion.sonCamposCaracteresMinimos(campos: [self.txtPassword, self.txtConfirmarPassword], min: 6);
        // Si no pasa la validación de mínimo de caracteres, no continúa con la siguiente.
        if !camposMinimosOK {
            Funcionales.mostrarAlerta(view: self, mensaje: "\(Mensajes.MINIMO_CARACTERES) 6");
            return false;
        }
        
        // Se evalúa si las cadenas de identificación son iguales.
        let camposIdentificacionIguaesOK = Validacion.sonCamposTextoIguales(campos: [self.txtUsuario, self.txtIdentificacion]);
        // Si no pasa la validación no continúa con la siguiente.
        if !camposIdentificacionIguaesOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.USUARIO_IDENTIFICACION_IGUALES);
            return false;
        }
        
        // Se evalúa si las cadenas de password son iguales.
        let camposPasswordIguaesOK = Validacion.sonCamposTextoIguales(campos: [self.txtPassword, self.txtConfirmarPassword]);
        // Si no pasa la validación no continúa con la siguiente.
        if !camposPasswordIguaesOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.PASSWORD_CONFIRMAR_IGUALES);
            return false;
        }
        
        // Se valida que el usuario acepte los términos y condiciones.
        let terminosOK = self.switchTerminos.isOn;
        if !terminosOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.CONFIRMAR_TERMINOS);
            self.switchTerminos.becomeFirstResponder();
            return false;
        }
        
        // Se evalúa si se ha seleccionado un tipo de profesional.
        let tipoProfesionalOK = (self.tipoProfesionalSeleccionado > 0) ? true : false;
        if !tipoProfesionalOK {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.MENSAJE_SELECCIONAR_TIPO_PROFESIONAL);
            self.btnTipoProfesional.becomeFirstResponder();
            Validacion.pintarErrorCampoFormulario(view: self.btnTipoProfesional);
            return false;
        } else {
            Validacion.pintarCorrectoCampoFormulario(view: self.btnTipoProfesional, color: Constantes.BORDE_COLOR_CORRECTO, borde: Constantes.BORDE_GROSOR_CORRECTO);
        }
        
        if(RegistroViewController.imgFirma == nil) {
            Funcionales.mostrarAlerta(view: self, mensaje:  Mensajes.MENSAJE_SELECCIONAR_FIRMA_DIGITAL);
            Validacion.pintarErrorCampoFormulario(view: self.btnFirma);
            self.txtConfirmarPassword.becomeFirstResponder();
            return false;
        }
        
        
        // Una comprobación de más sólo para estar seguros :)
        let validacionOK = camposVaciosOK && camposNumericosOK && camposEmailOK && camposMinimosOK && camposIdentificacionIguaesOK && camposPasswordIguaesOK && tipoProfesionalOK && terminosOK;
        
        return validacionOK;
    }
    
    /**
     Parte final del proceso de registro donde se almacena información en la capa de datos y en el fichero de configuración del dispositivo.
     Al final se inicia el controlador de la vista de Consultas.
     - Parameter usuario: Corresponde al usuario nuevo quien contiene toda la información recibida del servidor.
     */
    private func almacenamientoInterno (usuario: Usuario?) {
        usuario?.sincronizado = true;
        
        // Se crea la conexión para la consulta con base de datos.
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        let insertado = FachadaIndependientesSQL.insertarRegistrosUsuario(conexion: conexion, data: [usuario!]);
        if (insertado > 0) {
            
            // Se almacena el ID del usuario que ha iniciado sesión.
            Funcionales.iniciarCerrarSesion(usuario: usuario, estaIniciando: true);
            
            // Antes de pasar a consulta se descargan las imágenes si existen.
            Funcionales.descargarImagenesUsuario(usuario: usuario!);
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_consulta") as! ConsultaViewController;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    /**
     Permite enviar la solicitud de registro sin imágenes adjuntas.
     - Parameter user: Corresponde al diccionario con la información del usuario.
     */
    private func registroSinImagenes (user: Dictionary<String, Any>) {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Enviando ...", color: nil, activo: false);
        
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.registrarUsuario(usuario: user);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case let .success(data):
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["user"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONVERSION_DATA);
                        }
                    } else {
                        // Se crea un objeto a partir de la respuesta JSON.
                        let usuario = Usuario(JSONString: json[0]["user"].description);
                        
                        // Se almacenan las rutas de los archivos por separado.
                        usuario!.image_digital = json[0]["user"]["image_digital"]["url"].description;
                        usuario!.photo = json[0]["user"]["photo"]["url"].description;
                        
                        // Se llama al método que realiza la última parte del proceso de registro.
                        self.almacenamientoInterno(usuario: usuario);
                    }
                    
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Registrarme", color:  Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Registrarme", color:  Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            }
        }
    }
    
    /**
     Permite enviar la información con imágenes.
     - Parameter user: Corresponde al diccionario con la información del usuario.
     */
    private func registroConImagenes (user: [String: String]) {
        
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Enviando ...", color: nil, activo: false);
        
        var imagenesFinales = [String: UIImage]();
        
        if(self.imgFotoCamaraPerfil != nil) {
            imagenesFinales["photo"] = self.imgFotoCamaraPerfil!;
        }
        
        if(RegistroViewController.imgFirma != nil) {
            imagenesFinales["image_digital"] = RegistroViewController.imgFirma!;
        }
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.registrarUsuarioConImagenes(usuario: user, imagenes: imagenesFinales);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case .success(let upload, _, _):
                    upload.responseSwiftyJSON { response in
                        switch (response.result) {
                        case let .success(data):
                            let json = JSON(arrayLiteral: data);
                            if(json[0]["error"] != nil) {
                                if let mensajes = json[0]["user"].dictionary {
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
                                    
                                    // Se almacenan las rutas de los archivos por separado.
                                    usuarioActualizado.image_digital = json[0]["user"]["image_digital"]["url"].description;
                                    usuarioActualizado.photo = json[0]["user"]["photo"]["url"].description;
                                    
                                    // Se llama al método que realiza la última parte del proceso de registro.
                                    self.almacenamientoInterno(usuario: usuarioActualizado);
                                    
                                } else {
                                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_ACTUALIZACIÓN_DATA);
                                }
                            }
                            
                            // Se activa nuevamente el botón.
                            Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Registrarme", color:  Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                            
                        case .failure(_):
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                            
                            // Se activa nuevamente el botón.
                            Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Registrarme", color:  Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                        }
                        
                    }
                    
                    
                case .failure(_):
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnRegistro, texto: "Registrarme", color:  Constantes.COLOR_BOTON_PRIMARIO, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
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
    
    @IBAction func accionTomarFoto(_ sender: UIButton) {
        let vc = UIImagePickerController();
        vc.sourceType = .camera;
        vc.allowsEditing = true;
        vc.delegate = self;
        present(vc, animated: true);
    }
    
    
    @IBAction func accionTerminosCondiciones(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_aviso_legal") as! ModalInformacionEstaticaViewController;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionTipoProfesional(_ sender: UIButton) {
        self.mostrarPickerTipoProfesional();
    }
    
    @IBAction func accionFirmar(_ sender: UIButton) {
        FirmaViewController.estaEnModoRegistro = true;
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_firma") as! FirmaViewController;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionRegistrar(_ sender: UIButton) {
        // Tener en cuenta el último valor que toma la validación en la función validarCampos().
        if(self.validarCampos()){
            
            // Se crea la estructura que requiere la API con la información del usuario.
            var user = Dictionary<String, String>();
            user["name"] = self.txtNombres.text;
            user["surnames"] = self.txtApellidos.text;
            user["email"] = self.txtCorreo.text;
            user["number_document"] = self.txtIdentificacion.text;
            user["phone"] = self.txtTelefono.text;
            user["professional_card"] = self.txtTarjetaProfesional.text;
            user["type_professional"] = self.tipoProfesionalSeleccionado.description;
            user["password"] = self.txtPassword.text;
            user["password_confirmation"] = self.txtConfirmarPassword.text;
            user["terms_and_conditions"] = (self.switchTerminos.isOn ? 1 : 0).debugDescription;
            
            // Se verifica si se hizo algún cambio de imágenes: foto o firma
            if(self.imgFotoCamaraPerfil != nil || RegistroViewController.imgFirma != nil) {
                self.registroConImagenes(user: user);
            } else {
                self.registroSinImagenes(user: user);
            }
            
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_DESCARTE);
        }
    }
}

extension RegistroViewController: UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.tipoProfesionales.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let texto = self.tipoProfesionales[row];
        // Se elimina la tabulación para mostrar en el picker. Dicha tabulación es para mostrar mejor el texto en el botón.
        let nuevoTexto = texto.replacingOccurrences(of: "\t", with: "");
        return nuevoTexto;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let texto = self.tipoProfesionales[row];
        
        self.tipoProfesionalSeleccionado = row;
        Funcionales.ajustarTextoBotonSelector(boton: self.btnTipoProfesional, texto: texto);
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        self.imgFotoCamaraPerfil = UIImage(data: image.jpegData(compressionQuality: 0.5)!);
    }
}

