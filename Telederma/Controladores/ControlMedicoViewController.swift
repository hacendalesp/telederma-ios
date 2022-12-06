//
//  ControlMedicoViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 31/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ControlMedicoViewController: UIViewController {
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var sliderMejora: UISlider!
    @IBOutlet weak var lblMejora: UILabel!
    @IBOutlet weak var btnIndicacionesSi: UIButton!
    @IBOutlet weak var btnIndicacionesNo: UIButton!
    @IBOutlet weak var vistaToleraMedicamentos: UIView!
    @IBOutlet weak var txtExamenFisico: UITextView!
    @IBOutlet weak var btnHablarExamenFisico: UIButton!
    @IBOutlet weak var btnTomarFoto: UIButton!
    @IBOutlet weak var txtAnexos: UITextView!
    @IBOutlet weak var btnHablarAnexos: UIButton!
    @IBOutlet weak var coleccionAnexos: UICollectionView!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    // Elementos para manejo de vistas
    @IBOutlet weak var altoColeccionAnexos: NSLayoutConstraint!
    @IBOutlet weak var altoToleranciaMedicamentos: NSLayoutConstraint!
    
    // Variables manejo para los altos.
    var toleranciaMedicamentosHeight: CGFloat!;
    
    // Variables para trazabilidad de historia clínica
    var consultaId: Int!;
    var listaToleranciaMedicamentos = [ConstanteValor]();
    var botonesToleranciaMedicamentos = [UIButton]();
    var toleraciaMedicamentoSeleccionado = 0;
    var conexion = Conexion();
    
    // Se declara una lista que contendrá las imágenes seleccionadas temporales al guardar en modo dermatoscopia. Al guardar se asignarán a la lista definitiva en RegistroCamara.
    var listaSeleccionadasTemporal = [UIImage?]();
    
    // Variables para manejo de altos
    var coleccionAnexosHeight: CGFloat!;
    
    // Variables para la manejo de selecciones de usuario.
    var indiciacionesSeleccionado = false;
    
    // Variables para dictado
    // Variables para micrófono.
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-ES"));
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?;
    var recognitionTask: SFSpeechRecognitionTask?;
    let audioEngine = AVAudioEngine();
    
    // Variables para las imágenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        self.inits();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Si el usaurio regresa, se eliminan las imágenes.
        self.listaSeleccionadasTemporal = [];
        
        if (MemoriaRegistroConsulta.listaFotosAnexos.count > 0) {
            
            // Si hay imágenes para anexos entonces se muestra la sección.
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.coleccionAnexos, altoInicial: self.altoColeccionAnexos, altoAuxiliar: self.coleccionAnexosHeight, animado: true);
        } else {
            
            // Si no hay imágenes asociadas a anexos, se oculta la vista.
            Funcionales.ocultarSeccion(vistaController: self.view, vista: self.coleccionAnexos, altoInicial: self.altoColeccionAnexos, animado: true);
        }
        
        self.coleccionAnexos.reloadData();
    }
    
    private func inits () {
        // Ajustes de estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        self.txtExamenFisico.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtExamenFisico.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.txtExamenFisico.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.txtAnexos.layer.borderColor = Constantes.BORDE_COLOR;
        self.txtAnexos.layer.borderWidth = Constantes.BORDE_GROSOR;
        self.txtAnexos.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        self.btnSiguiente.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.coleccionAnexosHeight = self.altoColeccionAnexos.constant;
        self.altoColeccionAnexos.constant = 0;
        // Se oculta la sección de fotos de anexos al iniciar porque no hay fotos.
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.coleccionAnexos, altoInicial: self.altoColeccionAnexos, animado: true);
        
        self.btnHablarExamenFisico.layer.cornerRadius = self.btnHablarExamenFisico.frame.size.width / 2;
        self.btnHablarExamenFisico.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
        self.btnHablarAnexos.layer.cornerRadius = self.btnHablarAnexos.frame.size.width / 2;
        self.btnHablarAnexos.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
        
        // Adicionar gesto ocultar teclado
        Gestos.ocultarTeclado(seflView: self.view, view: view);
        
        // Se asignan tags para los botones de dictado para controlar las acciones independientes.
        self.btnHablarExamenFisico.tag = 0;
        self.btnHablarAnexos.tag = 1;
        
        // Delegar stackView
        self.coleccionAnexos.delegate = self;
        self.coleccionAnexos.dataSource = self;
        
        self.conexion.conectarBaseDatos();
        
        // Se oculta la vista de tratamiento e indicaciones.
        self.toleranciaMedicamentosHeight = self.altoToleranciaMedicamentos.constant;
        self.altoToleranciaMedicamentos.constant = 0;
        Funcionales.ocultarSeccion(vistaController: self.view, vista: self.vistaToleraMedicamentos, altoInicial: self.altoToleranciaMedicamentos, animado: false);
        
        // Se carga la consulta asociada al control si el proceso ya ha llegado a la parte final y regresa.
        if (RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.consultaId = MemoriaRegistroConsulta.controlMedico?.consultation_id;
        }
        
        self.cargarInformacionBase();
        
        // Se lanza el método para el dictado.
        self.configurarDictado();
    }
    
    @IBAction func btnIniciarDictado(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            self.audioEngine.stop();
            self.recognitionRequest?.endAudio();
            if (sender.tag == 0) {
                self.btnHablarExamenFisico.isEnabled = false;
                self.btnHablarExamenFisico.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
                self.txtExamenFisico.isEditable = true;
            } else {
                self.btnHablarAnexos.isEnabled = false;
                self.btnHablarAnexos.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal);
                self.txtAnexos.isEditable = true;
            }
        } else {
            self.iniciarGrabacion(opcion: sender.tag);
            if (sender.tag == 0) {
                self.btnHablarExamenFisico.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal);
                self.txtExamenFisico.isEditable = false;
            } else {
                self.btnHablarAnexos.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal);
                self.txtAnexos.isEditable = false;
            }
        }
    }
    
    private func cargarInformacionBase () {
        self.listaToleranciaMedicamentos = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "tolerate_medications");
        if (self.listaToleranciaMedicamentos.count > 0) {
            self.crearToleranciaMedicamentos();
        }
    }
    
    /**
     Permite crear la lista de síntomas desde la base de datos interna.
     */
    private func crearToleranciaMedicamentos () {
        let cantidadTolerancia = self.listaToleranciaMedicamentos.count;
        if (cantidadTolerancia > 0) {
            var altoSiguienteBoton = 0;
            let anchoBoton = Constantes.BOTON_DINAMICO_ANCHO;
            let altoBoton = Constantes.BOTON_DINAMICO_ALTO;
            // Ajustar el alto de la vista de síntomas según la cantidad de elementos.
            let altoTotalVista = Constantes.VISTA_DINAMICA_ALTO * CGFloat(cantidadTolerancia);
            self.toleranciaMedicamentosHeight = altoTotalVista;
            
            for item in self.listaToleranciaMedicamentos {
                let button = UIButton(type: .custom);
                button.setTitle(item.title, for: .normal);
                button.setTitleColor(.darkGray, for: .normal);
                button.frame = CGRect(x: Constantes.BOTON_DINAMICO_X, y: altoSiguienteBoton, width: anchoBoton, height: altoBoton);
                button.contentHorizontalAlignment = .left;
                
                if (item.value == 3 && MemoriaRegistroConsulta.controlMedico == nil) {
                    if (MemoriaRegistroConsulta.consultaMedica == nil || MemoriaRegistroConsulta.consultaMedica?.change_symptom == 3) {
                        
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
                        self.toleraciaMedicamentoSeleccionado = item.value!;
                    } else {
                        button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                    }
                } else {
                    button.setImage(UIImage.init(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
                }
                button.tag = item.value!;
                button.tintColor = .darkGray;
                button.titleEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_TITULO;
                button.imageEdgeInsets.left = Constantes.BOTON_DINAMICO_MARGEN_IZQUIERDA_IMAGEN;
                button.addTarget(self, action: #selector(self.accionCambiarEmpeora(sender:)), for: .touchUpInside);
                self.botonesToleranciaMedicamentos.append(button);
                
                altoSiguienteBoton += altoBoton + Constantes.BOTON_DINAMICO_SIGUIENTE_BOTON_Y;
                
                // Precarga de información
                if let informacionConsultaAlmacenada = MemoriaRegistroConsulta.controlMedico {
                    
                    if (item.value == informacionConsultaAlmacenada.tolerated_medications) {
                        
                        // Se actualiza el botón
                        self.accionCambiarEmpeora(sender: button);
                    }
                }
                
                self.vistaToleraMedicamentos.addSubview(button);
            } // End for
            
            Funcionales.mostrarSeccion(vistaController: self.view, vistaMostrar: self.vistaToleraMedicamentos, altoInicial: self.altoToleranciaMedicamentos, altoAuxiliar: self.toleranciaMedicamentosHeight, animado: true);
        }
        
        // Se valida si ya hay información existente en memoria y se precargar. Información asociada al guardar y continuar del último paso.
        if (RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.precargarInformacionExistente();
        }
    }
    
    private func quitarSeleccionBotonesEmpeoran () {
        // Los botones no se eliminan de la lista, se usan para desactivarlos.
        if (self.botonesToleranciaMedicamentos.count > 0) {
            for boton in self.botonesToleranciaMedicamentos {
                boton.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            }
            self.toleraciaMedicamentoSeleccionado = 0;
        }
    }
    
    /**
     Permite controlar la elección de empeora y actualizar el boton para mostrarse según la acción del usuario: seleccionado o no.
     */
    @objc func accionCambiarEmpeora(sender: UIButton!) {
        self.quitarSeleccionBotonesEmpeoran();
        
        sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
        self.toleraciaMedicamentoSeleccionado = sender.tag;
    }
    
    /**
     Se valida si hay información ya registrada y se precarga. Por ejemplo si avanza a la siguiente vista y regresa.
     La validación de los botones "Empeoran" se hace en el momento de la creación.
     */
    private func precargarInformacionExistente () {
        // Se precarga la información de la mejora subjetiva
        if let subjetiveImprovement = MemoriaRegistroConsulta.controlMedico?.subjetive_improvement {
            let subjetiveImprovementString = subjetiveImprovement.split(separator: "/");
            let subjetiveImprovementNumerico = (subjetiveImprovementString[0] as NSString).intValue;
            let mejoraSubjetiva = Float(subjetiveImprovementNumerico);
            
            self.lblMejora.text = "\(Int(mejoraSubjetiva)) / 100%";
            self.sliderMejora.setValue(mejoraSubjetiva, animated: true);
        }
        
        // Se valida si el paciente siguió indicaciones
        if let didTreatment = MemoriaRegistroConsulta.controlMedico?.did_treatment {
            
            if (didTreatment) {
                self.indiciacionesSeleccionado = true;
                self.btnIndicacionesSi.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
                
                self.btnIndicacionesNo.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            } else {
                self.indiciacionesSeleccionado = false;
                self.btnIndicacionesNo.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
                
                self.btnIndicacionesSi.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
            }
        }
        
        self.txtExamenFisico.text = MemoriaRegistroConsulta.controlMedico?.clinic_description;
        self.txtAnexos.text = MemoriaRegistroConsulta.controlMedico?.annex_description;
    }
    
    private func configurarDictado() {
        
        self.btnHablarExamenFisico.isEnabled = false;
        self.btnHablarAnexos.isEnabled = false;
        self.speechRecognizer?.delegate = self;
        
        self.btnHablarExamenFisico.addTarget(self, action: #selector(btnIniciarDictado(_:)), for: .touchUpInside);
        self.btnHablarAnexos.addTarget(self, action: #selector(btnIniciarDictado(_:)), for: .touchUpInside);
        
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
                self.btnHablarExamenFisico.isEnabled = isButtonEnabled;
                self.btnHablarAnexos.isEnabled = isButtonEnabled;
            }
        }
    }
    
    
    private func iniciarGrabacion(opcion: Int) {
        
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
                
                if (opcion == 0) {
                    self.txtExamenFisico.text = result!.bestTranscription.formattedString;
                    self.txtExamenFisico.textColor = .black;
                } else {
                    self.txtAnexos.text = result!.bestTranscription.formattedString;
                    self.txtAnexos.textColor = .black;
                }
                
                // Se crea un archivo de audio .acc
                
                
                isFinal = (result?.isFinal)!;
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop();
                inputNode.removeTap(onBus: 0);
                
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                
                if (opcion == 0) {
                    self.btnHablarExamenFisico.isEnabled = true;
                } else {
                    self.btnHablarAnexos.isEnabled = true;
                }
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
        
        if (opcion == 0) {
            self.txtExamenFisico.text = "";
        } else {
            self.txtAnexos.text = "";
        }
    }
    
    /**
     Permite devolver la imagen con o sin el símbolo de chequeo.
     */
    private func obtenerImagenChecked (needChecked: Bool) -> UIImage {
        var image: UIImage;
        if (needChecked) {
            image = UIImage(named: Constantes.BOTON_CHECK_ON_AZUL)!;
        } else {
            image = UIImage(systemName: Constantes.BOTON_CHECK_OFF)!;
        }
        
        return image;
    }
    
    /**
     Permite añadir o remover una imagen de la lista de seleccionadas.
     */
    @objc func seleccionarFoto (_ sender: UIButton) {
        var estaSeleccionada = false;
        
        if let index = self.listaSeleccionadasTemporal.firstIndex(of: MemoriaRegistroConsulta.listaFotosAnexos[sender.tag]) {
            self.listaSeleccionadasTemporal.remove(at: index);
            estaSeleccionada = false;
        } else {
            self.listaSeleccionadasTemporal.append(MemoriaRegistroConsulta.listaFotosAnexos[sender.tag]);
            estaSeleccionada = true;
        }
        
        sender.setBackgroundImage(self.obtenerImagenChecked(needChecked: estaSeleccionada), for: .normal);
    }
    
    @objc func verFoto (_ sender: UIButton) {
        let posicion = sender.tag;
        let vc = storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_foto") as! RegistroPacienteViewController4Foto;
        // vc.imagen = RegistroPacienteViewController4_Camara.listaFotosTomadas[posicion];
        vc.posicion = posicion;
        self.present(vc, animated: true, completion: nil);
    }
    
    // Comportamiento teclado para que se recupere el espacio que ocupa al aparecer
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return;
        }
        
        if (self.listaToleranciaMedicamentos.count > 0) {
            self.view.frame.origin.y = 0 - (keyboardSize.height);
        } else {
            self.view.frame.origin.y = 0 - (keyboardSize.height / 2);
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0;
    }
    
    /**
     Permite almacenar en memoria la información antes de continuar con el siguiente paso
     */
    private func guardarInformacionActual () {
        MemoriaRegistroConsulta.controlMedico = ControlMedico();
        MemoriaRegistroConsulta.controlMedico!.tolerated_medications = self.toleraciaMedicamentoSeleccionado;
        MemoriaRegistroConsulta.controlMedico!.did_treatment = self.indiciacionesSeleccionado;
        MemoriaRegistroConsulta.controlMedico!.doctor_id = Funcionales.obtenerUserDefaults(llave: Constantes.SETTINGS_ID) as? Int;
        MemoriaRegistroConsulta.controlMedico!.annex_description = self.txtAnexos.text;
        MemoriaRegistroConsulta.controlMedico!.clinic_description = self.txtExamenFisico.text;
        MemoriaRegistroConsulta.controlMedico!.subjetive_improvement = "\(self.lblMejora.text ?? "0")%";
        
        // Si no está lista para enviar, se almacena el id de la consulta en memoria, de lo contrario significa que ya ha sido almacenada.
        if (!RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            MemoriaRegistroConsulta.controlMedico?.consultation_id = self.consultaId;
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
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        
        // Se reinician las variables en Memoria.
        MemoriaRegistroPaciente.reiniciarVariables();
        MemoriaRegistroConsulta.reiniciarVariables();
        
        if (!RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar) {
            self.dismiss(animated: true, completion: nil);
        } else {
            // Se desactiva consulta lista
            RegistroPacienteTerminacionViewController.estaConsultaListaParaEnviar = false;
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_historia_clinica") as! HistoriaClinicaViewController;
            vc.consultaId = self.consultaId;
            
            self.present(vc, animated: true, completion: nil);
        }
    }
    @IBAction func accionMejora(_ sender: UISlider) {
        let step: Float = 1;
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue;
        
        self.lblMejora.text = "\(Int(self.sliderMejora.value)) / \(Int(self.sliderMejora.maximumValue))";
    }
    @IBAction func accionIndicacionesSi(_ sender: UIButton) {
        self.indiciacionesSeleccionado = true;
        sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
        
        self.btnIndicacionesNo.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
    }
    @IBAction func accionIndicacionesNo(_ sender: UIButton) {
        self.indiciacionesSeleccionado = false;
        sender.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_ON), for: .normal);
        
        self.btnIndicacionesSi.setImage(UIImage(systemName: Constantes.BOTON_CHECK_CIRCULO_OFF), for: .normal);
    }
    
    @IBAction func accionTomarFoto(_ sender: UIButton) {
        MemoriaRegistroConsulta.estaAnexosActiva = true;
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4_camara") as! RegistroPacienteViewController4Camara;
        self.present(vc, animated: true, completion: nil);
    }
    
    @IBAction func accionSiguiente(_ sender: UIButton) {
        if (Validacion.esCadenaVacia(texto: self.txtExamenFisico.text)) {
            Validacion.pintarErrorCampoFormulario(view: self.txtExamenFisico);
            self.txtExamenFisico.becomeFirstResponder();
            Funcionales.mostrarMensajeErrorSimple(view: self, mensaje: Mensajes.INFORMACION_OBLIGATORIA);
        } else {
            self.guardarInformacionActual();
            
            MemoriaRegistroConsulta.listaFotosSeleccionadasAnexos = self.listaSeleccionadasTemporal;
            MemoriaRegistroConsulta.estaAnexosActiva = false;
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_registro_paciente_4") as! RegistroPacienteViewController4;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
}

extension ControlMedicoViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.btnHablarExamenFisico.isEnabled = true;
            self.btnHablarAnexos.isEnabled = true;
        } else {
            self.btnHablarExamenFisico.isEnabled = false;
            self.btnHablarAnexos.isEnabled = false;
        }
    }
}

extension ControlMedicoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemoriaRegistroConsulta.listaFotosAnexos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let indiceEnFotosTomadas = indexPath.row;
        // Se crea el tag con su respectivo valor según la lista activa.
        let tag = MemoriaRegistroConsulta.listaFotosAnexos.count - indiceEnFotosTomadas - 1;
        // Se crea una lista inversa para mostrar las imágenes disponibles.
        let listaInversaImagenesDisponibles: [UIImage?] = MemoriaRegistroConsulta.listaFotosAnexos.reversed();
        
        let imagen = listaInversaImagenesDisponibles[indiceEnFotosTomadas];
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celda_foto", for: indexPath) as! FotosCollectionViewCell;
        //let imagenConRotacion = Funcionales.rotarImagen(oldImage: imagen!, grados: 90);
        celda.btnFoto.setBackgroundImage(imagen, for: .normal);
        celda.btnFoto.tag = tag;
        celda.btnFoto.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        celda.btnFoto.setTitle(tag.description, for: .normal);
        celda.btnSeleccion.tag = tag;
        celda.btnSeleccion.addTarget(self, action: #selector(self.seleccionarFoto(_:)), for: .touchUpInside);
        celda.btnFoto.addTarget(self, action: #selector(self.verFoto(_:)), for: .touchUpInside);
        
        if (self.listaSeleccionadasTemporal.contains(imagen)) {
            celda.btnSeleccion.setBackgroundImage(UIImage(named: Constantes.BOTON_CHECK_ON_AZUL), for: .normal);
        } else {
            celda.btnSeleccion.setBackgroundImage(UIImage(systemName: Constantes.BOTON_CHECK_OFF), for: .normal);
        }
        
        celda.lblMarcaDermatoscopia.isHidden = true;
        
        return celda;
    }
    
    
}
