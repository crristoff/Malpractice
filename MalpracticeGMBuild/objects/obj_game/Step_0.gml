/// @description Insert description here
// You can write your code in this editor
if(global.start_day) //start the first patient walking out
{
	global.start_day = false;
	global.current_patient.speed = 5;
	global.current_patient.entering_screen = true;
	global.day_active = true;
}

if(global.current_patient.finished)
{
	//freeze controls when patient is leaving
	global.day_active = false;
	global.current_patient.finished = false;
	global.symptom_box.visible = false;
	show_debug_message("patient finished \n");
	if(ds_queue_empty(global.patients)) //all patients have been seen
		finish_day();
	else
	{
		//global.textbox.load_new_script(ds_queue_dequeue(global.scripts));
		global.current_patient = ds_queue_dequeue(global.patients);
		global.textbox.load_new_script(ds_queue_dequeue(global.scripts),global.current_patient.patient_id);
		global.current_patient.speed = 5;
		global.current_patient.entering_screen = true;
		switch(global.current_patient.patient_id)
		{
			case 0:
				break;
			case 1:
				audio_play_sound(snd_aria_arrive, 1,false);
				break;
			case 2:
				audio_play_sound(snd_gretsch_arrive, 1,false);
				break;
			default:
				break;
			
		}
	}
}