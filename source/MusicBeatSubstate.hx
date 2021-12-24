package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxBasic;
import flixel.FlxSprite;
#if mobileC
import flixel.input.actions.FlxActionInput as Input;
import ui.FlxVirtualPad;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	
	#if mobileC
	var _virtualPad:FlxVirtualPad;
	
	var trackInputs:Array<Input> = [];
	
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		_virtualPad = new FlxVirtualPad(DPad Action);
		_virtualPad.bgColor.alpha = 0.75;
		this.add(_virtualPad);
		controls.setVirtualPad(_virtualPad, DPad, Action);
		trackInputs = controls.trackedinputs;
		controls.trackedinputs = [];
	}
	
	#if android
	function androidP():Bool return FlxG.android.justPressed.BACK;
	#end
		
	override function destroy() {
		super.destroy();
		
		controls.removeFlxInput(trackInputs);
	}
	#else
	public function addVirtualPad(?DPad, ?Action){};
	#end

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
}
