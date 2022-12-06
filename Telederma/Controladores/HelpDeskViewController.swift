//
//  HelpDeskViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 23/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Speech
import AVKit
import SwiftyJSON

class HelpDeskViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var txtAsunto: UITextField!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var btnAdjuntarFoto: UIButton!
    @IBOutlet weak var btnTomarFoto: UIButton!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet weak var btnVoz: UIButton!
    
    // Vista foto para ocultar
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var altoImagenFoto: NSLayoutConstraint!
    
    var imgDevice: UIImage?;
    
    // Variable que almacenará el alto inicial
    var imagenFotoHeight: CGFloat!;
    
    // Variables para micrófono.
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-ES"));
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?;
    var recognitionTask: SFSpeechRecognitionTask?;
    let audioEngine = AVAudioEngine();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes en estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnAdjuntarFoto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnTomarFoto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnEnviar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtDescripcion.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtDescripcion.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.txtDescripcion.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.imgFoto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.imgFoto.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.imgFoto.layer.borderColor = Constantes.BORDE_COLOR;
        
        // Se oculta la imagen
        self.imagenFotoHeight = self.altoImagenFoto.constant;
        self.imgFoto.isHidden = true;
        self.altoImagenFoto.constant = 0;
        
        self.btnVoz.layer.cornerRadius = self.btnVoz.frame.size.width / 2;
        self.btnVoz.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
        
        // Se añade evento a la imagen
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.verImagenDetalle(tapGestureRecognizer:)));
        self.imgFoto.isUserInteractionEnabled = true;
        self.imgFoto.addGestureRecognizer(tapGestureRecognizer);
        
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
    }
    
    /**
     Permite preparar los elementos que hacen parte del componente Speech.
     */
    private func configurarDictado() {
        
        self.btnVoz.isEnabled = false;
        self.speechRecognizer?.delegate = self;
        self.btnVoz.addTarget(self, action: #selector(self.accionGrabarAudio(_:)), for: .touchUpInside);
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false;
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true;
                
            case .denied:
                isButtonEnabled = false;
                print("User denied access to speech recognition");
                
            case .restricted:
                isButtonEnabled = false;
                print("Speech recognition restricted on this device");
                
            case .notDetermined:
                isButtonEnabled = false;
                print("Speech recognition not yet authorized");
            @unknown default:
                print("Speech desconocido.");
            }
            
            OperationQueue.main.addOperation() {
                self.btnVoz.isEnabled = isButtonEnabled;
            }
        }
    }
    
    private func iniciarGrabacion() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel();
            recognitionTask = nil;
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker);
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation);
        } catch {
            print("audioSession properties weren't set because of an error.");
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest();
        
        let inputNode = audioEngine.inputNode;
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object");
        }
        
        recognitionRequest.shouldReportPartialResults = true;
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false;
            
            if result != nil {
                
                self.txtDescripcion.text = result!.bestTranscription.formattedString;
                self.txtDescripcion.textColor = .black;
                isFinal = (result?.isFinal)!;
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop();
                inputNode.removeTap(onBus: 0);
                
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                
                self.btnVoz.isEnabled = true;
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0);
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare();
        
        do {
            try self.audioEngine.start();
        } catch {
            print("audioEngine couldn't start because of an error. \(error)")
        }
        
        self.txtDescripcion.text = "";
    }
    
    /**
     Permite validar que los campos obligatorio cumplan con las condiciones para cada uno.
     */
    private func validarCampos () -> Bool {
        let asuntoOK = Validacion.esCadenaVacia(texto: self.txtAsunto.text);
        let descripcionOK = Validacion.esCadenaVacia(texto: self.txtDescripcion.text);
        
        if (asuntoOK) {
            Validacion.pintarErrorCampoFormulario(view: self.txtAsunto);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            return false;
        }
        
        if (descripcionOK) {
            Validacion.pintarErrorCampoFormulario(view: self.txtDescripcion);
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            return false;
        }
        
        return true;
    }
    
    /**
     Permite enviar la solicitud de registro sin imágenes adjuntas.
     - Parameter helpDesk: Corresponde un objeto helpDesk con la información del formulario.
     */
    private func registroSinImagenes (helpDesk: HelpDesk) {
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviando ...", color: .lightGray, activo: false);
        
        let diccionarioHelpDesk: [String: Any] = [
            "subject": helpDesk.subject!,
            "description": helpDesk.descriptions!
        ];
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.registrarHttpHelpDeskSinImagenes(helpDesk: diccionarioHelpDesk);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case let .success(data):
                    print(data)
                    // Se transforma la información en un arreglo.
                    let json = JSON(arrayLiteral: data);
                    // Si la respuesta contiene un error ...
                    if(json[0]["error"] != nil) {
                        if let mensajes = json[0]["error"].dictionary {
                            Funcionales.mostrarMensajeErrorCompuesto(view: self, datos: mensajes);
                        } else {
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONVERSION_DATA);
                        }
                    } else {
                        // Se crea un objeto a partir de la respuesta JSON.
                        let ticket = HelpDesk(JSONString: json[0]["desk"].description);
                        
                        // Se almacenan las rutas de los archivos por separado.
                        ticket!.image_user = json[0]["desk"]["image_user"]["url"].description;
                        ticket!.image_admin = json[0]["desk"]["image_admin"]["url"].description;
                        
                        // Se llama al método que realiza la última parte del proceso de registro.
                        self.almacenamientoInterno(helpDesk: ticket, mensaje: json[0]["message"].description);
                    }
                    
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  UIColor.systemBlue, activo: true);
                    
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  UIColor.systemBlue, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            }
        }
    }
    
    /**
     Permite enviar la información con imágenes.
     - Parameter helpDesk: Corresponde al diccionario con la información del objeto de mesa de ayuda.
     */
    private func registroConImagenes (mesa: HelpDesk) {
        
        let helpDesk: [String: String] = [
            "subject": mesa.subject!,
            "description": mesa.descriptions!
        ];
        
        // Se inactiva el botón registrar mientras procesa la información.
        Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviando ...", color: .lightGray, activo: false);
        
        var imagenesFinales = [String: UIImage]();
        
        if(self.imgDevice != nil) {            
            imagenesFinales["image_user"] = self.imgDevice!;
        }
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.registrarHttpHelpDeskConImagenes(helpDesk: helpDesk, imagenes: imagenesFinales);
            
            // Se evalúa el resultado en el hilo principal.
            DispatchQueue.main.async {
                switch  resultado {
                case .success(let upload, _, _):
                    upload.responseSwiftyJSON { response in
                        switch (response.result) {
                        case let .success(data):
                            let json = JSON(arrayLiteral: data);
                            print(json);
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
                                if let ticket = HelpDesk(JSONString: json[0]["desk"].description){
                                    
                                    // Se almacenan las rutas de los archivos por separado.
                                    ticket.image_user = json[0]["desk"]["image_user"]["url"].description;
                                    
                                    // Se llama al método que realiza la última parte del proceso de registro.
                                    self.almacenamientoInterno(helpDesk: ticket, mensaje: json[0]["message"].description);
                                    
                                } else {
                                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_ACTUALIZACIÓN_DATA);
                                }
                            }
                            
                            // Se activa nuevamente el botón.
                            Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  UIColor.systemBlue, activo: true);
                            
                        case .failure(_):
                            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                            
                            // Se activa nuevamente el botón.
                            Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  UIColor.systemBlue, activo: true);
                        }
                        
                    }
                    
                case .failure(_):
                    // Se activa nuevamente el botón.
                    Funcionales.activarDesactivarBoton(boton: self.btnEnviar, texto: "Enviar", color:  UIColor.systemBlue, activo: true);
                    
                    Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_CONEXION);
                }
            }
        }
    }
    
    /**
     Parte final del proceso de registro donde se almacena información en la capa de datos.
     - Parameter helpDesk: Corresponde al usuario nuevo quien contiene toda la información recibida del servidor.
     */
    private func almacenamientoInterno (helpDesk: HelpDesk?, mensaje: String?) {
        var mensajeLocal = mensaje;
        // Se crea la conexión para la consulta con base de datos.
        let conexion = Conexion();
        conexion.conectarBaseDatos();
        
        let insertado = FachadaDependientesSQL.insertarRegistrosHelpDesk(conexion: conexion, data: [helpDesk!]);
        
        if (insertado > 0) {
            
            if let image_user = helpDesk?.image_user {
                // Antes de pasar a consulta se descargan las imágenes si existen.
                Funcionales.descargarImagenesAsincrono(grupo: Constantes.GRUPO_MESA_AYUDA, identificador: (helpDesk?.user_id!.description)!, imagenes: [
                    "image_user": image_user
                ]);
            }
            
            if let image_admin = helpDesk?.image_admin {
                // Antes de pasar a consulta se descargan las imágenes si existen.
                Funcionales.descargarImagenesAsincrono(grupo: Constantes.GRUPO_MESA_AYUDA, identificador: (helpDesk?.user_id!.description)!, imagenes: [
                    "image_admin": image_admin
                ]);
            }
            
            
        } else {
            mensajeLocal = Mensajes.ERROR_ALMACENAMIENTO_INTERNO;
        }
        
        // Al final se redirige hacia la vista incial de mesa de ayuda.
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: {
            (UIAlertAction) in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_mesa") as! MesaViewController;
            self.present(vc, animated: true, completion: nil);
        });
        
        let alerta = UIAlertController(title: "Mesa de ayuda", message: mensajeLocal, preferredStyle: .alert);
        alerta.addAction(accionAceptar);
        
        self.present(alerta, animated: true, completion: nil);
    }
    
    @objc func verImagenDetalle(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView;
        // And some actions
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_imagen_detalle") as! ImagenDetalleViewController;
        vc.imagenFotoDetalle = tappedImage.image;
        self.present(vc, animated: true, completion: nil);        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionGrabarAudio(_ sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop();
            self.recognitionRequest?.endAudio();
            self.btnVoz.isEnabled = false;
            self.btnVoz.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
            self.txtDescripcion.isEditable = true;
        } else {
            self.iniciarGrabacion();
            self.btnVoz.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal);
            self.txtDescripcion.isEditable = false;
        }
    }
    
    @IBAction func accionAdjuntarFoto(_ sender: UIButton) {
        let vc = UIImagePickerController();
        vc.sourceType = .photoLibrary;
        vc.allowsEditing = true;
        vc.delegate = self;
        present(vc, animated: true);
    }
    
    @IBAction func accionTomarFoto(_ sender: UIButton) {
        let vc = UIImagePickerController();
        vc.sourceType = .camera;
        vc.allowsEditing = true;
        vc.delegate = self;
        present(vc, animated: true);
    }
    
    @IBAction func accionEnviar(_ sender: UIButton) {
        if(self.validarCampos()) {
            let helpDesk = HelpDesk();
            helpDesk.subject = self.txtAsunto.text;
            helpDesk.descriptions = self.txtDescripcion.text;
            
            if (self.imgDevice == nil) {
                self.registroSinImagenes(helpDesk: helpDesk);
            } else {
                self.registroConImagenes(mesa: helpDesk);
            }
        } else {
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.ERROR_DESCARTE);
        }
    }
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_mesa") as! MesaViewController;
        self.present(vc, animated: true, completion: nil);
    }
}

extension HelpDeskViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnVoz.isEnabled = true;
        } else {
            self.btnVoz.isEnabled = false;
        }
    }
}

extension HelpDeskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            
            // Se borra la imagen y se oculta la sección.
            self.imgDevice = nil;
            self.imgFoto.image = self.imgDevice;
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.imgFoto, altoInicial: self.altoImagenFoto, animado: true);
            
            return
        }
        
        // Se carga la foto y se muestra
        self.imgDevice = image;
        self.imgFoto.image = self.imgDevice;
        Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.imgFoto, altoInicial: self.altoImagenFoto, altoAuxiliar: self.imagenFotoHeight, animado: true);
    }
}
