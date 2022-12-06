//
//  InternoHistorialViewController.swift
//  Telederma
//
//  Created by Pedro Erazo Acosta on 2/07/20.
//  Copyright © 2020 Pedro Erazo Acosta. All rights reserved.
//

import UIKit

class InternoHistorialViewController: UIViewController {
    
    @IBOutlet weak var vistaCabecera: UIView!
    @IBOutlet weak var tablaHistorial: UITableView!
    
    // Variables para el manejo de datos
    let consultasMedicas: [ConsultaMedica] = MemoriaHistoriaClinica.consultasMedicas.filter({consulta in
        return consulta.consultation_id == nil;
    }).reversed();
    
    // Altos mostrar consultas internas
    let selectedCellHeight: CGFloat = 340.0;
    let unselectedCellHeight: CGFloat = 84.3;
    var selectedCellIndexPath = [IndexPath]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.inits();
    }
    
    private func inits () {
        // Ajuste de estilos
        self.vistaCabecera.layer.borderWidth = 1.5;
        self.vistaCabecera.layer.borderColor = Constantes.COLOR_BOTON_SECUNDARIO.cgColor;
        
        self.tablaHistorial.delegate = self;
        self.tablaHistorial.dataSource = self;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension InternoHistorialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.consultasMedicas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let consulta = self.consultasMedicas[indexPath.row];
        let controles = MemoriaHistoriaClinica.controlesMedicos.filter({ control in
            control.consultation_id == consulta.id
            });
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda_consulta") as! ConsultaTableViewCell;
        var textoDiagnostico = consulta.diagnostic_impression;
        
        let respuestasEspecialista = MemoriaHistoriaClinica.respuestasEspecialistas.filter({$0.consultation_id == consulta.id});
        if (respuestasEspecialista.count > 0) {
            for respuesta in respuestasEspecialista {
                let diagnosticos = MemoriaHistoriaClinica.diagnosticos.filter({$0.specialist_response_id == respuesta.id});
                if (diagnosticos.count > 0) {
                    if let diagnostico = diagnosticos.first(where: {$0.status?.lowercased() == Mensajes.ESTADO_ACTIVO.lowercased()}) {
                        textoDiagnostico = diagnostico.disease;
                        break;
                    }
                }
            }
        }
        
        celda.lblNombre.text = textoDiagnostico;
        celda.lblFecha.text = consulta.created_at;
        celda.imgEstado.image = UIImage(named: Constantes.ESTADO_CONSULTA_IMAGEN[consulta.status ?? 0] ?? "sin_enviar");
        celda.selectionStyle = .none;
        celda.lblEstado.text = Constantes.ESTADO_CONSULTA_TEXTO[consulta.status ?? 0];
        
        celda.activarDelegados();
        
        // Variables de la celda
        celda.paciente = nil;
        celda.informacionPaciente = nil;
        celda.diccionarioConsultas = [:];
        celda.esConsulta = false;
        celda.consultaMedica = consulta;
        celda.diccionarioControles[consulta.id!] = controles.sorted {$0.id! < $1.id!};
        celda.padreViewController = self;
        
        return celda;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let consulta = self.consultasMedicas[indexPath.row];
        let celda = tableView.cellForRow(at: indexPath) as! ConsultaTableViewCell;
        
        
        // Si tiene controles, despliega más información
        let controles = MemoriaHistoriaClinica.controlesMedicos.filter({control in
            control.consultation_control_id == consulta.id
        });
        
        if (controles.count > 0) {
            tableView.beginUpdates();
            
            // Al tocar se oculta o muestra la sección de adicionales.
            celda.mostrarOcultarAdicionales();
            
            if let index = selectedCellIndexPath.firstIndex(of: indexPath) {
                selectedCellIndexPath.remove(at: index);
            } else {
                selectedCellIndexPath.append(indexPath);
            }
            
            tableView.endUpdates();
            
            if selectedCellIndexPath.contains(indexPath) {
                // This ensures, that the cell is fully visible once expanded
                tableView.scrollToRow(at: indexPath, at: .none, animated: true);
            }
        } else {
            // No tiene control pre seleccionado
            MemoriaHistoriaClinica.posicionControlActivo = 0;
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "view_historia_clinica") as! HistoriaClinicaViewController;
            vc.consultaId = consulta.id;
            self.present(vc, animated: true, completion: nil);
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedCellIndexPath.contains(indexPath) {
            return selectedCellHeight;
        }
        return unselectedCellHeight;
    }
    
}
