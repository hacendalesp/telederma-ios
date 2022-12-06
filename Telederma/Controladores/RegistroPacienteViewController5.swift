//
//  RegistroPacienteViewController5.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 8/06/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Speech

class RegistroPacienteViewController5: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var lblTituloHeader: UILabel!
    @IBOutlet weak var btnFoto: UIButton!
    @IBOutlet weak var txtAnexos: UITextView!
    @IBOutlet weak var btnMicrofono: UIButton!
    @IBOutlet weak var coleccionAnexos: UICollectionView!
    @IBOutlet weak var imgFooter: UIImageView!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    // Variables para micrófono.
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-ES"));
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?;
    var recognitionTask: SFSpeechRecognitionTask?;
    let audioEngine = AVAudioEngine();
    
    // Variables imágenes seleccionadas
    var listaInversaImagenesDisponibles = [UIImage?]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.coleccionAnexos.reloadData();
    }
    
    private func inits () {
        // Ajustar estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtAnexos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtAnexos.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtAnexos.layer.borderWidth = Constantes.BORDE_GROSOR;
        
        self.btnMicrofono.layer.cornerRadius = self.btnMicrofono.frame.size.width / 2;
        self.btnMicrofono.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
        
        // Borde inferior al titulo de la vista
        Funcionales.agregarBorde(lado: .Bottom, color: Constantes.COLOR_BOTON_SECUNDARIO.cgColor, grosor: 1.0, vista: self.lblTituloHeader);
        
        // Se crea una lista inversa para mostrar las imágenes disponibles.
        listaInversaImagenesDisponibles = MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos.reversed();
        
        // Se valida si ya se ha diligenciado todo el proceso y está activo terminación
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.btnSiguiente.setTitle(Mensajes.TEXTO_BOTON_RESUMEN, for: .normal);
        }
        
        // Delegar stackView
        self.coleccionAnexos.delegate = self;
        self.coleccionAnexos.dataSource = self;
        
        // Adicionar gesto ocular teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);                
        
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
                
                self.txtAnexos.text = result!.bestTranscription.formattedString;
                self.txtAnexos.textColor = .black;
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
        
        self.txtAnexos.text = "";
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
        MemoriaRegistroConsulta.estaAnexosActiva = true;
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
        self.present(vc, animated: true, completion: nil);
    }
    @IBAction func accionHablar(_ sender: UIButton) {
        if audioEngine.isRunning {
            self.audioEngine.stop();
            self.recognitionRequest?.endAudio();
            self.btnMicrofono.isEnabled = false;
            self.btnMicrofono.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
            self.txtAnexos.isEditable = true;
        } else {
            self.iniciarGrabacion();
            self.btnMicrofono.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal);
            self.txtAnexos.isEditable = false;
        }
    }
    @IBAction func accionSiguiente(_ sender: UIButton) {
        // Se almacena la información de anexos en el objeto en memoria
        MemoriaRegistroConsulta.consultaMedica?.annex_description = self.txtAnexos.text;
        
        // Si está activa la consulta lista para enviar se dirige al último paso del proceso
        if(RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
            self.present(vc, animated: true, completion: nil);
            
        } else {
            // Se activa la variable lista para enviar.
            RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar = true;
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_terminacion_consulta") as! RegistroPacienteTerminacionViewController;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_anadir") as! RegistroPacienteViewController4Anadir;
        self.present(vc, animated: true, completion: nil);
    }
    
}

extension RegistroPacienteViewController5: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnMicrofono.isEnabled = true;
        } else {
            self.btnMicrofono.isEnabled = false;
        }
    }
}

extension RegistroPacienteViewController5: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let indiceEnFotosTomadas = indexPath.row;
        
        let imagen = listaInversaImagenesDisponibles[indiceEnFotosTomadas];
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda_anexos", for: indexPath) as! AnexosCollectionViewCell;
        // let imagenConRotacion = Funcionales.rotarImagen(oldImage: imagen!, grados: 90);
        celda.btnFotoAnexos.setBackgroundImage(imagen, for: .normal);
        celda.btnFotoAnexos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        return celda;
    }
}
