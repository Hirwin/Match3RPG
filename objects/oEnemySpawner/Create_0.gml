/// @description Insert description here
// You can write your code in this editor
spawnRate = 5;
alarm[0] = room_speed*spawnRate;
//This is how the level will loop  forever
levelLayout = [levelEvent.monster, levelEvent.monster];

currentPoint = 0;

enemyTypes = ds_list_create();
ds_list_add(enemyTypes, enemies.frog);
ds_list_add(enemyTypes, enemies.lizard);

levelTrack = function(_currentPoint){
	var point = levelLayout[_currentPoint];
	switch(point){
		case levelEvent.monster:
		spawnEnemy();
		break;
		case levelEvent.event:
		break;
		case levelEvent.store:
		spawnShop();
		break;
	}
	increasePoint();
	
}

increasePoint = function(){
	if(currentPoint == array_length(levelLayout) - 1){
		currentPoint = 0;
	} else {currentPoint ++;}
}

spawnShop = function(){
	var ins = instance_create_layer(1806, 434, "Events", oItemShop);
	with(ins){
		moveSpeed = 5;
	}
}

spawnEnemy = function(){
	var val = irandom_range(0, ds_list_size(enemyTypes) - 1);
	var enemy = ds_list_find_value(enemyTypes, val)
	switch(enemy){
		//IMPORTANT NOTE
		/*
			for when you split those specific spriet sheets into their individual animations 
			these are the magic values
			idle = 4116
			walk = 4628
			attack = 5140
			damage = 5652
		*/
		case enemies.frog:
			var ins = instance_create_depth(1806, 434, -10, oEnemyParent);
			with(ins){
				image_xscale = .375;
				image_yscale = .375; 
				curHP = 12;
				maxHP = curHP;
				moveSpeed = 5;
				attack = 3;
				attackSpeed = 6;
				actions = ["attack"];
				spriteArray = [s_frogIdle, s_frogHurt, s_frogWalk, s_frogAttack];
				enemyStateChange(enemyState.walking, spriteArray[enemyState.walking], false);
			}
		break;
		case enemies.lizard:
		//The with(ins) here can probably be edited to a script that will access essentialy a lookup table for these enemies
		//yeah i like that alot.
		//it'll let us do things like change the way some of hte other base functions of the oEnemyParent work like just changing up the attack funciton
		//It'll also probably be where we fix up the stat scaling based on some player heuristic
			var ins = instance_create_depth(1806, 434, -10, oEnemyParent);
			with(ins){
				//add all sprites to a list, then access them via an enum so you have a generic script for it
				image_xscale = .375;
				image_yscale = .375; 
				curHP = 10;
				maxHP = curHP;
				moveSpeed = 5;
				attack = 1;
				attackSpeed = 2;
				actions = ["attack"];
				spriteArray = [s_lizardIdle, s_lizardHurt, s_lizardWalk, s_lizardAttack];
				enemyStateChange(enemyState.walking, spriteArray[enemyState.walking], false);
				attackPlayer= function(attack){
					oCharacterData.takeDamage(attack);
					enemyHeal(attack/2);
				}
			}
		break;
		default:
			instance_create_depth(oPlayer.x + (room_width - oPlayer.sprite_width - 20), oPlayer.y, -10, oEnemyParent);
		break;
	}
}


enum levelEvent{
	monster,
	event,
	store
}
