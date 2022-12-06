//
//  InformacionPacienteViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 20/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class InformacionPacienteViewController: UIViewController {
    
    @IBOutlet weak var header: UINavigationBar!
    // Elementos para la información del usuario
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblConsentimiento: UILabel!
    @IBOutlet weak var lblTipoIdentificacion: UILabel!
    @IBOutlet weak var lblNumeroIdentificacion: UILabel!
    @IBOutlet weak var lblAsegurador: UILabel!
    @IBOutlet weak var lblEstadoCivil: UILabel!
    @IBOutlet weak var lblEdad: UILabel!
    @IBOutlet weak var lblFechaNacimiento: UILabel!
    @IBOutlet weak var lblSexo: UILabel!
    @IBOutlet weak var lblOcupacion: UILabel!
    @IBOutlet weak var lblCelular: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDireccionDomicilio: UILabel!
    @IBOutlet weak var lblDepartamento: UILabel!
    @IBOutlet weak var lblMunicipio: UILabel!
    @IBOutlet weak var lblZonaResidencia: UILabel!
    @IBOutlet weak var lblPersonaAcompaniante: UILabel!
    @IBOutlet weak var lblPersonaResponsable: UILabel!
    @IBOutlet weak var lblTipoUsuario: UILabel!
    @IBOutlet weak var lblNumeroAutorizacion: UILabel!
    @IBOutlet weak var lblFinalidadConsulta: UILabel!
    @IBOutlet weak var lblCausaExterna: UILabel!
    
    
    // Vistas
    @IBOutlet weak var vistaNombre: UIView!
    @IBOutlet weak var vistaConsentimiento: UIView!
    @IBOutlet weak var vistaTipoIdentificacion: UIView!
    @IBOutlet weak var vistaNumeroIdentificacion: UIView!
    @IBOutlet weak var vistaAsegurador: UIView!
    @IBOutlet weak var vistaEstadoCivil: UIView!
    @IBOutlet weak var vistaEdad: UIView!
    @IBOutlet weak var vistaNacimiento: UIView!
    @IBOutlet weak var vistaSexo: UIView!
    @IBOutlet weak var vistaOcupacion: UIView!
    @IBOutlet weak var vistaCelular: UIView!
    @IBOutlet weak var vistaEmail: UIView!
    @IBOutlet weak var vistaDomicilio: UIView!
    @IBOutlet weak var vistaDepartamento: UIView!
    @IBOutlet weak var vistaMunicipio: UIView!
    @IBOutlet weak var vistaZonaResidencia: UIView!
    @IBOutlet weak var vistaAcompaniante: UIView!
    @IBOutlet weak var vistaResponsable: UIView!
    @IBOutlet weak var vistaTipoUsuario: UIView!
    @IBOutlet weak var vistaNumeroAutorizacion: UIView!
    @IBOutlet weak var vistaFinalidadConsulta: UIView!
    @IBOutlet weak var vistaCausaExterna: UIView!
   
    // Variables para gestión de información.
    var consultaId: Int!;
    var conexion = Conexion();
    var listaUnidadMedida = [ConstanteValor]();
    var listaSexo = [ConstanteValor]();
    var listaEstadoCivil = [ConstanteValor]();
    var listaTipoUsuario = [ConstanteValor]();
    var listaCausaExterna = [ConstanteValor]();
    var listaZonaResidencial = [ConstanteValor]();
    var listaTipoIdentificacion = [ConstanteValor]();
    var listaFinalidadConsulta = [ConstanteValor]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajustes de estilos
        self.header.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white];
        self.header.standardAppearance.backgroundColor = Constantes.COLOR_FONDO_AZUL_CLARO;
        
        // Forma a las vistas
        self.vistaNombre.layer.cornerRadius = Constantes.BORDE_BOTON_REDONDEADO;
        
        self.cargarInformacionBase();
    }
    
    private func cargarInformacionBase () {
        self.conexion.conectarBaseDatos();
        
        self.listaUnidadMedida = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "unit_measurement");
        self.listaSexo = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "genre");
        self.listaEstadoCivil = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "civil_status");
        self.listaTipoUsuario = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "type_user");
        self.listaCausaExterna = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "external_cause");
        self.listaZonaResidencial = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "urban_zone");
        self.listaTipoIdentificacion = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "type_document");
        self.listaFinalidadConsulta = FachadaIndependientesSQL.seleccionarPorTipoConstanteValor(conexion: self.conexion, grupo: "consultation_purpose");
        
        self.cargarInformacionPaciente();
    }
    
    private func cargarInformacionPaciente () {
        if let paciente = MemoriaHistoriaClinica.paciente {
            if let informacionPaciente = MemoriaHistoriaClinica.informacionPaciente[self.consultaId]!.first(where: {$0.patient_id == paciente.id}) {
                // Información desde Base de Datos Interna
                var municipio: Municipio?;
                var departamento: Departamento?;
                var asegurador: Aseguradora?;
                
                
                if let municipioPaciente = FachadaIndependientesSQL.seleccionarPorIdMunicipio(conexion: self.conexion, idRegistro: informacionPaciente.municipality_id ?? 0) {
                    municipio = municipioPaciente;
                    
                    if let departamentoPaciente = FachadaIndependientesSQL.seleccionarPorIdDepartamento(conexion: self.conexion, idRegistro: municipio?.department_id ?? 0) {
                        departamento = departamentoPaciente;
                    }
                }
                if let aseguradoraPaciente = FachadaIndependientesSQL.seleccionarPorIdAseguradora(conexion: self.conexion, idRegistro: informacionPaciente.insurance_id!) {
                    asegurador = aseguradoraPaciente;
                }
                // Convertir la fecha de nacimiento en edad.
                let dateFormat = DateFormatter();
                dateFormat.dateFormat = "yyyy-MM-dd";
                let edad = Funcionales.calcularEdad(nacimiento: dateFormat.date(from: paciente.birthdate!)!, listaUnidadMedida: self.listaUnidadMedida, enTexto: true);
                
                
                self.lblNombre.text = "\(paciente.name ?? "") \(paciente.last_name ?? "")";
                if let (cantidad, unidad) = edad {
                    self.lblEdad.text = "\(cantidad) \(unidad)";
                }
                self.lblSexo.text = self.listaSexo.first(where: {$0.value == paciente.genre})?.title;
                self.lblEmail.text = informacionPaciente.email;
                self.lblCelular.text = informacionPaciente.phone;
                self.lblMunicipio.text = "\(municipio?.name ?? "")";
                self.lblDepartamento.text = "\(departamento?.name ?? "")";
                self.lblOcupacion.text = informacionPaciente.occupation;
                self.lblAsegurador.text = "\(asegurador?.name ?? "")";
                self.lblEstadoCivil.text = self.listaEstadoCivil.first(where: {$0.value == informacionPaciente.civil_status})?.title;
                self.lblTipoUsuario.text = self.listaTipoUsuario.first(where: {$0.value == informacionPaciente.type_user})?.title;
                self.lblCausaExterna.text = self.listaCausaExterna.first(where: {$0.value == informacionPaciente.external_cause})?.title;
                self.lblConsentimiento.text = informacionPaciente.terms_conditions == true ? "Si" : "No";
                self.lblZonaResidencia.text = self.listaZonaResidencial.first(where: {$0.value == informacionPaciente.urban_zone})?.title;
                self.lblFechaNacimiento.text = paciente.birthdate;
                self.lblDireccionDomicilio.text = informacionPaciente.address;
                self.lblNumeroAutorizacion.text = informacionPaciente.authorization_number;
                self.lblTipoIdentificacion.text = self.listaTipoIdentificacion.first(where: {$0.value == paciente.type_document})?.title;
                self.lblFinalidadConsulta.text = self.listaFinalidadConsulta.first(where: {$0.value == informacionPaciente.purpose_consultation})?.title;
                self.lblNumeroIdentificacion.text = paciente.number_document;
                self.lblPersonaAcompaniante.text = """
                \(informacionPaciente.name_companion ?? "")
                \(informacionPaciente.phone_companion ?? "")
                """;
                self.lblPersonaResponsable.text = """
                \(informacionPaciente.name_responsible ?? "")
                \(informacionPaciente.phone_responsible ?? "")
                \(informacionPaciente.relationship ?? "")
                """;
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
    
    @IBAction func accionRegresar(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil);
    }
    
}
