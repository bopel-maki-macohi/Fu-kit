package;

import fukit.objects.FukitSprite;
import CoolUtil;
import fukit.play.components.StageComponent;
import fukit.play.StringToStage;
import fukit.play.objects.*;
import fukit.play.objects.ui.*;
import fukit.states.NewMenuState;
import fukit.Global;
import flixel.group.FlxContainer;
import flixel.group.FlxSpriteGroup;
import fukit.play.songs.*;
import fukit.play.songs.world2.*;
import flixel.util.FlxSignal;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
#if LUA_ALLOWED
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
#end
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
#if windows
import Discord.DiscordClient;
#end
#if desktop
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FukitSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public var songLength:Float = 0;

	#if windows
	// Discord RPC variables
	public var storyDifficultyText:String = "";
	public var iconRPC:String = "";
	public var detailsText:String = "";
	public var detailsPausedText:String = "";
	#end

	public var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var strumLine:FukitSprite;

	public var camFollow:FlxObject;

	public static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StaticNote>;
	public var playerStrums:FlxTypedGroup<StaticNote>;

	public var camZooming:Bool = false;
	public var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	public var misses:Int = 0;

	public var accuracy:Float = 0.00;
	public var accuracyDefault:Float = 0.00;
	public var totalNotesHit:Float = 0;
	public var totalNotesHitDefault:Float = 0;
	public var totalPlayed:Int = 0;

	public var healthBarBG:FukitSprite;
	public var healthBar:FlxBar;
	public var songPositionBar:Float = 0;

	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camTopHUD:FlxCamera;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	public var fc:Bool = true;

	public var songScore:Int = 0;
	public var songScoreDef:Int = 0;

	public var scoreTxt:FlxText;

	public var songName:FlxText;

	public static var campaignScore:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	public var inCutscene:Bool = false;

	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

	// Will fire once to prevent debug spam messages and broken animations
	public var triggeredAlready:Bool = false;

	// Will decide if she's even allowed to headbang at all depending on the song
	public var allowedToHeadbang:Bool = false;

	// Per song additive offset
	public static var songOffset:Float = 0;

	// Replay shit
	public var saveNotes:Array<Float> = [];

	public var executeModchart = false;

	public static var onCreate:FlxSignal = new FlxSignal();
	public static var onUpdate:FlxTypedSignal<Float->Void> = new FlxTypedSignal<Float->Void>();

	public static var onStepHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();
	public static var onBeatHit:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();

	public static var onCountdownStep:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();
	public static var onCountdownEnd:FlxSignal = new FlxSignal();

	public static var onCamMove:FlxTypedSignal<Bool->Void> = new FlxTypedSignal<Bool->Void>();

	public static var onOpponentNote:FlxTypedSignal<Note->Void> = new FlxTypedSignal<Note->Void>();
	public static var onPlayerNote:FlxTypedSignal<Note->Void> = new FlxTypedSignal<Note->Void>();
	public static var onNoteMiss:FlxTypedSignal<Int->Note->Void> = new FlxTypedSignal<Int->Note->Void>();

	public static var onPause:FlxSignal = new FlxSignal();
	public static var onUnpause:FlxSignal = new FlxSignal();

	public var backShit:FlxContainer;
	public var frontShit:FlxContainer;

	public var frontUIShit:FlxContainer;

	public var stage:StageComponent;

	override public function create()
	{
		var signals:Array<FlxTypedSignal<Any>> = [
			onCreate,
			onUpdate,
			onStepHit,
			onBeatHit,
			onCountdownStep,
			onCountdownEnd,
			onCamMove,
			onOpponentNote,
			onPlayerNote,
			onNoteMiss,
			onPause,
			onUnpause,
		];

		for (signal in signals)
			signal.removeAll();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if sys
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0: storyDifficultyText = "Easy";
			case 1: storyDifficultyText = "Normal";
			case 2: storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry': iconRPC = 'senpai';
			case 'monster-christmas': iconRPC = 'monster';
			case 'mom-car': iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ generateRanking(),
			"\nAcc: "
			+ CoolUtil.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end

		// var gameCam:FlxCamera = FlxG.camera;

		camGame = new FlxCamera();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camTopHUD = new FlxCamera();
		camTopHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camTopHUD);

		@:privateAccess
		FlxCamera._defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale);

		backShit = new FlxContainer();
		frontShit = new FlxContainer();
		frontUIShit = new FlxContainer();

		// dialogue

		// stage

		var gfVersion:String = 'gf';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		add(backShit);

		if (dad.curCharacter == gf.curCharacter)
		{
			dad.x = gf.x;
			dad.y = gf.y;
		}
		else
			add(gf);

		add(dad);
		add(boyfriend);

		add(frontShit);

		strumLine = new FukitSprite(0, 50);
		strumLine.makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<StaticNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StaticNote>();

		generateSong(SONG.song);

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
		{
			songPosBG = new FukitSprite(0, 10);
			songPosBG.loadGraphic(Paths.image('UI/healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();

			songPosBar = new FlxBar(songPosBG.x
				+ 4, songPosBG.y
				+ 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength
				- 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20, songPosBG.y, 0, SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
		}

		healthBarBG = new FukitSprite(0, FlxG.height * 0.9);
		healthBarBG.loadGraphic(Paths.image('UI/healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar

		scoreTxt = new FlxText(0, healthBarBG.y + 30, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);

		add(healthBarBG);
		add(healthBar);

		add(iconP1);
		add(iconP2);

		add(scoreTxt);

		if (FlxG.save.data.songPosition)
		{
			add(songPosBG);
			add(songPosBar);
			add(songName);
		}

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		startingSong = true;

		add(frontUIShit);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + dad.dadStartingCamPosOffsets.x,
			dad.getGraphicMidpoint().y + dad.dadStartingCamPosOffsets.y);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		if (SONG.stage != null)
			stage = StringToStage.convert(SONG.stage);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial': new TutorialSong();
			case 'new world', 'wetway', 'rust': new World1Song();
			case 'termination', 'overheat': new FolirWorld2Songs();
			case 'rm -rf': new RMRFSong();
		}

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (startingSong && !inCutscene)
			startCountdown();

		if (!loadRep)
			rep = new Replay("na");

		onCreate.dispatch();

		super.create();
	}

	public var middleScroll:Bool = false;

	public function applyMiddleScroll()
	{
		middleScroll = true;

		for (staticNote in strumLineNotes)
		{
			if (!playerStrums.members.contains(staticNote))
				staticNote.visible = false;
		}

		for (staticNote in playerStrums)
		{
			staticNote.screenCenter(X);
			staticNote.x += Note.swagWidth * (staticNote.ID - 2);
			staticNote.x += 50;
		}
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var countdownIMGAssets:Array<String> = [null, 'ready', 'set', 'go'];
	var countdownSFXAssets:Array<String> = ['intro3', 'intro2', 'intro1', 'introGo'];

	var countdownIMGAssetPrefix:String = '';
	var countdownIMGAssetSuffix:String = '';

	var countdownSFXAssetPrefix:String = '';
	var countdownSFXAssetSuffix:String = '';

	public function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		if (executeModchart) // dude I hate lua (jkjkjkjk)
			initLua();

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (swagCounter != 4)
				onCountdownStep.dispatch(swagCounter);

			switch (swagCounter)
			{
				case 0, 1, 2, 3:
					var img = countdownIMGAssetPrefix + countdownIMGAssets[swagCounter] + countdownIMGAssetSuffix;
					var sfx = countdownSFXAssetPrefix + countdownSFXAssets[swagCounter] + countdownSFXAssetSuffix;

					if (countdownIMGAssets[swagCounter] == null)
						img = null;
					if (countdownSFXAssets[swagCounter] == null)
						sfx = null;

					spawnCountdownSprite(img, sfx);
				case 4: onCountdownEnd.dispatch();
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	function spawnCountdownSprite(image:String, introSFX:String)
	{
		if (image != null)
		{
			var countdownSprite:FukitSprite = new FukitSprite();
			countdownSprite.loadGraphic(Paths.image('UI/countdown/$image'));
			countdownSprite.scrollFactor.set();
			countdownSprite.updateHitbox();

			countdownSprite.screenCenter();
			add(countdownSprite);

			countdownSprite.camera = camTopHUD;

			FlxTween.tween(countdownSprite, {y: countdownSprite.y += 100, alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween)
				{
					countdownSprite.destroy();
				}
			});
		}

		if (introSFX != null)
			FlxG.sound.play(Paths.sound('UI/countdown/$introSFX'), 0.6);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Song check real quick
		switch (curSong)
		{
			default: allowedToHeadbang = false;
		}

		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ generateRanking(),
			"\nAcc: "
			+ CoolUtil.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	var debugNum:Int = 0;

	public function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song.toLowerCase();

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if desktop
		var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
		if (sys.FileSystem.exists(songPath))
			for (file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if (!sys.FileSystem.isDirectory(path))
				{
					if (path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}
					else
					{
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
					if (middleScroll)
						swagNote.visible = false;
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var babyArrow:StaticNote = new StaticNote(i, 50, strumLine.y);

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			if (player == 1)
				playerStrums.add(babyArrow);

			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ generateRanking(),
				"Acc: "
				+ CoolUtil.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;

			onPause.dispatch();
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText
					+ " "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") "
					+ generateRanking(),
					"\nAcc: "
					+ CoolUtil.truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC, true,
					songLength
					- Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end

			onUnpause.dispatch();
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ generateRanking(),
			"\nAcc: "
			+ CoolUtil.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	public var paused:Bool = false;

	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if (misses == 0) // Regular FC
			ranking = "(FC)";
		else if (misses < 10) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch (i)
				{
					case 0: ranking += " AAAAA";
					case 1: ranking += " AAAA:";
					case 2: ranking += " AAAA.";
					case 3: ranking += " AAAA";
					case 4: ranking += " AAA:";
					case 5: ranking += " AAA.";
					case 6: ranking += " AAA";
					case 7: ranking += " AA:";
					case 8: ranking += " AA.";
					case 9: ranking += " AA";
					case 10: ranking += " A:";
					case 11: ranking += " A.";
					case 12: ranking += " A";
					case 13: ranking += " B";
					case 14: ranking += " C";
					case 15: ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		FlxG.camera.followLerp = 0.04 * (60 / (cast(Lib.current.getChildAt(0), Main)).getFPS());

		#if !debug
		perfectMode = false;
		#end

		if (executeModchart && lua != null && songStarted)
		{
			setVar('songPos', Conductor.songPosition);
			setVar('hudZoom', camHUD.zoom);
			setVar('cameraZoom', FlxG.camera.zoom);
			callLua('update', [elapsed]);

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = getVar("strum" + i + "X", "float");
				member.y = getVar("strum" + i + "Y", "float");
				member.angle = getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = getVar('cameraAngle', 'float');
			camHUD.angle = getVar('camHudAngle', 'float');

			healthBarBG.visible = healthBar.visible = iconP1.visible = iconP2.visible = scoreTxt.visible = !getVar("showOnlyStrums", 'bool');

			var p1 = getVar("strumLine1Visible", 'bool');
			var p2 = getVar("strumLine2Visible", 'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for (i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		super.update(elapsed);

		if (!offsetTesting)
		{
			scoreTxt.text = '';

			if (loadRep)
				scoreTxt.text += 'REPLAY: ';

			if (FlxG.save.data.npsDisplay)
				scoreTxt.text += "NPS: " + nps + " | ";

			scoreTxt.text += "Score: ";
			if (FlxG.save.data.accuracyDisplay && Conductor.safeFrames != 10)
				scoreTxt.text += '$songScore ($songScoreDef)';
			else
				scoreTxt.text += '$songScore';

			scoreTxt.text += ' | Combo: $combo';
			scoreTxt.text += ' | Misses: $misses';

			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text += ' | Accuracy: ${CoolUtil.truncateFloat(accuracy, 2)}%';
				scoreTxt.text += ' | ${generateRanking()}';
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;
		}

		scoreTxt.screenCenter(X);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(() -> new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(() -> new ChartingState());
			if (lua != null)
			{
				#if LUA_ALLOWED
				Lua.close(lua);
				#end
				lua = null;
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		iconP1.anim.frameIndex = (healthBar.percent < 20) ? 1 : 0;
		iconP2.anim.frameIndex = (healthBar.percent > 80) ? 1 : 0;

		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(() -> new AnimationDebug(SONG.player2));
			if (lua != null)
			{
				#if LUA_ALLOWED
				Lua.close(lua);
				#end
				lua = null;
			}
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:publicAccess
				{
					FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		generatedMusic = FlxG.sound.music?.playing;

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
		{
			FlxG.watch.addQuick('rep rpesses', repPresses);
			FlxG.watch.addQuick('rep releases', repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") "
				+ generateRanking(),
				"\nAcc: "
				+ CoolUtil.truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end

			// FlxG.switchState(() -> new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
					daNote.visible = daNote.active = false;
				else
					daNote.visible = daNote.active = true;

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					onOpponentNote.dispatch(daNote);

					dad.playSingAnim(daNote, altAnim);

					if (SONG.needsVoices)
						vocals.volume = 1;

					killNote(daNote);
				}

				if (FlxG.save.data.downscroll)
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
							2)));
				else
					daNote.y = (strumLine.y
						- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed,
							2)));

				if (daNote.mustPress && !daNote.modifiedByLua)
				{
					daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}
				else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
				{
					daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}

				if (daNote.isSustainNote)
					daNote.x += daNote.width / 2 + 17;

				// trace(daNote.y);
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
					&& daNote.mustPress)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						killNote(daNote);
					}
					else
					{
						health -= 0.075;
						vocals.volume = 0;
						if (theFunne)
							noteMiss(daNote.noteData, daNote);
					}

					killNote(daNote);
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		onUpdate.dispatch(elapsed);
	}

	function killNote(note:Note)
	{
		note.active = false;

		note.kill();
		notes.remove(note, true);
		note.destroy();
	}

	public var defaultCamMove:Bool = true;

	public function camMove(playerCam:Bool)
	{
		if (!defaultCamMove)
			return;

		if (!playerCam)
		{
			camFollow.setPosition(dad.getMidpoint().x
				+ 150
				+ (lua != null ? getVar("followXOffset", "float") : 0),
				dad.getMidpoint().y
				- 100
				+ (lua != null ? getVar("followYOffset", "float") : 0));
		}

		if (playerCam)
		{
			camFollow.setPosition(boyfriend.getMidpoint().x
				- 100
				+ (lua != null ? getVar("followXOffset", "float") : 0),
				boyfriend.getMidpoint().y
				- 100
				+ (lua != null ? getVar("followYOffset", "float") : 0));
		}

		onCamMove.dispatch(playerCam);
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay(saveNotes);

		if (executeModchart)
		{
			#if LUA_ALLOWED
			Lua.close(lua);
			#end
			lua = null;
		}

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			Global.playMainTheme();
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new NewMenuState('Options'));
			FlxG.save.data.offset = offsetTest;

			return;
		}

		if (!isStoryMode)
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(() -> new NewMenuState('Freeplay'));

			return;
		}

		campaignScore += Math.round(songScore);

		storyPlaylist.remove(storyPlaylist[0]);

		if (storyPlaylist.length <= 0)
		{
			Global.playMainTheme();

			if (lua != null)
			{
				#if LUA_ALLOWED
				Lua.close(lua);
				#end
				lua = null;
			}

			if (SONG.validScore)
				Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

			// FlxG.switchState(() -> new StoryMenuState());
			FlxG.switchState(() -> new NewMenuState('Story Mode'));
		}
		else
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;

			prevCamFollow = camFollow;

			FlxG.sound.music.stop();
			Global.goIntoSong(PlayState.storyPlaylist[0].toLowerCase(), storyDifficulty, storyWeek, true);
		}
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	public function popUpScore(daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
		var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);

		vocals.volume = 1;

		var score:Float = 350;

		if (FlxG.save.data.accuracyComplex)
			totalNotesHit += wife;

		var daRating = daNote.rating;

		switch (daRating)
		{
			case 'shit':
				shits++;
				score = -300;

				health -= 0.2;

				combo = 0;
				misses++;

				if (!FlxG.save.data.accuracyComplex)
					totalNotesHit += 0.25;

			case 'bad':
				bads++;
				score = 0;

				health -= 0.06;

				if (!FlxG.save.data.accuracyComplex)
					totalNotesHit += 0.50;

			case 'good':
				goods++;
				score = 200;

				health += 0.04;

				if (!FlxG.save.data.accuracyComplex)
					totalNotesHit += 0.75;

			case 'sick':
				sicks++;
				health += 0.1;

				if (!FlxG.save.data.accuracyComplex)
					totalNotesHit += 1;
		}

		if (health > 2)
			health = 2;

		if (score > 0)
		{
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
		}

		if (ratingSprite == null)
		{
			ratingSprite = new RatingSprite();
			ratingSprite.camera = camHUD;
			add(ratingSprite);

			onPause.add(() ->
			{
				if (ratingSpriteTween != null)
					ratingSpriteTween.active = false;
			});

			onUnpause.add(() ->
			{
				if (ratingSpriteTween != null)
					ratingSpriteTween.active = true;
			});
		}

		ratingSprite.setRating(daRating);

		ratingSprite.scale.set(.5, .5);
		ratingSprite.updateHitbox();

		ratingSprite.x = FlxG.width - ratingSprite.width - 32;
		ratingSprite.y = FlxG.height - ratingSprite.height - 32;

		if (FlxG.save.data.downscroll)
			ratingSprite.y = 32;

		FlxTween.cancelTweensOf(ratingSprite);

		ratingSprite.alpha = 1;
		ratingSpriteTween = FlxTween.tween(ratingSprite, {alpha: 0}, 1, {startDelay: 2});
	}

	public var ratingSprite:RatingSprite;
	public var ratingSpriteTween:FlxTween;

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	public function keyShit():Void // I've invested in emma stocks
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		if (loadRep) // replay code
		{
			// disable input
			holdArray[2] = false;
			holdArray[1] = false;
			holdArray[3] = false;
			holdArray[0] = false;

			// new input

			// if (rep.replay.keys[repPresses].time == Conductor.songPosition)
			//	trace('DO IT!!!!!');

			// timeCurrently = Math.abs(rep.replay.keyPresses[repPresses].time - Conductor.songPosition);
			// timeCurrentlyR = Math.abs(rep.replay.keyReleases[repReleases].time - Conductor.songPosition);

			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				pressArray[2] = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition
					&& rep.replay.keyPresses[repPresses].key == "up";
				pressArray[3] = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition
					&& rep.replay.keyPresses[repPresses].key == "right";
				pressArray[1] = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition
					&& rep.replay.keyPresses[repPresses].key == "down";
				pressArray[0] = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition
					&& rep.replay.keyPresses[repPresses].key == "left";

				releaseArray[2] = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition
					&& rep.replay.keyReleases[repReleases].key == "up";
				releaseArray[3] = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition
					&& rep.replay.keyReleases[repReleases].key == "right";
				releaseArray[1] = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition
					&& rep.replay.keyReleases[repReleases].key == "down";
				releaseArray[0] = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition
					&& rep.replay.keyReleases[repReleases].key == "left";

				upHold = pressArray[2] ? true : releaseArray[2] ? false : true;
				rightHold = pressArray[3] ? true : releaseArray[3] ? false : true;
				downHold = pressArray[1] ? true : releaseArray[1] ? false : true;
				leftHold = pressArray[0] ? true : releaseArray[0] ? false : true;
			}
		}
		else if (!loadRep) // record replay code
		{
			if (pressArray[2])
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (pressArray[3])
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (pressArray[1])
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (pressArray[0])
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (releaseArray[2])
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (releaseArray[3])
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (releaseArray[1])
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (releaseArray[0])
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}

		// Prevent player input if botplay is on
		// If it existed
		if (FlxG.save.data.botplay)
		{
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		}

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteData))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				killNote(note);
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var dontCheck = false;

			for (i in 0...pressArray.length)
			{
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}

			if (perfectMode)
				goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0 && !dontCheck)
			{
				if (!FlxG.save.data.ghostTapping)
				{
					for (shit in 0...pressArray.length)
					{ // if a direction is hit that shouldn't be
						if (pressArray[shit] && !directionList.contains(shit))
							noteMiss(shit, null);
					}
				}
				for (coolNote in possibleNotes)
				{
					if (pressArray[coolNote.noteData])
					{
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						goodNoteHit(coolNote);
					}
				}
			}
			else if (!FlxG.save.data.ghostTapping)
			{
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						noteMiss(shit, null);
			}

			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghostTapping && !FlxG.save.data.botplay)
			{
				if (mashViolations > 8)
				{
					trace('mash violations ' + mashViolations);
					scoreTxt.color = FlxColor.RED;
					noteMiss(0, null);
				}
				else
					mashViolations++;
			}
		}

		notes.forEachAlive(function(daNote:Note)
		{
			if (FlxG.save.data.downscroll && daNote.y > strumLine.y || !FlxG.save.data.downscroll && daNote.y < strumLine.y)
			{
				// Force good note hit regardless if it's too late to hit it or not as a fail safe
				if (FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress || FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
				{
					if (loadRep)
					{
						// trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
						if (rep.replay.songNotes.contains(CoolUtil.truncateFloat(daNote.strumTime, 2)))
						{
							goodNoteHit(daNote);
							boyfriend.holdTimer = daNote.sustainLength;
						}
					}
					else
					{
						goodNoteHit(daNote);
						boyfriend.holdTimer = daNote.sustainLength;
					}
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
		{
			if (boyfriend.anim.name.startsWith('sing') && !boyfriend.anim.name.endsWith('miss'))
				boyfriend.dance();
		}

		playerStrums.forEach(function(spr:FukitSprite)
		{
			if (pressArray[spr.ID] && spr.anim.name != 'confirm')
				spr.playAnim('pressed');
			if (!holdArray[spr.ID])
				spr.playAnim('static');
		});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (boyfriend.stunned)
			return;

		health -= 0.04;

		if (combo > 5 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');

		combo = 0;
		misses++;

		var noteDiff:Float = Math.abs(daNote?.strumTime ?? 0 - Conductor.songPosition);
		var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

		if (FlxG.save.data.accuracyComplex)
			totalNotesHit += wife;

		songScore -= 10;

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

		boyfriend.playSingAnim((daNote == null) ? new Note(0, direction, null, false) : daNote, 'miss');

		updateAccuracy();

		onNoteMiss.dispatch(direction, daNote);
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = Math.max(0, totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}

	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}

	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
			note.rating = "shit";
		else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
			note.rating = "bad";
		else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
			note.rating = "good";
		else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
			note.rating = "sick";

		if (loadRep)
		{
			if (controlArray[note.noteData])
				goodNoteHit(note);
			else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
			{
				if (NearlyEquals(note.strumTime, rep.replay.keyPresses[repPresses].time, 4))
				{
					goodNoteHit(note);
				}
			}
		}
		else if (controlArray[note.noteData])
		{
			for (b in controlArray)
			{
				if (b)
					mashing++;
			}

			// ANTI MASH CODE FOR THE BOYS

			if (mashing <= getKeyPresses(note) && mashViolations < 2)
			{
				mashViolations++;

				goodNoteHit(note, (mashing <= getKeyPresses(note)));
			}
			else
			{
				// this is bad but fuck you
				for (i in 0...4)
					playerStrums.members[i].playAnim('static');
				health -= 0.2;
				trace('mash ' + mashing);
			}

			if (mashing != 0)
				mashing = 0;
		}
	}

	var nps:Int = 0;

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

		note.rating = Ratings.CalculateRating(noteDiff);

		if (!note.isSustainNote)
			notesHitArray.push(Date.now());

		if (resetMashViolation)
			mashViolations--;

		if (note.wasGoodHit)
			return;

		if (!note.isSustainNote)
		{
			popUpScore(note);
			combo += 1;
		}
		else
			totalNotesHit += 1;

		boyfriend.playSingAnim(note);

		if (!loadRep)
			playerStrums.forEach(function(spr:FukitSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
					spr.playAnim('confirm', true);
			});

		if (!loadRep && note.mustPress)
			saveNotes.push(CoolUtil.truncateFloat(note.strumTime, 2));

		note.wasGoodHit = true;
		vocals.volume = 1;

		killNote(note);

		updateAccuracy();

		onPlayerNote.dispatch(note);
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music == null || !FlxG.sound.music?.playing)
			return;

		if (FlxG.sound.music?.time > Conductor.songPosition + 20 || FlxG.sound.music?.time < Conductor.songPosition - 20)
			resyncVocals();

		if (executeModchart && lua != null)
		{
			setVar('curStep', curStep);
			callLua('stepHit', [curStep]);
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			camMove(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);

		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") "
			+ generateRanking(),
			"Acc: "
			+ CoolUtil.truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			songLength
			- Conductor.songPosition);
		#end

		onStepHit.dispatch(curStep);
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);

		if (executeModchart && lua != null)
		{
			setVar('curBeat', curBeat);
			callLua('beatHit', [curBeat]);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (!boyfriend.anim?.name?.startsWith("sing"))
			boyfriend.dance();

		if (!dad.anim?.name?.startsWith("sing") || dad?.anim?.finished)
			dad.dance();

		onBeatHit.dispatch(curBeat);
	}

	// LUA SHIT
	#if LUA_ALLOWED
	public static var lua:State = null;
	#else
	public static var lua:Dynamic = null;
	#end

	function callLua(func_name:String, args:Array<Dynamic>, ?type:String):Dynamic
	{
		var result:Any = null;

		#if LUA_ALLOWED
		Lua.getglobal(lua, func_name);

		for (arg in args)
		{
			Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);

		if (getLuaErrorMessage(lua) != null)
			trace(func_name + ' LUA CALL ERROR ' + Lua.tostring(lua, result));
		#end

		if (result == null)
		{
			return null;
		}
		else
		{
			return convert(result, type);
		}
	}

	function getType(l, type):Any
	{
		#if LUA_ALLOWED
		return switch Lua.type(l, type)
		{
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type) : String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
		#else
		return null;
		#end
	}

	function getReturnValues(l)
	{
		var lua_v:Int;
		var v:Any = null;

		#if LUA_ALLOWED
		while ((lua_v = Lua.gettop(l)) != 0)
		{
			var type:String = getType(l, lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		#end

		return v;
	}

	public function convert(v:Any, type:String):Dynamic
	{ // I didn't write this lol
		if (Std.isOfType(v, String) && type != null)
		{
			var v:String = v;
			if (type.substr(0, 4) == 'array')
			{
				if (type.substr(4) == 'float')
				{
					var array:Array<String> = v.split(',');
					var array2:Array<Float> = new Array();

					for (vars in array)
					{
						array2.push(Std.parseFloat(vars));
					}

					return array2;
				}
				else if (type.substr(4) == 'int')
				{
					var array:Array<String> = v.split(',');
					var array2:Array<Int> = new Array();

					for (vars in array)
					{
						array2.push(Std.parseInt(vars));
					}

					return array2;
				}
				else
				{
					var array:Array<String> = v.split(',');
					return array;
				}
			}
			else if (type == 'float')
			{
				return Std.parseFloat(v);
			}
			else if (type == 'int')
			{
				return Std.parseInt(v);
			}
			else if (type == 'bool')
			{
				if (v == 'true')
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return v;
			}
		}
		else
		{
			return v;
		}
	}

	function getLuaErrorMessage(l)
	{
		#if LUA_ALLOWED
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
		#else
		return 'No Lua';
		#end
	}

	public function setVar(var_name:String, object:Dynamic)
	{
		// trace('setting variable ' + var_name + ' to ' + object);

		#if LUA_ALLOWED
		Lua.pushnumber(lua, object);
		Lua.setglobal(lua, var_name);
		#end
	}

	public function getVar(var_name:String, type:String):Dynamic
	{
		var result:Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		#if LUA_ALLOWED
		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua, -1);
		Lua.pop(lua, 1);
		#end

		if (result == null)
		{
			return null;
		}
		else
		{
			var result = convert(result, type);
			// trace(var_name + ' result: ' + result);
			return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch (id)
		{
			case 'boyfriend': return boyfriend;
			case 'girlfriend': return gf;
			case 'dad': return dad;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
			return strumLineNotes.members[Std.parseInt(id)];
		return luaSprites.get(id);
	}

	public static var luaSprites:Map<String, FukitSprite> = [];

	function makeLuaSprite(spritePath:String, toBeCalled:String, drawBehind:Bool)
	{
		#if sys
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + PlayState.SONG.song.toLowerCase() + '/' + spritePath + ".png");

		var sprite:FukitSprite = new FukitSprite(0, 0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
			scale = 1;

		sprite.makeGraphic(Std.int(data.width * scale), Std.int(data.width * scale), FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;

		luaSprites.set(toBeCalled, sprite);

		if (drawBehind)
			backShit.add(sprite);
		else
			frontShit.add(sprite);
		#end
		return toBeCalled;
	}

	function initLua()
	{
		#if LUA_ALLOWED
		trace('opening a lua state (because we are cool :))');
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		trace("Lua version: " + Lua.version());
		trace("LuaJIT version: " + Lua.versionJIT());
		Lua.init_callbacks(lua);

		var result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart")); // execute le file

		if (result != 0)
			trace('COMPILE ERROR\n' + getLuaErrorMessage(lua));

		// get some fukin globals up in here bois

		setVar("bpm", Conductor.bpm);
		setVar("fpsCap", FlxG.save.data.fpsCap);
		setVar("downscroll", FlxG.save.data.downscroll);

		setVar("curStep", 0);
		setVar("curBeat", 0);

		setVar("hudZoom", camHUD.zoom);
		setVar("cameraZoom", FlxG.camera.zoom);

		setVar("cameraAngle", FlxG.camera.angle);
		setVar("camHudAngle", camHUD.angle);

		setVar("followXOffset", 0);
		setVar("followYOffset", 0);

		setVar("showOnlyStrums", false);
		setVar("strumLine1Visible", true);
		setVar("strumLine2Visible", true);

		setVar("screenWidth", FlxG.width);
		setVar("screenHeight", FlxG.height);
		setVar("hudWidth", camHUD.width);
		setVar("hudHeight", camHUD.height);

		// callbacks

		// sprites

		trace(Lua_helper.add_callback(lua, "makeSprite", makeLuaSprite));

		Lua_helper.add_callback(lua, "destroySprite", function(id:String)
		{
			var sprite = luaSprites.get(id);
			if (sprite == null)
				return false;
			remove(sprite);
			return true;
		});

		// hud/camera

		trace(Lua_helper.add_callback(lua, "setHudPosition", function(x:Int, y:Int)
		{
			camHUD.x = x;
			camHUD.y = y;
		}));

		trace(Lua_helper.add_callback(lua, "getHudX", function()
		{
			return camHUD.x;
		}));

		trace(Lua_helper.add_callback(lua, "getHudY", function()
		{
			return camHUD.y;
		}));

		trace(Lua_helper.add_callback(lua, "setCamPosition", function(x:Int, y:Int)
		{
			FlxG.camera.x = x;
			FlxG.camera.y = y;
		}));

		trace(Lua_helper.add_callback(lua, "getCameraX", function()
		{
			return FlxG.camera.x;
		}));

		trace(Lua_helper.add_callback(lua, "getCameraY", function()
		{
			return FlxG.camera.y;
		}));

		trace(Lua_helper.add_callback(lua, "setCamZoom", function(zoomAmount:Int)
		{
			FlxG.camera.zoom = zoomAmount;
		}));

		trace(Lua_helper.add_callback(lua, "setHudZoom", function(zoomAmount:Int)
		{
			camHUD.zoom = zoomAmount;
		}));

		// actors

		trace(Lua_helper.add_callback(lua, "getRenderedNotes", function()
		{
			return notes.length;
		}));

		trace(Lua_helper.add_callback(lua, "getRenderedNoteX", function(id:Int)
		{
			return notes.members[id].x;
		}));

		trace(Lua_helper.add_callback(lua, "getRenderedNoteY", function(id:Int)
		{
			return notes.members[id].y;
		}));

		trace(Lua_helper.add_callback(lua, "getRenderedNoteScaleX", function(id:Int)
		{
			return notes.members[id].scale.x;
		}));

		trace(Lua_helper.add_callback(lua, "getRenderedNoteScaleY", function(id:Int)
		{
			return notes.members[id].scale.y;
		}));

		trace(Lua_helper.add_callback(lua, "getRenderedNoteAlpha", function(id:Int)
		{
			return notes.members[id].alpha;
		}));

		trace(Lua_helper.add_callback(lua, "setRenderedNotePos", function(x:Int, y:Int, id:Int)
		{
			notes.members[id].modifiedByLua = true;
			notes.members[id].x = x;
			notes.members[id].y = y;
		}));

		trace(Lua_helper.add_callback(lua, "setRenderedNoteAlpha", function(alpha:Float, id:Int)
		{
			notes.members[id].modifiedByLua = true;
			notes.members[id].alpha = alpha;
		}));

		trace(Lua_helper.add_callback(lua, "setRenderedNoteScale", function(scale:Float, id:Int)
		{
			notes.members[id].modifiedByLua = true;
			notes.members[id].setGraphicSize(Std.int(notes.members[id].width * scale));
		}));

		trace(Lua_helper.add_callback(lua, "setRenderedNoteScaleX", function(scale:Float, id:Int)
		{
			notes.members[id].modifiedByLua = true;
			notes.members[id].scale.x = scale;
		}));

		trace(Lua_helper.add_callback(lua, "setRenderedNoteScaleY", function(scale:Float, id:Int)
		{
			notes.members[id].modifiedByLua = true;
			notes.members[id].scale.y = scale;
		}));

		trace(Lua_helper.add_callback(lua, "setActorX", function(x:Int, id:String)
		{
			getActorByName(id).x = x;
		}));

		trace(Lua_helper.add_callback(lua, "setActorAlpha", function(alpha:Int, id:String)
		{
			getActorByName(id).alpha = alpha;
		}));

		trace(Lua_helper.add_callback(lua, "setActorY", function(y:Int, id:String)
		{
			getActorByName(id).y = y;
		}));

		trace(Lua_helper.add_callback(lua, "setActorAngle", function(angle:Int, id:String)
		{
			getActorByName(id).angle = angle;
		}));

		trace(Lua_helper.add_callback(lua, "setActorScale", function(scale:Float, id:String)
		{
			getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
		}));

		trace(Lua_helper.add_callback(lua, "setActorScaleX", function(scale:Float, id:String)
		{
			getActorByName(id).scale.x = scale;
		}));

		trace(Lua_helper.add_callback(lua, "setActorScaleY", function(scale:Float, id:String)
		{
			getActorByName(id).scale.y = scale;
		}));

		trace(Lua_helper.add_callback(lua, "getActorWidth", function(id:String)
		{
			return getActorByName(id).width;
		}));

		trace(Lua_helper.add_callback(lua, "getActorHeight", function(id:String)
		{
			return getActorByName(id).height;
		}));

		trace(Lua_helper.add_callback(lua, "getActorAlpha", function(id:String)
		{
			return getActorByName(id).alpha;
		}));

		trace(Lua_helper.add_callback(lua, "getActorAngle", function(id:String)
		{
			return getActorByName(id).angle;
		}));

		trace(Lua_helper.add_callback(lua, "getActorX", function(id:String)
		{
			return getActorByName(id).x;
		}));

		trace(Lua_helper.add_callback(lua, "getActorY", function(id:String)
		{
			return getActorByName(id).y;
		}));

		trace(Lua_helper.add_callback(lua, "getActorScaleX", function(id:String)
		{
			return getActorByName(id).scale.x;
		}));

		trace(Lua_helper.add_callback(lua, "getActorScaleY", function(id:String)
		{
			return getActorByName(id).scale.y;
		}));

		// tweens

		Lua_helper.add_callback(lua, "tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {
				ease: FlxEase.cubeIn,
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {
				ease: FlxEase.cubeIn,
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {
				ease: FlxEase.cubeIn,
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {
				ease: FlxEase.cubeIn,
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenFadeIn", function(id:String, toAlpha:Int, time:Float, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {
				ease: FlxEase.circIn,
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		Lua_helper.add_callback(lua, "tweenFadeOut", function(id:String, toAlpha:Int, time:Float, onComplete:String)
		{
			FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {
				ease: FlxEase.circOut,
				onComplete: function(flxTween:FlxTween)
				{
					if (onComplete != '' && onComplete != null)
					{
						callLua(onComplete, [id]);
					}
				}
			});
		});

		for (i in 0...strumLineNotes.length)
		{
			var member = strumLineNotes.members[i];
			trace(strumLineNotes.members[i].x + " " + strumLineNotes.members[i].y + " " + strumLineNotes.members[i].angle + " | strum" + i);
			// setVar("strum" + i + "X", Math.floor(member.x));
			setVar("defaultStrum" + i + "X", Math.floor(member.x));
			// setVar("strum" + i + "Y", Math.floor(member.y));
			setVar("defaultStrum" + i + "Y", Math.floor(member.y));
			// setVar("strum" + i + "Angle", Math.floor(member.angle));
			setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
			trace("Adding strum" + i);
		}

		trace('calling start function');

		trace('return: ' + Lua.tostring(lua, callLua('start', [PlayState.SONG.song])));
		#end
	}
}
