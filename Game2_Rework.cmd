@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
REM Do not edit the code below!
Set LF=^


Set "TAB=	"
REM Do not edit the code above!

:: EQU 				equal to
:: NEQ 				not equal to
:: LSS 				less than
:: LEQ 				less than or equal to
:: GTR 				greater than
:: GEQ	 			greater than or equal to 

:: /D 				Indicates that the set contains directories.
:: /R 				Causes the command to be executed recursively through the sub-directories of an indicated parent directory
:: /L 				Loops through a command using starting, stepping, and ending parameters indicated in the set.
:: /F	 			Parses files or command output in a variety of ways 

:: eol=c			Specifies an end of line character (just one character).
:: skip=n			Specifies the number of lines to skip at the beginning of the file.
:: delims=xxx		Specifies a delimiter set. This replaces the default delimiter set of space and tab.
:: tokens=x,y,m-n	Specifies which tokens from each line are to be passed to the for body for each iteration. As a result, additional variable names are allocated. The m-n form is a range, specifying the mth through the nth tokens. If the last character in the tokens= string is an asterisk (*), an additional variable is allocated and receives the remaining text on the line after the last token that is parsed.
:: usebackq			Specifies that you can use quotation marks to quote file names in filenameset, a back quoted string is executed as a command, and a single quoted string is a literal string command.

:PreInit
REM Set Directory to where the file is..
SET ".=%~p0"&&SET ".=!.:%~n0=!"&&CD "!.!"&&SET ".="

:: Setup Screen variables  !IMPORTAINT  (Most of this stuff gets changed when you load a world / Dont not edit)
Set "sw=80" && REM Screen Width			(Default value is 80)
Set "sh=27" && REM Screen Height		(Default value is 27)
Set "fi=ÿ"	&& REM The default filler	(Default value is ÿ)

:: Setup World variables   !IMPORTAINT  (Most of this stuff gets changed when you load a world / Dont not edit)
Set "wo="	&& REM Current World		(This is initialized after a map is loaded)
Set "ew="	&& REM Empty World			(This is initialized after a map is loaded)
Set "mc="	&& REM Max Screen Chars		(This is initialized after a map is loaded)
Set "wx=0"	&& REM World[wx,wy]			(This is what section of the world the player are)
Set "wy=0"	&& REM World[wx,wy]			(This is what section of the world the player are)
Set "ww=0"	&& REM Worlds right			(This is how many worlds there are to the right)
Set "wh=0"	&& REM Worlds down			(This is how many worlds there are downwards)

:: Setup Player variables  !IMPORTAINT  (Most of this stuff gets changed when you load a world / Dont not edit)
Set "pl=@"  && REM Player character		(Default value is 27)
Set "px=1"	&& REM Player X position	(Default value is 1. 1 is the minimum value)
Set "py=1"	&& REM Player Y position	(Default value is 1. 1 is the minimum value)
Set "ph=0"	&& REM Player Health		(This is not implemented yet)

Set "blocks= " && REM You need the space for the program work...
Call :LoadWorld "test.txt"  && REM  	(Use this if you want to load your own world)

:Init
REM Change Screen Size without changing the default Size
REM Call :SetMapSize "%sw%" "%sh%"

Goto Draw
Pause>Nul
Exit /b


:Draw
Cls
Set ".d1=!wo:~0,%.p0%!"
Set /a ".p1=!.p0!+1"
Set ".d2=!wo:~%.p1%!"
Set ".df=!.d1!!pl!!.d2!"
Set ".df=!.df:~0,%mx%!"
Set /p ".=.!.df!"<nul
Set ".p1="
Call :Input
Goto Draw


:Input
call :AdvancedKeyboard
If /I "!.k!" EQU "W" call :PlayerMove "1" "0"
If /I "!.k!" EQU "A" call :PlayerMove "0" "1"
If /I "!.k!" EQU "S" call :PlayerMove "1" "2"
If /I "!.k!" EQU "D" call :PlayerMove "2" "1"
Exit /b


:PlayerMove [%1 = New Player X] [%2 = New Player Y]
Set "nwx=!wx!" && Set "nwy=!wy!"
Set "ox=!px!" && Set "oy=!py!"
Set "nx=%~1" && Set "ny=%~2"

If "!ny!" EQU "1" (
	If "!nx!" EQU "2" (
		If "!px!" NEQ "!sw!" (
			Set /a "px=!px!+!nx!-1"
		) Else If "!wx!" NEQ "!pr!" Set /a "nwx=!nwx!+1"
	) Else ( REM If "!nx!" EQU "0"
		If "!px!" NEQ "1" (
			Set /a "px=!px!+!nx!-1"
		) Else If "!wx!" NEQ "0" Set /a "nwx=!nwx!-1"
	)
) Else (
	If "!ny!" EQU "2" (
		If "!py!" NEQ "!sh!" (
			Set /a "py=!py!+!ny!-1"
		) Else If "!wy!" NEQ "!pd!" Set /a "nwy=!nwy!+1"
	) Else ( REM If "!ny!" EQU "0"
		If "!py!" NEQ "1" (
			Set /a "py=!py!+!ny!-1"
		) Else If "!wy!" NEQ "0" Set /a "nwy=!nwy!-1"
	)
)

Call :Colide "!py!" "!px!"
If Defined .r (
	Set "py=!oy!" && Set "px=!ox!"
	Set ".r="
	Exit /b
)

If "!nwy!!nwx!" NEQ "!wy!!wx!" (
	If !nwx! LSS !wx! ( Set "px=!sw!" ) Else If !nwx! GTR !wx! Set "px=1"
	If !nwy! LSS !wy! ( Set "py=!sh!" ) Else If !nwy! GTR !wy! Set "py=1"
	
	Call :GetDimension "!nwy!" "!nwx!"
	Call :Colide "!py!" "!px!"
	REM Echo..!nwy! : !nwx! ; !wy! : !wx! ; !px! : !py! ; !.r! : !.b!
	REM Pause>Nul
	If Defined .r (
		Set "px=!ox!"&&Set "py=!oy!"
		Call :GetDimension "!wy!" "!wx!"
	) Else Set "wy=!nwy!" && Set "wx=!nwx!"
	Set ".r="
)

Set /a ".p0=(!py!-1)*!sw!+!px!-1"
Set "nx="&&Set "ny="
Exit /b


:Colide [%1 = Y] [%2 = X]
Call :GetBlock "%~1" "%~2"
If Not Defined .r Set ".r="&& Exit /b
Set ".l=!blocks:%.r%=!"
Set ".b=!.r!"
REM Echo.."!blocks!" // "!.l!"
REM Pause>Nul
Set ".r="
If "!blocks!" NEQ "!.l!" ( Set ".r=1" ) Else Set "r="
Set ".l="
Exit /b


:GetBlock [%1 = Y] [%2 = X]
Set /a ".0=(%~1-1)*!sw!+%~2-1"
Set ".r=!wo:~%.0%,1!"
Set ".0="
Exit /b


:SetMapSize [%1 = Width] [%2 = Height]
Set "ew="
For /L %%A In (1 1 %~1) Do Set ".s=!.s!!fi!"
For /L %%A In (1 1 %~2) Do Set "ew=!ew!!.s!"
Set /a "mx=%~1*%~2-1"
Set ".s="
SetLocal
Mode %~1, %~2
EndLocal
Exit /b


:SetDimension [%1 = Y] [%2 = X] [%3 = Variable Name]
Set "/%~1/%~2=!%~3!"
Exit /b


:GetDimension [%1 = Y] [%2 = X] 
Call Set "wo=%%/%~1/%~2%%"
Exit /b


REM This is a wery advanced Length method
:Length [%1 = String Name]
Set "l0=!%~1!"
Set "length=0"
If "!l0!" EQU "" Exit /b
Set "l1=1"&&Set "l2=0"
Set "l3=1000"
:LLoop
Set "char=!l0:~%l1%,1!"
If Defined char (
	Set "l2=!l1!"&&Set /a "l1=!l1!+!l3!"
	If "!l2!" EQU "!l1!" Set /a "length=!l1!+1"&&Exit /b
) Else Set "l1=!l2!"&&Set /a "l3=!l3!/10"
Goto LLoop
Exit /b


:IsNumeric [%1 = Number]
Set ".="&For /F "Delims=0123456789" %%I in ("%1") Do Set ".=%%I"
Exit /b


REM To use write "call :AdvancedKeyboard"
:AdvancedKeyboard
Set ".k="
For /F "Delims=" %%K In ('Xcopy /W "%~f0" "%~f0" 2^>Nul') Do (
	If Not Defined .k Set ".k=%%K" && Set ".k=!.k:~-1!"
)
Exit /b

:LoadWorld [%1 = File name]
Set "m="&&Set ".="&&Set "x="&&Set "y="
For /F "Tokens=1,2" %%A In ('Type "%~1"') Do (
	Set "a=%%A"&&Set "b=%%B"
	If Not Defined . (
		If /I "!a:~0,1!" NEQ "#" (
			Call :IsNumeric %%B
			If /I "%%A" EQU "width:"   If Defined . ( Set "m=!m!Width:   '!b!' is not a valid Number (Using default !sw!)!LF!" ) Else Set "m=!m!Width:   '!b!'!LF!"&&Set "sw=!b!"
			If /I "%%A" EQU "height:"  If Defined . ( Set "m=!m!Height:  '!b!' is not a valid Number (Using default !sw!)!LF!" ) Else Set "m=!m!Height:  '!b!'!LF!"&&Set "sh=!b!"
			If /I "%%A" EQU "health:"  If Defined . ( Set "m=!m!Health:  '!b!' is not a valid Number (Using default !ph!)!LF!" ) Else Set "m=!m!Health:  '!b!'!LF!"&&Set "ph=!b!"
			If /I "%%A" EQU "dimensionwidth:"  If Defined . ( Set "m=!m!DWidth:  '!b!' is not a valid Number (Using default !ww!)!LF!" ) Else Set "m=!m!DWidth:  '!b!'!LF!"&&Set "ww=!b!"
			If /I "%%A" EQU "dimensionheight:" If Defined . ( Set "m=!m!DHeight: '!b!' is not a valid Number (Using default !wh!)!LF!" ) Else Set "m=!m!DHeight: '!b!'!LF!"&&Set "wh=!b!"
			If /I "%%A" EQU "spawnx:"  If Defined . ( Set "m=!m!SpawnX:  '!b!' is not a valid Number (Using default !px!)!LF!" ) Else Set "m=!m!SpawnX:  '!b!'!LF!"&&Set "px=!b!"
			If /I "%%A" EQU "spawny:"  If Defined . ( Set "m=!m!SpawnY:  '!b!' is not a valid Number (Using default !py!)!LF!" ) Else Set "m=!m!SpawnY:  '!b!'!LF!"&&Set "py=!b!"
			If /I "%%A" EQU "spawnwx:" If Defined . ( Set "m=!m!Spawnwx: '!b!' is not a valid Number (Using default !wx!)!LF!" ) Else Set "m=!m!Spawnwx: '!b!'!LF!"&&Set "wx=!b!"
			If /I "%%A" EQU "spawnwy:" If Defined . ( Set "m=!m!Spawnwx: '!b!' is not a valid Number (Using default !wy!)!LF!" ) Else Set "m=!m!Spawnwy: '!b!'!LF!"&&Set "wy=!b!"
			If /I "%%A" EQU "player:"  If Not "!b:~1!" EQU "" ( Set "m=!m!Player:  '!b!' is not a valid Char (Using default !pl!)!LF!" ) Else Set "m=!m!Player:  '!b!'!LF!"&&Set "pl=!b!"
			If /I "%%A" EQU "blocks:"  Set "blocks= !b:~1,-1!"&&Set "m=!m!Blocks:  '!blocks!'!LF!"
			Set ".="
			If "!a!" EQU "END" (
				Set ".=1"
				Call :SetMapSize "!sw!" "!sh!"
				For /L %%Z In (1 1 !sw!) Do Set /p ".=."<nul
				Set /p ".=!m!"<nul&&Set "m="
				For /L %%Z In (1 1 !sw!) Do Set /p ".=."<nul
				Set /a "mx=!sw!*!sh!"
				Echo.Loading Worlds....!LF!
			)
		)
	) Else (
		If /I "%%A" EQU "map:" (
			If "!.!" EQU "2" (
				If !x! GTR !ww! ( Echo.Map outside world bounds^^! This Map will not be loaded^^! MAP[!y!,!x!] ) Else (
				If !y! GTR !wh! ( Echo.Map outside world bounds^^! This Map will not be loaded^^! MAP[!y!,!x!] ) Else (
					Set /p ".=Map: [!y!,!x!] / "<nul
					Call :Length "m"
					If "!length!" EQU "0" ( Set "m=!ew!" ) Else If !length! LSS !mx! (
						Call Set "m=%%m%%%%ew:~!length!%%"
						Set /p ".=To Small Map / Resizing from '!length!' to "<nul
					) Else If !length! GTR !mx! (
						Call Set "m=%%m:~0,!mx!%%"
						Set /p ".=To Big Map / Resizing from '!length!' to "<nul
					)
					Call :Length "m"
					Set /p ".='!length!' characters!LF!"<nul
					Call :SetDimension "!y!" "!x!" "m"
				))
			)
			Set "x=!b:~2,3!"
			Set "y=!b:~0,1!"
			Set "m="&&Set ".=2"
		) Else Set "m=!m!!a!"
	)
)
If Defined x (
	If !x! GTR !ww! ( Echo.Map outside world bounds^^! This Map will not be loaded^^! MAP[!y!,!x!] ) Else (
	If !y! GTR !wh! ( Echo.Map outside world bounds^^! This Map will not be loaded^^! MAP[!y!,!x!] ) Else (
		Set /p ".=Map: [!y!,!x!] / "<nul
		Call :Length "m"
		If "!length!" EQU "0" ( Set "m=!ew!" ) Else If !length! LSS !mx! (
			Call Set "m=%%m%%%%ew:~!length!%%"
			Set /p ".=To Small Map / Resizing from '!length!' to "<nul
		) Else If !length! GTR !mx! (
			Call Set "m=%%m:~0,!mx!%%"
			Set /p ".=To Big Map / Resizing from '!length!' to "<nul
		)
		Call :Length "m"
		Set /p ".='!length!' characters!LF!"<nul
		Call :SetDimension "!y!" "!x!" "m"
	))
	Echo.
)
For /L %%Y In (0 1 !wh!) Do For /L %%X In (0 1 !ww!) Do (
	Set /p ".=MAP[%%Y,%%X] / "<nul
	Call :GetDimension "%%Y" "%%X"
	Call :Length "wo"
	Set /p ".=!length!"<nul
	If "!length!" EQU "0" (
		Set "m=!ew!"
		Call :SetDimension "%%Y" "%%X" "m"
		Set /p ".=.!TAB! / Filled^!"<nul
	)
	Echo.
)
Set "x="&&Set "y="
Set "a="&&Set "b="
Set "m="&&Set ".="
Set "length="
Call :GetDimension "0" "0"
Set /a "mx=!mx!-1"
Set /a ".p0=(!py!-1)*!sw!+!px!-1"
Exit /b