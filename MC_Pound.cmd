#debug 10
#MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
#v 0.1.6
#
# Script Usage: .pound <item>					--forges the item
#				.pound <item> <no. of times>	--to forge more than one, assuming you have enough material
#
#   This script is used in conjunction with the mastercraft.cmd script, and is used to produce metal items on an anvil. To use it, place the
#	material to be used on the anvil, study your instructions, then start the script. Be sure to have all the relevant forging tools in your
#	forging bag, as well as any parts to be assembled. If you have a Maker's Mark, be sure that it is also on you if your character profile
#	in MC INCLUDE.cmd is toggled to mark items.
#
#	If you place an unfinished item on the anvil, this script will try to finish it for you.
#
var pound.repeat 0
if_2 var pound.repeat %2
if_1 put #var MC.order.noun %1
var small.ingot 0
var item.anvil 0
include mc_include.cmd
var swap.tongs 0
var worn.tongs 0
var tongs.adj 0

action var worn.tongs 1 when ^You tap some.*(segmented|articulated).*tongs that you are wearing\.$
action var tongs.adj 0 when ^With a yank you fold the shovel
action var tongs.adj 1 when ^You lock the tongs into a fully extended position
action put #parse @%tool;var tool bellows when and produces less heat from the stifled coals\.|is unable to consume its fuel\.|PUSH a BELLOWs
action put #parse @%tool;var tool tongs when would benefit from some soft reworking\.|could use some straightening along the horn of the anvil\.|drawn into wire on a mandrel|^The .+ now looks ready to be turned into wire using a mandrel or mold set\.|TURN it with the tongs to perform these tasks\.$|^The metal must be transfered to plate molds and drawn into wire on a mandrel sets using tongs\.|TURN it with the tongs
action put #parse @%tool;var tool shovel when dies down and appears to need some more fuel|^The fire needs more fuel before you can do that\.|^As you complete working the fire dies down and needs more fuel|PUSH FUEL with a SHOVEL
action put #parse @%tool;var tool tub when ready for a quench hardening in the slack tub\.|^The metal now appears ready for cooling in the slack tub\.|^ You can PUSH the TUB to reposition it and quench the hot metal\.|PUSH the TUB
action put #parse @%tool;var tool oil when some oil to preserve and protect it.$|POUR OIL on .* to complete the forging process\.$
action var tool analyze when ^Applying the final touches |^That tool does not seem suitable for that task\.
action put #parse @%tool;var tool hammer when push my bellows|turn .* with my tongs|push fuel with my shovel|push fuel with my tongs|pull .* with my pliers$|push tub|looks ready to be pounded with a forging hammer.|You do not see anything that would obstruct pounding of the metal with a forging hammer
action put #parse @%tool;var tool rehammer when ^The .* appears ready for pounding
action put #parse @%tool;var tool pliers when (with the|using) pliers to (stitch|pull|rivet) them together\.$|appear ready for bending using a pair of pliers\.|are now ready for (stitching|riveting) together using pliers\.$|Just pull the .* with the pliers|(bending|weaving) of .* into and around it\.|The links appear ready to be woven into and around
action put #parse @%tool;var tool assemble when ^\[Ingredients can
action var excessloc $2 when and so you split the ingot and leave the portion you won't be using (on the|in your|at your) (\S+).$
action var tool done when ^Applying the final touches, you complete|TURN the GRINDSTONE several times|This appears to be a type of finished|^The workmanship
action put #parse TURN the GRINDSTONE several times when ^The .* now appears ready for grinding and polishing on a grinding wheel\.
action var item.anvil 1 when ^On the iron anvil you see
action var last.tool $1 when ^@(\S+)
#action (work) goto Retry when \.\.\.wait|type ahead
action (work) off


action var assemble $1 when another finished \S+ shield (handle)
action var assemble $1 when another finished wooden (hilt|haft)
action var assemble $1 $2 when another finished (long|short|small|large) leather (cord|backing)
action var assemble $1 $2 when another finished (small|large) cloth (padding)
action var assemble $1 $2 when another finished (long|short) wooden (pole)
send tap my tongs
if "$MC_SHOVEL" = "$MC_TONGS" then var swap.tongs 1
if %swap.tongs = 1 then
	{
	 var shovel $MC_TONGS
	 send analyze my $MC_TONGS
	 waitforre ^(These tongs are used|This tool is used to shovel)
	 if "$1" = "This tool is used to shovel" then var tongs.adj 1
	 else var tongs.adj 0
	}
else var shovel $MC_SHOVEL
action (tongs) off
pause .5

unfinished:
	 var tool analyze
	 gosub poundcheck
	if %swap.tongs = 1 then
          {
          if %tongs.adj = 1 then send adjust my $MC_TONGS
          }
      pause 0.5
      pause 0.5
	 matchre work $MC.order.noun
	 matchre clean unfinished .+ (\S+)\.
	 matchre first.pound (a|an) .+ ingot
	 send look on anvil
	 matchwait 

first.pound:
	 var small.ingot 0
	 var tool hammer
	 gosub poundcheck
	if %swap.tongs = 1 then
          {
          if %tongs.adj = 1 then send adjust my $MC_TONGS
          }
	 matchre ingot.grab ^You realize the .+ will not require as much metal as you have
	 matchre small.ingot ^You need a larger volume
	 matchre work ^Roundtime
	 send pound ingot on anvil with my $MC_HAMMER
	matchwait

small.ingot:
	var small.ingot 1

ingot.grab:
	 pause 1
	 gosub PUT_IT my $MC_HAMMER in my %tool.storage
	if "%excessloc" != "feet" then gosub GET ingot from my %excessloc
	if "%excessloc" = "feet" then gosub STOW feet
	if %small.ingot = 1 then
	{
		if %worn.tongs = 1 then GOSUB WEAR my $MC_TONGS
		else gosub PUT_IT my $MC_TONGS in my %tool.storage
		put #parse SMALL INGOT
		exit
	}		
	 gosub PUT_IT my ingot in my %forging.storage
	 gosub GET my $MC_HAMMER from my %tool.storage


work:
	pause 1
	action (work) on
	 save %tool
	 if "%tool" = "analyze" then gosub analyze
	 if "%tool" = "done" then goto done
      if "%got.analyze" = "NO" then gosub Retool
	 gosub %tool
	goto work

Retool:
     if "%last.tool" = "hammer" then
          {
          var tool bellows
          return
          }
     if "%last.tool" = "bellows" then
          {
          var tool shovel
          return
          }
     if "%last.tool" = "shovel" then
          {
          var tool tongs
          return
          }
     if "%last.tool" = "tongs" then
          {
          var tool pliers
          return
          }
     if "%last.tool" = "pliers" then
          {
          var tool assemble
          return
          }
      if "%last.tool" = "assemble" then
          {
          var tool tub
          return
          }
     if "%last.tool" = "tub" then
          {
          var tool oil
          return
          }
     put #echo Hell, I don't know.
     exit
   


hammer:
	gosub poundcheck
	if %swap.tongs = 1 then
          {
          if %tongs.adj = 1 then send adjust my $MC_TONGS
          }
	 pause .5
	 gosub Action pound $MC.order.noun on anvil with my $MC_HAMMER
	 return

poundcheck:
	pause 1
	gosub ToolCheckRight $MC_HAMMER
	gosub ToolCheckLeft $MC_TONGS
	return

shovel:
	pause 1
	if %swap.tongs = 1 then
	{
		gosub ToolCheckLeft $MC_TONGS
		if %tongs.adj = 0 then send adjust my $MC_TONGS
	}
	else gosub ToolCheckRight $MC_SHOVEL
	var tool hammer
	 gosub Action push fuel with my %shovel
	return

bellows:
	gosub ToolCheckRight $MC_BELLOWS
	var tool hammer
	 gosub Action push my $MC_BELLOWS
	return

tongs:
	 gosub poundcheck
	 if %swap.tongs = 1 then
          {
		if %tongs.adj = 1 then send adjust my $MC_TONGS
          }
	 pause .5
	 var tool hammer
	 gosub Action turn $MC.order.noun on anvil with my $MC_TONGS
	return

tub:
	 gosub Action push tub
	return

pliers:
	var item.anvil 0
	gosub ToolCheckRight $MC_PLIERS
	send look on anvil
	pause 1
	if ("$lefthand" != "Empty" && %item.anvil = 1) then
		{
		if (!matchre("$MC_TONGS", "$lefthandnoun") && %worn.tongs = 1) then send wear my $MC_TONGS
		else gosub STOW_LEFT
		gosub GET $MC.order.noun from anvil
		var item.anvil 0
		}
		var tool hammer
	gosub Action pull my $MC.order.noun with my $MC_PLIERS
	pause 1
	return

oil:
	if !contains("$righthandnoun", "flask of oil") then
	{
	 	if "$rightthand" != "Empty" then gosub STOW_RIGHT
	 gosub GET my oil from my %forging.storage
	}
	send look on anvil
	pause 1
	if "$lefthand" != "Empty" && %item.anvil = 1 then
	{
	 if (!matchre("$MC_TONGS", "$lefthandnoun") && %worn.tongs = 1) then send wear my $MC_TONGS
	 else gosub STOW_LEFT
	 gosub GET $MC.order.noun from anvil
	 var item.anvil 0
	}
	if !contains("$lefthandnoun", "$MC.order.noun") then
	{
	 if (!matchre("$MC_TONGS", "$lefthandnoun") && %worn.tongs = 1) then send wear my $MC_TONGS
	 else gosub STOW_LEFT
	 gosub GET my $MC.order.noun from my %forging.storage
	}
	 gosub Action pour oil on my $MC.order.noun
	 gosub PUT_IT my oil in my %forging.storage
	 gosub mark
	return

rehammer:
	 gosub PUT_IT my $MC.order.noun on anvil
	 var tool hammer
	return

assemble:
	if !contains("$righthandnoun", "%assemble") then
	{
		if "$rightthand" != "Empty" then gosub STOW_RIGHT
	 gosub GET my %assemble from my %forging.storage
	}
	send look on anvil
	pause 1
	if "$lefthand" != "Empty" && %item.anvil = 1 then
	{
	 if (!matchre("$MC_TONGS", "$lefthandnoun") && %worn.tongs = 1) then send wear my $MC_TONGS
	 else gosub STOW_LEFT
	 gosub GET $MC.order.noun from anvil
	 var item.anvil 0
	}
	if !matchre("$lefthandnoun", "$MC.order.noun") then
	{
	 if (!matchre("$MC_TONGS", "$lefthandnoun") && %worn.tongs = 1) then send wear my $MC_TONGS
	 else gosub STOW_LEFT
	 gosub GET my $MC.order.noun
	 if !matchre ("$righthand|$lefthand", "$MC.order.noun") then gosub GET my $MC.order.noun from my portal
	}
	 send assemble my $MC.order.noun with my %assemble
	 pause 1
	 var tool analyze
	return

Retry:
	pause 1
	var tool %s
	goto work
	
repeat:
	 math pound.repeat subtract 1
	 gosub PUT_IT my $MC.order.noun in my %forging.storage
      if "%repair" = "on" then gosub check.tools
	 gosub GET my book
	 if !matchre ("$righthand|$lefthand", "book") then gosub GET my book from my portal
	 gosub STUDY my book
	 gosub GET my ingot
	 if !matchre ("$righthand|$lefthand", "ingot") then gosub GET my ingot from my portal
	 gosub PUT_IT ingot on anvil
	goto first.pound

done:
	pause .5
	send look on anvil
	pause 2
	if ("$righthand" != "Empty" && !contains("$righthandnoun", "$MC.order.noun")) then gosub STOW_RIGHT
	if ("$lefthand" != "Empty"  && !contains("$lefthandnoun", "$MC.order.noun")) then
	{
	 if (!matchre("$MC_TONGS", "$lefthandnoun") && %worn.tongs = 1) then send wear my $MC_TONGS
	 else gosub STOW_LEFT
	}
	pause 1
	if %item.anvil = 1 then gosub GET $MC.order.noun from anvil
	var item.anvil 0
	 pause 1
	 if %pound.repeat > 1 then goto repeat
	 put #parse POUNDING DONE
	exit
