/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

dropVerification = function(payload){
    if(payload.lookUp.itemType == itemCat.equipment && payload.lookUp.equipmentType == designatedEquip){
		return true;
	} else { return false;}
};