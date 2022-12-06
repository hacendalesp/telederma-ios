//
//  RegistroPacienteViewController3.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 12/04/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Speech

class RegistroPacienteViewController3: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var txtExamenFisico: UITextView!
    @IBOutlet weak var btnHablar: UIButton!
    @IBOutlet weak var imgFooter: UIImageView!
    @IBOutlet weak var btnSiguiente: UIButton!
    
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
        // Ajuste a los estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtExamenFisico.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtExamenFisico.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtExamenFisico.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        self.btnHablar.layer.cornerRadius = self.btnHablar.frame.size.width / 2;
        self.btnHablar.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Se valida si ya se ha diligenciado todo el proceso y está activo terminación
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.btnSiguiente.setTitle(Mensajes.TEXTO_BOTON_RESUMEN, for: .normal);
        }
        
        // Adicionar gesto ocultar teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        
        self.precargarInformacion();
        
        // Se lanza el método para el dictado.
        self.configurarDictado();
    }
    
    private func precargarInformacion () {
        if let consultaMedica = MemoriaRegistroConsulta.consultaMedica {
            self.txtExamenFisico.text = consultaMedica.description_physical_examination;
        }
    }
    
    @IBAction func btnIniciarDictado(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            self.audioEngine.stop();
            self.recognitionRequest?.endAudio();
            self.btnHablar.isEnabled = false;
            self.btnHablar.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
            self.txtExamenFisico.isEditable = true;
        } else {
            self.iniciarGrabacion();
            self.btnHablar.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal);
            self.txtExamenFisico.isEditable = false;
        }
    }
    
    
    
    private func configurarDictado() {
        
        self.btnHablar.isEnabled = false;
        self.speechRecognizer?.delegate = self;
        self.btnHablar.addTarget(self, action: #selector(btnIniciarDictado(_:)), for: .touchUpInside);
        
        
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
                self.btnHablar.isEnabled = isButtonEnabled;
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
                
                self.txtExamenFisico.text = result!.bestTranscription.formattedString;
                self.txtExamenFisico.textColor = .black;
                isFinal = (result?.isFinal)!;
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop();
                inputNode.removeTap(onBus: 0);
                
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                
                self.btnHablar.isEnabled = true;
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
        
        self.txtExamenFisico.text = "";
    }
    
    private func sonCamposCorrectos () -> Bool {
        
        let camposObligatoriosOK = !Validacion.esCadenaVacia(texto: self.txtExamenFisico.text);
        if (!camposObligatoriosOK) {
            Funcionales.mostrarAlerta(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
            Validacion.pintarErrorCampoFormulario(view: self.txtExamenFisico);
            return false;
        }
        return true;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func accionSiguiente(_ sender: UIButton) {
        // Se almacena en memoria la descripción del exámen físico.
        MemoriaRegistroConsulta.consultaMedica?.description_physical_examination = self.txtExamenFisico.text;
        // Si está activa la consulta lista para enviar se dirige al último paso del proceso
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
            self.present(vc, animated: true, completion: nil);
            
        } else {
            
            if (self.sonCamposCorrectos()) {
                let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4") as! RegistroPacienteViewController4;
                self.present(vc, animated: true, completion: nil);
            }
        }
    }
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_2") as! RegistroPacienteViewController2;
        self.present(vc, animated: true, completion: nil);
    }
    
}

extension RegistroPacienteViewController3: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnHablar.isEnabled = true;
        } else {
            self.btnHablar.isEnabled = false;
        }
    }
}
