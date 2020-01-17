debug 10
var mix.repeat 0
var current.lore ENCHANTING
if_1 var rawmat %1
if_2 put #var MC.order.noun %2
if_3 var enchant.repeat %3
var tool scribe
var fount.gone 0
var special NULL
var done 0
include mc_include.cmd

action var special meditate when The traced sigil pattern blurs before your eyes, making it difficult to follow
action var special focus when The .* struggles to accept the sigil scribing
action var special fount when You need another mana fount to continue crafting
action var special loop when You notice many of the scribed sigils are slowly merging back
action var tool restudy when You must first study instructions regarding the enchantment you wish to begin
action var tool scribe when more permanently with a burin|^You do not see anything that would prevent scribing additional sigils
action var tool sigil;var sigil $1 when ^You need another (?!primary)(\S+) .*sigil to continue the enchanting process
action var tool sigil when ^You need another primary sigil to continue the enchanting process
action var tool imbue when ^Then continue the process with the casting of an imbue spell|Once finished you sense an imbue spell will be required to continue enchanting.|^The.*?requires an application of an imbue spell to advance the enchanting process.
action var tool done when With the enchantment complete|With the enchanting process completed|With enchanting complete
action goto clean when It does not seem possible to continue with the enchanting process, and you will need to start over.
action put #tvar prepared 1 when ^You feel fully prepared
action instant var tool.repair $2 when This appears to be a crafting tool and .* (is|are|have|has) (.*)\.
action (work) off
var main.storage $MC_ENCHANTING.STORAGE

CleanBrazier:
     send analyze brazier
     pause 0.5
     pause 0.5
     pause 0.5
     if (("%tool.repair" = "in pristine condition") || ("%tool.repair" = "practically in mint condition")) then goto unfinished
CleanBrazier_1:
     gosub GET salt
     gosub PUT pour salt on brazier
     gosub STOW salt
		
unfinished:
	 var tool analyze
	 matchre braziercheck On the enchanter's brazier you see (.*?)\.
	 matchre start.enchant There is nothing on there
	 send look on brazier
	 matchwait 

braziercheck:
     var brazier $0
	if matchre("%brazier", "$MC.order.noun") then goto analyze1
     if matchre("%brazier", "unfinished .+ (\S+)\.") then goto clean
     if matchre("%brazier", "fount") then goto stow.fount
     goto start.enchant

clean:
     pause 0.5
     pause 0.5
     if ("$MC.order.noun" != "fount") then
          {
               gosub GET fount from brazier
               gosub PUT_IT fount in main storage
          }
     gosub GET "$MC.order.noun" from brazier
     gosub PUT_IT $MC.order.noun in bin
     pause 0.5
     goto unfinished
     
stow.fount:
	gosub GET fount
	gosub PUT_IT fount in %main.storage
	goto unfinished
	

start.enchant:
	put #tvar prepared 0
	if "$MC_IMBUE" = "SPELL" then gosub PREPARE imbue $MC_IMBUE.MANA
	if !matchre("$righthand|$lefthand", "%rawmat") then gosub GET my %rawmat from %main.storage
	gosub PUT_IT my %rawmat on brazier
	goto work
	
analyze1:
	gosub analyze
	goto work

work:
	pause 0.5
	if "%tool" = "done" then goto done
	gosub %tool
	goto work
	
restudy:
	if "$MC_IMBUE" = "SPELL" then put release spell
	gosub GET %rawmat from brazier
	gosub PUT_IT my %rawmat in %main.storage
	gosub GET my artif book
	gosub STUDY my artif book
	gosub PUT_IT my book in my %main.storage
	goto start.enchant
	
imbue:
	gosub specialcheck
	if "$MC_IMBUE" = "ROD" then
		{
		gosub GET imbue rod
		gosub Action wave rod at $MC.order.noun on braz
		}
	if ("$MC_IMBUE" = "SPELL") then 
		{
          if "$preparedspell" != "Imbue" then 
               {
               if "$preparedspell" != "None" then gosub release spell
               gosub prepare imbue $MC_IMBUE.MANA
               }
		if !$prepared then waitfor You feel fully prepared 
		gosub SPELL_CAST_TARGET $MC.order.noun on braz
          put #tvar prepared 0
		}
	if "$MC_IMBUE" = "ROD" then gosub PUT_IT my imbue rod in my %tool.storage
     var tool analyze
	goto work
	
sigil:
	gosub GET %sigil sigil from %main.storage
	gosub STUDY %sigil sigil
	gosub PUT trace $MC.order.noun on braz
	var tool scribe
	goto work
	
	
fount:
	gosub GET my fount
	send wave fount at $MC.order.noun on braz
	return
	
scribe:
	gosub ToolCheckRight $MC_BURIN
	gosub specialcheck
	pause 0.5
	if "%tool" != "scribe" then goto %tool
	gosub Action scribe $MC.order.noun on braz with my $MC_BURIN
	goto work
	
meditate:
	gosub Action meditate fount on braz
	var special NULL
	return
	
focus:
     if !def(MC_FOCUS.WAND) then put #var MC_FOCUS.WAND NULL
	if matchre("$MC_FOCUS.WAND", "WAND") then
		{
		gosub GET $MC_FOCUS.WAND
		gosub Action wave $MC_FOCUS.WAND at $MC.order.noun on braz
		gosub PUT_IT $MC_FOCUS.WAND in %tool.storage
		}
	else gosub Action focus $MC.order.noun on braz
	var special NULL
	return

loop:
	gosub ToolCheckLeft $MC_LOOP
	gosub Action push $MC.order.noun on brazier with my $MC_LOOP
	gosub STOW_LEFT
	var special NULL
	return

	
specialcheck:
	if "%special" != "NULL" then gosub %special
	var special NULL
	return


Retry:
	pause 1
	goto work
	
	
repeat:
	math enchant.repeat subtract 1
	gosub PUT_IT my $MC.order.noun in my %main.storage
	gosub GET my artif book
	gosub STUDY my book
	gosub PUT_IT my book in my %main.storage
	gosub GET my %rawmat
	var tool scribe
	goto start.enchant
	
	
done:
	gosub EMPTY_HANDS
	gosub GET $MC.order.noun
	if ("$MC.order.noun" != "fount") then
          {
               gosub GET fount
               gosub PUT_IT fount in my %main.storage
          }
	if %enchant.repeat > 1 then 
		{
               gosub PUT_IT $MC.order.noun in %main.storage 
               goto repeat
		}
	put #parse ENCHANTING DONE
	exit