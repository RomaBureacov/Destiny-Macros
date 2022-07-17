How this macro works:
In Destiny 2, currently there is an active exploit for the glaives, where the melee can be cancelled part-way through and another melee can be thrown. This is similar to the BXR trick of Halo 2. The glaive melee speed can be increased by hitting:

	melee -> reload -> melee -> reload -> melee -> ...

Note that this requires the glaive to be in a reloadable state.

The script will spam the melee and reload buttons by using a single key. Note that this implies that one key will spam the melee and reload keys, ultimately making it impossible to type with that key unless the script is suspended.

Script functions:
ctrl + shift + s
	- open settings, adjust delay between melee and reload inputs. 
	- If the key delay is too small, the script might provide input too quickly for the game to register, potentially leading to worse performance of the script.
ctrl + shift + p
	- toggle suspend on the script
	- press to suspend the script, press again to unsuspend
win + shift + e
	- close the script
	- closing the script may also be done through the system tray
v
	- hold this key to spam the melee and reload keys
	- this key cannot be changed without adjusting the source code
