# Fu-Kit

Do not come to this mod for epic sounding songs, I'm making the songs,
they're gonna be shit and they're gonna hurt your ears, so uhm.

Turn your volume down to like half or a fourth.

This mod is me just saying fuck it and going WILD.

## Credits

Maki - Programming, Art, Animation, Music Design
Kade Dev - Kade Engine 1.4.2 & 1.5

## Compiling

Step by Step to get Compiling once you have the repo downloaded:

1. Install [Haxe](https://haxe.org/download/) (4.3.7 recommended, I don't know about earlier or later versions having support)
2. Run the `libraries.bat` file.
3. Perform additional platform setup
   - For Windows, download the [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
     - When prompted, select "Individual Components" and make sure to download the following:
     - MSVC v143 VS 2022 C++ x64/x86 build tools
     - Windows 10/11 SDK
   - Mac: [`lime setup mac` Documentation](https://lime.openfl.org/docs/advanced-setup/macos/)
   - Linux: [`lime setup linux` Documentation](https://lime.openfl.org/docs/advanced-setup/linux/)
4. If you are targeting for native, you may need to run `lime rebuild <PLATFORM>` and `lime rebuild <PLATFORM> -debug`
5. `lime test <PLATFORM>` to build and launch the game for your platform (for example, `lime test windows`)

And then you should be good!
