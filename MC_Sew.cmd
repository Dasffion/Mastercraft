#debug 10
# Mastercraft by Dasffion
# Based on MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
# many versions later - Latest updates 02/26/2022
#
# Script Usage: .mc_sew <item>						--sews the item
#				.mc_sew <item> <no. of times>		--to sew more than one, assuming you have enough material
#
#   This script is used in conjunction with the mastercraft.cmd script, and is used to produce cloth and leather items. To use it, hold the
#	material to be used, study your instructions, then start the script. Be sure to have all the relevant tailoring tools in your outfitting bag,
#	as well as any parts to be assembled. If you have a Maker's Mark, be sure that it is also on you if your character profile in MC INCLUDE.cmd
#	is toggled to mark items.
#
#	If you are holding an unfinished item instead, this script will try to finish it for you.
#

var sew.repeat 0
var thread.gone 0
var pins.gone 0
var current.lore Outfitting
if !matchre("$scriptlist", "mastercraft") then var society.type Outfitting
include mc_include.cmd
if_2 var material %2
if_3 var sew.repeat %3
if_1 put #var MC.order.noun %1
var tool needle
var pins.gone 0
var assemble


action var tool yardstick when could benefit from some remeasuring.*|be benefited by remeasuring
action var tool scissors when Some scissor cuts must be made|now it is time to cut away more of the \S+ with scissors.*|appears ready for further cutting with some scissors.
action var tool pins when could use some pins to.*|is in need of pinning
action var tool slickstone when ^A deep crease develops along the fabric.*|The fabric develops wrinkles from.*|RUB
action var tool awl when needs holes punched.*|requires some holes punched
#action var tool assemble when ASSEMBLE Ingredient1 WITH Ingredient2
action var tool done when Applying the final touches, you complete working
action var excessloc $2 when You carefully cut off the excess material and set it (on the|in your|at your) (\S+).$
action var tool needle when ^measure my \S+ with my yardstick|^rub my \S+ with my slickstone|poke my \S+ with my pins|^poke my \S+ with my awl|^cut my \S+ with my scissors|pushing it with a needle and thread
#action GOTO unfinished when That tool does not seem suitable for that task.
action send get my $MC.order.noun when ^You must be holding the .* to do that\.
#action (work) goto Retry when \.\.\.wait|type ahead
action (work) off
action goto done when The .+ is far too damaged to be used for that\.
action (order) var thread.order $1 when (\d+)\)\..*yards of cotton thread.*(Lirums|Kronars|Dokoras)
action (order) var pins.order $1 when (\d+)\)\..*some straight iron pins.*(Lirums|Kronars|Dokoras)
action var pins.gone 1 when ^The pins is all used up, so you toss it away.
action var thread.gone 1 when ^The last of your thread is used up with the sewing.|^The needles need to have thread put on them
action (order) off

action var assemble $1 padding when another finished (small|large) cloth padding 
action var assemble $1 when another finished \S+ shield (handle)
action var assemble $1 $2 when another finished (long|short|small|large) leather (cord|backing)

unfinished:
	send glance
	waitforre ^You glance down (.*)\.$
	pause 1
	if contains("$0", "unfinished") then
	{
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if matchre("$lefthandnoun", "$MC.order.noun") then send swap
		pause 1
		goto work
	}

first.cut:
	if (contains("$righthandnoun", "cloth") || contains("$lefthandnoun", "cloth")) then var material cloth
	if (contains("$righthandnoun", "leather") || contains("$lefthandnoun", "leather")) then var material leather
	pause 1
	if !matchre("leather|cloth", "$righthandnoun") then send swap
	pause 1
	gosub ToolCheckLeft $MC_SCISSORS
	var tool needle
	matchre excess You carefully cut off the excess material and set it (on the|in your|at your) (\S+).$
	matchre work Roundtime: \d+
	send cut my %material with my $MC_SCISSORS
	matchwait

excess:
	pause 1
	if "$lefthand" != "Empty" then gosub STOW_LEFT
	gosub STOW feet
	gosub GET my %material
	gosub PUT_IT %material in my $MC_OUTFITTING.STORAGE

work:
	action (work) on
	save %tool
	if "%tool" = "done" then goto done
	gosub %tool
	goto work
     
needle:
	if "%assemble" != "" then gosub assemble
     if %thread.gone = 1 then gosub new.tool
     gosub ToolCheckLeft $MC_NEEDLES
     if matchre("$righthand", "$MC_NEEDLES") then gosub SWAP
     if !matchre("$righthand", "$MC.order.noun") then gosub STOW_RIGHT
     if "$righthand" = "Empty" then gosub GET my $MC.order.noun
	gosub Action push my $MC.order.noun with my $MC_NEEDLES
	return

yardstick:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_YARDSTICK
	var tool needle
     if matchre("$righthand", "$MC_YARDSTICK") then gosub SWAP
     if !matchre("$righthand", "$MC.order.noun") then gosub STOW_RIGHT
     if "$righthand" = "Empty" then gosub GET my $MC.order.noun
	gosub Action measure my $MC.order.noun with my $MC_YARDSTICK
	return

slickstone:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_SLICKSTONE
	var tool needle
     if matchre("$righthand", "$MC_SLICKSTONE") then gosub SWAP
     if !matchre("$righthand", "$MC.order.noun") then gosub STOW_RIGHT
     if "$righthand" = "Empty" then gosub GET my $MC.order.noun
	gosub Action rub my $MC.order.noun with my $MC_SLICKSTONE
	return

pins:
	if "%assemble" != "" then gosub assemble
	if %pins.gone = 1 then gosub new.tool
	if !contains("$lefthandnoun", "pins") then
	{
	if "$lefthand" != "Empty" then gosub STOW_LEFT
		gosub GET my pins
		if !matchre("$righthand|$lefthand", "pins") then gosub GET my pins from my portal
	}
	var tool needle
     if matchre("$righthand", "pins") then gosub SWAP
     if !matchre("$righthand", "$MC.order.noun") then gosub STOW_RIGHT
     if "$righthand" = "Empty" then gosub GET my $MC.order.noun
	gosub Action poke my $MC.order.noun with my pins
	return
	
scissors:
	if "%assemble" != "" then gosub assemble
     if "$lefthand" != "Empty" then gosub STOW_LEFT
	gosub ToolCheckLeft $MC_SCISSORS
	var tool needle
     if matchre("$righthand", "$MC_SCISSORS") then gosub SWAP
     if !matchre("$righthand", "$MC.order.noun") then gosub STOW_RIGHT
     if "$righthand" = "Empty" then gosub GET my $MC.order.noun
	gosub Action cut my $MC.order.noun with my $MC_SCISSORS
	return

awl:
	if "%assemble" != "" then gosub assemble
	gosub ToolCheckLeft $MC_AWL
	var tool needle
     if matchre("$righthand", "$MC_AWL") then gosub SWAP
     if !matchre("$righthand", "$MC.order.noun") then gosub STOW_RIGHT
     if "$righthand" = "Empty" then gosub GET my $MC.order.noun
	gosub Action poke my $MC.order.noun with my $MC_AWL
	return
	
assemble:
	if "$lefthandnoun" != "%assemble" then
	{
		pause 1
	if "$lefthand" != "Empty" then gosub STOW_LEFT
		gosub GET my %assemble
		if !matchre("$righthand|$lefthand","%assemble") then gosub GET my %assemble from my portal
	}
	send assemble my $MC.order.noun with my %assemble
	pause 1
	var assemble 
	#send analyze my $MC.order.noun
	return

new.tool:
if contains("$scriptlist", "mastercraft") then
	{
	action (work) off
	var temp.room $roomid
	gosub check.location
	if matchre("$righthand|$lefthand", "$MC.order.noun") then send put my $MC.order.noun in my $MC_OUTFITTING.STORAGE
	if %pins.gone = 1 then
	{
		gosub automove outfitting tool
		action (order) on
		gosub ORDER
		action (order) off
		gosub ORDER %pins.order
		gosub PUT_IT my pins in my $MC_OUTFITTING.STORAGE
		pause .5
		var pins.gone 0
	}
	if %thread.gone = 1 then
	{
		gosub automove outfitting suppl
		action (order) on
		pause 1
		gosub ORDER
		action (order) off
		gosub ORDER %thread.order
		pause 1
		send put my thread on my needles;-0.5 put my thread on my needles in my port
		waitforre ^You carefully thread
		var thread.gone 0
	}
	if %pins.gone = 1 || %thread.gone = 1 then goto new.tool
	gosub automove %temp.room
	if !matchre("$righthand|$lefthand", "$MC.order.noun") then gosub GET my $MC.order.noun from my $MC_OUTFITTING.STORAGE
	pause 0.5
	unvar temp.room
	action (work) on
	return
	}
else
{
echo *** Out of pins or thread! Go get more!
put #parse SEWING DONE
exit
} 

lack.coin:
	if "%get.coin" = "off" then goto lack.coin.exit
	action (withdrawl) goto lack.coin.exit when (^The clerk flips through her ledger|^The clerk tells you)
	gosub automove teller
	send withd 5 gold
	waitforre The clerk counts|You count out
	gosub automove %temp.room
	var need.coin 0
	action remove (^The clerk flips through her ledger|^The clerk tells you)
	pause 1
	return

lack.coin.exit:
	echo You need some startup coin to purchase stuff! Go to the bank and try again!
	put #parse Need coin
	exit



return:
return

Retry:
	pause 1
	goto work
	
repeat:
	math sew.repeat subtract 1
	gosub PUT_IT my $MC.order.noun in my $MC_OUTFITTING.STORAGE
     if "%repair" = "on" then gosub check.tools
	gosub GET my tailor book
	if !matchre("$lefthand|$righthand", "book") then gosub GET my tailor book from my portal
	gosub Study my book
	gosub PUT_IT my book in my $MC_OUTFITTING.STORAGE
	gosub GET my %material
	if !matchre("$lefthand|$righthand", "%material") then gosub GET my %material from my portal
	var tool needle
	goto first.cut


done:
	if %pins.gone = 1 then gosub new.tool
	if %thread.gone = 1 then gosub new.tool
	if "$lefthand" != "Empty" then gosub STOW_LEFT
	gosub mark
	pause 1
	if %sew.repeat > 1 then goto repeat
	put #parse SEWING DONE
	exit
