//
//  CustomRequerimientoResolverViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 27/09/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Speech
import Alamofire
import SwiftyJSON

class CustomRequerimientoResolverViewController: UIViewController {
    
    @IBOutlet weak var txtRespuestaRequerimiento: UITextView!
    @IBOutlet weak var btnMicrofono: UIButton!
    @IBOutlet weak var btnConfirmar: UIButton!
    
    // Variables para micrófono.
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-ES"));
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?;
    var recognitionTask: SFSpeechRecognitionTask?;
    let audioEngine = AVAudioEngine();
    
    var requerimiento: Requerimiento!;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        self.txtRespuestaRequerimiento.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtRespuestaRequerimiento.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtRespuestaRequerimiento.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.btnConfirmar.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.btnMicrofono.layer.cornerRadius = self.btnMicrofono.frame.size.width / 2;
        self.btnMicrofono.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
        
        // Se lanza el método para el dictado.
        self.configurarDictado();
    }
    
    private func configurarDictado() {
        
        self.btnMicrofono.isEnabled = false;
        self.speechRecognizer?.delegate = self;
        // self.btnMicrofono.addTarget(self, action: #selector(btnIniciarDictado(_:)), for: .touchUpInside);
        
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
                self.btnMicrofono.isEnabled = isButtonEnabled;
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
            print("audioSession error. \(error)");
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
                
                self.txtRespuestaRequerimiento.text = result!.bestTranscription.formattedString;
                self.txtRespuestaRequerimiento.textColor = .black;
                isFinal = (result?.isFinal)!;
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop();
                inputNode.removeTap(onBus: 0);
                
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                
                self.btnMicrofono.isEnabled = true;
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
            print("audioEngine couldn't start because of an error.")
        }
        
        self.txtRespuestaRequerimiento.text = "";
    }
    
    /**
     Permite enviar la información.
     - Parameter adicionales: Corresponde a los datos de verificación de usuario que se añaden a la información del formulario.
     */
    private func resolverRequerimiento (adicionales: [String: Any]) {
        // Se inactiva el botón de envío de la petición.
        Funcionales.activarDesactivarBoton(boton: self.btnConfirmar, texto: "Enviando ...", color: Constantes.COLOR_BOTON_SECUNDARIO, activo: false);
        
        DispatchQueue.global(qos: .utility).async {
            let resultado = FachadaHTTPDependientes.resolverRequerimiento(adicionales: adicionales);
            
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
                        self.dismiss(animated: true, completion: nil);
                    }
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnConfirmar, texto: "Confirmar", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                case let .failure(error):
                    print("Error \(error)");
                    // Se activa el botón guardar
                    Funcionales.activarDesactivarBoton(boton: self.btnConfirmar, texto: "Confirmar", color: Constantes.COLOR_FONDO_AZUL_CLARO, activo: true);
                    
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
    
    @IBAction func accionHablar(_ sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop();
            self.recognitionRequest?.endAudio();
            self.btnMicrofono.isEnabled = false;
            self.btnMicrofono.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
            self.txtRespuestaRequerimiento.isEditable = true;
        } else {
            self.iniciarGrabacion();
            self.btnMicrofono.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal);
            self.txtRespuestaRequerimiento.isEditable = false;
        }
    }
    
    @IBAction func accionConfirmar(_ sender: UIButton) {
        if (Validacion.esCadenaVacia(texto: self.txtRespuestaRequerimiento.text)) {
            Validacion.pintarErrorCampoFormulario(view: self.txtRespuestaRequerimiento);
            self.txtRespuestaRequerimiento.becomeFirstResponder();
            
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        } else {
            var adicionales = [String: Any]();
            adicionales["request[id]"] = self.requerimiento.id;
            adicionales["request[audio_request]"] = nil;
            adicionales["request[description_request]"] = self.txtRespuestaRequerimiento.text;
            adicionales["request[status]"] = self.requerimiento.status;
            
            self.resolverRequerimiento(adicionales: adicionales);
        }
    }
    
}

extension CustomRequerimientoResolverViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnMicrofono.isEnabled = true;
        } else {
            self.btnMicrofono.isEnabled = false;
        }
    }
}
