// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information



//POTENTIAL FIX TO PERSISTENT CHARACTERS
//Hold an extra array of everyones current symptoms. Additionally, 
//Keep other information that isn't static in the obj_game
function PrescriptionManager()constructor{
	//Array represents all prescriptions
	patient0 = [];
	patient1 = [];
	patient2 = [];
	patient3 = [];
	
	patients = [patient0,patient1,patient2, patient3];
	
	//Add a new medication to the patients list of medication
	function prescribe(_patient_id, _medication)
	{
		array_push(patients[_patient_id], _medication);
		show_debug_message("Prescribed: "+_medication.medication_name + " to " + string(_patient_id));
	}
	
	//Return whatever the current prescription for this character
	function current_prescription(_patient_id)
	{
		patient = patients[_patient_id];
		return patient[array_length(patient)-1];
	}
	
	//Accept the medication, give the player feedback and get a new symptom set up
	function accept_medication(_patient_obj)
	{
		//get the current_medication for this patient
		_med = current_prescription(_patient_obj.patient_id);
		previous_symptom = _patient_obj.current_symptom;
		
		status =check_treatment_status(_patient_obj.patient_id);
		//Set new symptom
		if(status)
		{
			global.current_patient.image_index = 0;
			_patient_obj.current_symptom = _med.causes_symptoms[irandom(array_length(_med.causes_symptoms)-1)];
			global.textbox.dialogue.add(_med.medication_name + ", huh?\nI guess I'll give it\na try.");
		}
		else
		{
			
			global.current_patient.image_index = 2;
			show_debug_message(string(global.current_patient.image_index));
			global.textbox.dialogue.add("Does "+ _med.medication_name + "\neven treat "+previous_symptom+"?\nMaybe I should\nsee someone else.");
		}
	}
	
	//attempts to perscribe selected medication, if it is a match, med will be perscribed, 
	//otherwise the pateint will remark that is incorrect, and score will be adjusted.
	function attempt_prescribe(_medication)
	{
		patient_symptom = global.current_patient.current_symptom;
		treats = array_contains(_medication.treats_symptoms, patient_symptom);
		show_debug_message(global.current_patient.patient_id);
		global.textbox.dialogue.clear(); //we're about to give the character new text that needs to be seen, if
		// if the player hasn't finished the dialouge yet, remove it so new dialouge can be seen
		
		if(treats)
		{
			show_debug_message("make box invis");
			global.symptom_box.visible = false;
			//only prescibe medication if it treats patient
			prescribe(global.current_patient.patient_id, _medication)
			global.current_patient.image_index = 0;
			global.current_patient.current_symptom = _medication.causes_symptoms[irandom(array_length(_medication.causes_symptoms)-1)];
			global.textbox.dialogue.add(_medication.medication_name + ", huh?\nI guess I'll give it\na try.");
			global.current_patient.exiting_screen = true;
			global.day_active = false;
		}
		else
		{
			show_debug_message(global.current_patient.name_first);
			global.symptom_box.visible = true;
			global.current_patient.image_index = 2;
			global.textbox.dialogue.add("Does "+ _medication.medication_name + "\neven treat " + patient_symptom + "?\nMaybe I should\nsee someone else.");
		}
		//Allow the textbox to move to it's next dialogue
		global.textbox.display_next_dialogue();
	}
	
	//Check treatment status. 1 if the symptom is treated by the most recently described drug. 
	function check_treatment_status(_patient_id)
	{
		_drug_prescribed = current_prescription(_patient_id);
		patient_symptom = global.patients[_patient_id].current_symptom;
		return array_contains(_drug_prescribed.treats_symptoms, patient_symptom);
	}
}