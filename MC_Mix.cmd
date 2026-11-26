#debug 10
# v 1.9.8
## STANDALONE SCRIPT RUN EXAMPLE:
## .MC_Mix unguent 10 jadice coal - Makes 10 Jadice Unguents
## .MC_Mix <order noun> <count to make> <herb> <catalyst>
## Make sure to stock up water/alcohol/coal/herbs
## SET YOUR BOOK TO CORRECT RECIPE AND STUDY BEFORE RUNNING
var mix.repeat 0
var current.lore ALCHEMY
if_3 var herb1 %3
if_4 var herb2 %4
if_2 var mix.repeat %2
if_1 put #var MC.order.noun %1
var tool mix
var alcohol.gone 0
var water.gone 0
var catalyst.gone 0
var need.repair 0
var special NULL
include mc_include.cmd
action var tool mix when appears free of defects that would
action var tool mix when You do not see anything that would prevent
action var tool mix when composition looks accurate
action var tool mix when ^You realize the(.*) is not required to continue
action var tool mix when ^That tool does not seem
action var tool turn when Clumps of material stick to the sides
action var tool turn when ^Once finished you notice clumps of material
action var tool smell when As you finish, the mixture begins to transition colors
action var tool smell when takes on an odd hue
action var tool sieve when ^Upon completion you see (?:some )?particulate clouding up the mixture
action var tool sieve when ^A thick froth coats
action var water.gone 1 when ^But there are no liquids
action var special water when ^You need another splash of water to continue crafting
action var special alcohol when  ^You need another splash of alcohol to continue crafting
action var special catalyst when ^You need another catalyst material to
action var special add.herb when You need another prepared herb to
action var tool done when ^Applying the final touches, you complete working
action (order) var water.order $1 when (\d+)\)\..*10 splashes of water.*(Lirums|Kronars|Dokoras)
action (order) var alcohol.order $1 when (\d+)\)\..*10 splashes of grain alcohol.*(Lirums|Kronars|Dokoras)
action (order) var catalyst.order $1 when (\d+)\)\..*a massive coal nugget.*(Lirums|Kronars|Dokoras)
#action (work) goto Retry when \.\.\.wait|type ahead
action (work) off
var main.storage $MC_ALCHEMY.STORAGE
var liquid tonic|wash|potion|elixir|draught
var solid cream|salve|balm|poultices|unguent|ungent|ointment

put #var MC_WORK.TOOLS $MC_BOWL|$MC_MORTAR|$MC_PESTLE|$MC_STICK|$MC_SIEVE
if matchre("%herb1", "(blue flower|blue.flower|red flower|red.flower)") then var herb1 flower
if matchre("%herb2", "(blue flower|blue.flower|red flower|red.flower)") then var herb2 flower
if (matchre("$MC_KERTIGEN.HALO", "(?i)ON") && (%HaloRemoved = 0)) then gosub HALO_REMOVE

if matchre("$MC.order.noun", "%liquid") then
		{
          echo
          echo * LIQUID - Using Stick/Bowl
          echo
		var mixer $MC_STICK
		var bowl $MC_BOWL
		var tool.mix mix
		var water alcohol
		}
if matchre("$MC.order.noun", "%solid") then
		{
          echo
          echo * SOLID - Using Mortar/Pestle
		echo
          var mixer $MC_PESTLE
		var bowl $MC_MORTAR
		var tool.mix crush
		var water water
		}
unfinished:
	if !matchre("$righthand|$lefthand", "book") then gosub GET %discipline book
     if !matchre("$righthand|$lefthand", "book") then gosub GET crafting book
     gosub STUDY book
	gosub ToolCheckRight %bowl
	if matchre("%bowl", "$lefthand") then gosub PUT swap
	send look in my %bowl
	waitforre (^In the (.*)\.$|^I could not find|^There is nothing in there)
	pause 1
	if contains("$0", "unfinished") then
	{
		send analyze my $MC.order.noun
		waitforre ^You.*analyze
		if !matchre("%bowl", "$righthand") then gosub PUT swap
		pause 1
		goto work
	}
	if !matchre("$0", "There is nothing in there") then
		{
		put tilt %bowl
		put tilt %bowl
		pause 2
		}

first.mix:
	gosub ToolCheckRight %bowl
	if matchre("%bowl", "$lefthand") then gosub PUT swap
	if ("$lefthand" != "Empty") then gosub STOW_LEFT
	gosub GET my %herb1 from my %main.storage
	if !matchre("$righthand|$lefthand", "%herb1") then
		{
			gosub restock.herb %herb1
			gosub ToolCheckLeft %herb1
			if !matchre("$righthand|$lefthand", "%herb1") then
				{
					echo *** Something went wrong!!
					echo *** Still missing %herb1 after restock!!
					echo *** Restock manually 
					exit
				}
		}

	gosub PUT_IT my %herb1 in my %bowl
	pause 0.5
	if ("$lefthand" != "Empty") then gosub STOW_LEFT
	pause 0.5
	gosub GET my %mixer from my %main.storage
	if !matchre("$lefthand|$righthand", "%mixer") then gosub GET my %mixer
	pause 0.5
	if "%tool.mix" = "crush" then gosub Action %tool.mix %herb1 in my %bowl with my %mixer
	else gosub Action %tool.mix my %bowl with my %mixer
	pause 5
	goto work


work:
	action (work) on
	save %tool
	if "%tool" = "done" then goto done
     if (%need.repair = 1) then goto too.damaged
	gosub %tool
     if (%need.repair = 1) then goto too.damaged
	goto work


mix:
	gosub specialcheck
	gosub ToolCheckLeft %mixer
	if ("%tool.mix" = "crush") then gosub Action %tool.mix $MC.order.noun in my %bowl with my %mixer
	else gosub Action %tool.mix my %bowl with my %mixer
     if (%need.repair = 1) then goto too.damaged
	return


sieve:
	gosub specialcheck
	gosub ToolCheckLeft $MC_SIEVE
	var tool mix
	gosub Action push my $MC.order.noun with my $MC_SIEVE
	return

smell:
	gosub specialcheck
	var tool mix
	gosub Action smell my $MC.order.noun
	return

turn:
	gosub specialcheck
	var tool mix
	gosub Action turn my %bowl
	return

water:
	if (%water.gone = 1) then gosub tool.swap
	if !matchre("$lefthand", "water") then
		{
			if ("$lefthand" != "Empty") then gosub STOW_LEFT
			gosub GET my water from my %main.storage
		}
	var tool mix
	send pour part water in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "water") then var water.gone 1
     if (%need.repair = 1) then goto too.damaged
	return

alcohol:
	if (%alcohol.gone = 1) then gosub tool.swap
	if !matchre("$lefthand", "alcohol") then
		{
			if ("$lefthand" != "Empty") then gosub STOW_LEFT
			gosub GET my alcohol from my %main.storage
		}
	var tool mix
	send pour part alcohol in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "alcohol") then var alcohol.gone 1
     if (%need.repair = 1) then goto too.damaged
	return

catalyst:
	if (%catalyst.gone = 1) then gosub tool.swap
	if !contains("$lefthandnoun", "nugget") then
	{
		if "$lefthand" != "Empty" then gosub STOW_LEFT
		gosub GET my coal nugget in my %main.storage
	}
	var tool mix
	send put nugget in my %bowl
	pause 0.5
	if !contains("$lefthandnoun", "nugget") then var catalyst.gone 1
	return

add.herb:
	if !matchre("$lefthand", "%bowl") then gosub STOW_LEFT
	if !matchre("$righthand", "%bowl") then gosub STOW_RIGHT
	gosub GET my %herb2 from my %main.storage
	if !matchre("$righthand|$lefthand", "%herb2") then
		{
			gosub restock.herb %herb2
			gosub GET my %herb2 from my %main.storage
			if !matchre("$righthand|$lefthand", "%herb2") then
				{
					echo *** Still missing %herb2 after restock!!
					exit
				}
		}
	put put my %herb2 in my %bowl
	pause 0.5
	var special NULL
	return

specialcheck:
	if "%special" != "NULL" then gosub %special
	var special NULL
	return

tool.swap:
if contains("$scriptlist", "mastercraft") then
	{
	action (work) off
	var temp.room $roomid
     if ((%water.gone = 1) || (%alcohol.gone = 1) || (%catalyst.gone = 1)) then
          {
               if matchre("$righthand", "%bowl") then gosub PUT_IT #$righthandid in my %tool.storage
               if matchre("$lefthand", "%bowl") then gosub PUT_IT #$lefthandid in my %tool.storage
          }
	if (%water.gone = 1) then
	{
		if (("$righthand" != "Empty") || ("$lefthand" != "Empty")) then send put my %bowl in my %tool.storage
		gosub summonwater
		if (("$righthandnoun" != "%bowl") && ("$lefthandnoun" != "%bowl")) then send get my %bowl from my %tool.storage
		pause .5
		var water.gone 0
	}
	if (%alcohol.gone = 1) then
	{
		if (("$righthand" != "Empty") || ("$lefthand" != "Empty")) then send put my %bowl in my %tool.storage
		gosub summonalcohol
		if (("$righthandnoun" != "%bowl") && ("$lefthandnoun" != "%bowl")) then send get my %bowl from my %tool.storage
		var alcohol.gone 0
	}
	if (%catalyst.gone = 1) then
	{
		gosub automove Forging suppl
		if (("$righthand" != "Empty") || ("$lefthand" != "Empty")) then send put my %bowl in my %tool.storage
		action (order) on
		send order
		pause 2
		pause 0.5
		gosub ORDER
		action (order) off
		gosub ORDER %catalyst.order
		gosub PUT_IT my nugget in my %main.storage
		if (("$righthandnoun" != "%bowl") && ("$lefthandnoun" != "%bowl")) then send get my %bowl from my %tool.storage
		var catalyst.gone 0
	}
	gosub automove %temp.room
	pause 0.5
	unvar temp.room
	action (work) on
	return
	}
else
	{
	echo
	echo *** Out of Water or Alcohol! Go get more!
	echo
	if ("%repair" = "on") then gosub check.tools
	put #parse MIX DONE
	put #parse ALCHEMY DONE
	exit
	}

restock.herb:
     var restock.target $0
     if !matchre("$scriptlist", "(?i)mastercraft") then
          {
			echo
			echo *** DETECTED MASTERCRAFT IS NOT RUNNING!
               echo *** Missing %restock.target — cannot continue!
               echo *** RESTOCK HERBS MANUALLY!
			echo
               exit
          }
     action (work) off
     var temp.room $roomid
     if matchre("$righthand", "%bowl") then gosub PUT_IT #$righthandid in my %tool.storage
     if matchre("$lefthand", "%bowl") then gosub PUT_IT #$lefthandid in my %tool.storage
     gosub EMPTY_HANDS
     var order.type %restock.target
     if (("%restock.target" = "flower") && def(MC.herb1)) then var order.type $MC.herb1
     var %order.type.material.volume 0
     if def(MC.order.qty) then var order.quantity $MC.order.qty
     else var order.quantity 1
     if (%order.quantity < 1) then var order.quantity 1
     if def(MC.order.vol) then var volume $MC.order.vol
     else var volume 5
     evalmath mass.volume (%volume * %order.quantity * 5)
     var saved.herb2 %herb2
     if (def(MC.herb2) && ("%order.type" = "$MC.herb2")) then var herb2 $MC.herb2
     else var herb2 NULL
     gosub lack.material
     var herb2 %saved.herb2
     unvar saved.herb2
     gosub automove %temp.room
     unvar temp.room
     gosub ToolCheckRight %bowl
     if matchre("%bowl", "$lefthand") then gosub PUT swap
     action (work) on
     return

return:
return

Retry:
	pause 1
	goto work


repeat:
	math mix.repeat subtract 1
	gosub PUT_IT my $MC.order.noun in my %main.storage
	if ("%repair" = "on") then gosub check.tools
     gosub GET my remedy book from my %main.storage
	if !matchre("$righthand|$lefthand", "book") then gosub GET my remedy book
     if !matchre("$righthand|$lefthand", "book") then gosub GET crafting book
	gosub STUDY my book
	gosub PUT_IT my book in my %main.storage
	gosub GET my %material from my %main.storage
	if !matchre("$righthand|$lefthand", "%material") then gosub GET my %material
	var tool mix
	goto first.mix

too.damaged:
     echo ** TOOL is too damaged to continue! need repairs!
done:
	if (%water.gone = 1) then gosub tool.swap
	if (%catalyst.gone = 1) then gosub tool.swap
	if (%alcohol.gone = 1) then gosub tool.swap
	if ("$lefthand" != "Empty") then gosub STOW_LEFT
	gosub GET my $MC.order.noun from my %bowl
	if ("$righthand" != "Empty") then gosub STOW_RIGHT
	gosub countcheck
	if ((%mix.repeat > 1) && (%need.repair = 0)) then
		{
		gosub PUT_IT $MC.order.noun in %main.storage
		goto repeat
		}
     if ("%repair" = "on") then gosub check.tools
	# if ("$righthand" != "Empty") then gosub STOW_RIGHT
	# if ("$lefthand" != "Empty") then gosub STOW_LEFT
	# if matchre("$MC_KERTIGEN.HALO", "(?i)ON") then gosub HALO_RESTACK
	put #parse ALCHEMY DONE
	exit

countcheck:
if ($MC_Alchemy_NOWO = 1) then return
action var temprem $1 when ^You count out (\d+) uses remaining\.
gosub PUT count my $MC.order.noun
pause 0.1
if (%temprem > 5) then
	{
	gosub PUT mark my $MC.order.noun at 5
	gosub PUT break my $MC.order.noun
	gosub STOW_LEFT
	gosub PUT swap
	}
return
