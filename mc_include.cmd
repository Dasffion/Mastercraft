#Setup Your variables in the MC_SETUP file
#
# Happy Crafting!
gosub location.vars
gosub check.location

eval forging.storage tolower($MC_FORGING.STORAGE)
eval outfitting.storage tolower($MC_OUTFITTING.STORAGE)
eval engineering.storage tolower($MC_ENGINEERING.STORAGE)
eval alchemy.storage tolower($MC_ALCHEMY.STORAGE)
eval remnant.storage tolower($MC_REMNANT.STORAGE)
eval enchanting.storage tolower($MC_ENCHANTING.STORAGE)
eval tool.storage tolower($MC_TOOL.STORAGE_%society.type)
eval tiedtools tolower("$MC_TIED.TOOLS")
eval tiedtools replacere("%tiedtools", "\|+", "|")
eval tiedtools replacere("%tiedtools", "^\|", "")
eval tiedtools replacere("%tiedtools", "\|$", "")
eval clerktools tolower("$MC_CLERK.TOOLS")
eval clerktools replacere("%clerktools", "\|+", "|")
eval clerktools replacere("%clerktools", "^\|", "")
eval clerktools replacere("%clerktools", "\|$", "")
eval repair tolower($MC_REPAIR)
eval auto.repair tolower($MC_AUTO.REPAIR)
eval get.coin tolower($MC_GET.COIN)
eval reorder tolower($MC_REORDER)
var alltools $MC_HAMMER|$MC_SHOVEL|$MC_TONGS|$MC_PLIERS|$MC_BELLOWS|$MC_STIRROD|$MC_CHISEL|$MC_SAW|$MC_RASP|$MC_RIFFLER|$MC_TINKERTOOL|$MC_CARVINGKNIFE|$MC_SHAPER|$MC_DRAWKNIFE|$MC_CLAMP|$MC_NEEDLES|$MC_SCISSORS|$MC_SLICKSTONE|$MC_YARDSTICK|$MC_AWL|$MC_BOWL|$MC_MORTAR|$MC_STICK|$MC_PESTLE|$MC_SIEVE|$MC_BURIN|$MC_LOOP|$MC_BRAZIER
eval alltools tolower("%alltools")
eval alltools replacere("%alltools", "\|+", "|")
eval alltools replacere("%alltools", "^\|", "")
eval alltools replacere("%alltools", "\|$", "")
var LastHalo NULL
#var alltools saw|chisel|carving knife|rasp|riffler|clamp|needles|drawknife|slickstone|hammer|tongs|bellows|pliers|shovel|bowl|mixing stick|pestle|mortar|sieve|loop|burin|yardstick|tools|awl|rod
#put #unvar repair.room
put #trigger {completely understand all facets of the design\.$} {#var MC_DIFFICULTY 6}
put #trigger {comprehend all but several minor details in the text\.$} {#var MC_DIFFICULTY 5}
put #trigger {confidently discern most of the design's minutiae\.$} {#var MC_DIFFICULTY 4}
put #trigger {interpret many of the design's finer points\.$} {#var MC_DIFFICULTY 3}
put #trigger {absorb a handful of the design's finer point\.$} {#var MC_DIFFICULTY 2}
put #trigger {fail to grasp all but the simplest diagrams on the page\.$} {#var MC_DIFFICULTY 1}
put #trigger {quickly realize the design is far beyond your abilities\.$} {#var MC_DIFFICULTY 0}
#### Finding Ordering Numbers
action (order) put #tvar handle.order $1 when (\d+)\)\.\s+a (\S+) shield handle.*(Lirums|Kronars|Dokoras)
action (order) put #tvar l.cord.order $1 when (\d+)\)\.\s+a long leather cord.*(Lirums|Kronars|Dokoras)
action (order) put #tvar l.padding.order $1 when (\d+)\)\..*some large cloth padding.*(Lirums|Kronars|Dokoras)
action (order) put #tvar s.padding.order $1 when (\d+)\)\..*some.*small.*padding.*(Lirums|Kronars|Dokoras)
action (order) put #tvar pins.order $1 when (\d+)\)\..*some straight iron pins.*(Lirums|Kronars|Dokoras)
action (order) put #tvar polish.order $1 when (\d+)\)\..*jar of surface polish.*(Lirums|Kronars|Dokoras)
action (order) put #tvar oil.order $1 when (\d+)\)\.\s+a flask of oil.*(Lirums|Kronars|Dokoras)
action (order) put #tvar stain.order $1 when (\d+)\)\.\s+some wood stain.*(Lirums|Kronars|Dokoras)
action (order) put #tvar brush.order $1 when (\d+)\)\.\s+an iron wire brush.*(Lirums|Kronars|Dokoras)
action (order) put #tvar burlap.order $1 when (\d+)\)\..*yards of burlap cloth.*(Lirums|Kronars|Dokoras)
action (order) put #tvar wool.order $1 when (\d+)\)\..*yards of wool cloth.*(Lirums|Kronars|Dokoras)
action (order) put #tvar silk.order $1 when (\d+)\)\..*yards of silk cloth.*(Lirums|Kronars|Dokoras)
action (order) put #tvar linen.order $1 when (\d+)\)\..*yards of linen cloth.*(Lirums|Kronars|Dokoras)
action (order) put #tvar rat-pelt.order $1 when (\d+)\)\..*yards of rat-pelt leather.*(Lirums|Kronars|Dokoras)
action (order) put #tvar cougar-pelt.order $1 when (\d+)\)\..*yards of cougar-pelt leather.*(Lirums|Kronars|Dokoras)
action (order) put #tvar thread.order $1 when (\d+)\)\..*yards of cotton thread.*(Lirums|Kronars|Dokoras)
action (order) put #tvar water.order $1 when (\d+)\)\..*10 splashes of water.*(Lirums|Kronars|Dokoras)
action (order) put #tvar alcohol.order $1 when (\d+)\)\..*10 splashes of grain alcohol.*(Lirums|Kronars|Dokoras)
action (order) put #tvar catalyst.order $1 when (\d+)\)\..*a massive coal nugget.*(Lirums|Kronars|Dokoras)
action (order) put #tvar $2.order $1 when (\d+)\)\..*an intricate (\S+) sigil-scroll.*(Lirums|Kronars|Dokoras)
action (order) put #tvar salt.order $1 when (\d+)\)\..*a pouch of aerated salts.*(Lirums|Kronars|Dokoras)
action var need.coin 1 when you don't have enough coins|you don't have that much
 
#### Identifying extra pieces from the instruction book
action (book) var difficulty $1;var technique $2 when This is considered to be an? (.*?) piece to make, though knowledge of the (.*?) technique
action (book) var assemble $2 $3; var asmCount1 $1 when .*(\d).* (long|short) wooden (pole)$
action (book) var assemble $2; var asmCount1 $1 when .*(\d).* \S+ shield (handle)$
action (book) var assemble $2; var asmCount1 $1 when .*(\d).* wooden (hilt|haft)$
action (book) var assemble $2; var asmCount1 $1 when .*(\d).* (lenses)
action (book) var assemble $2; var asmCount1 $1 when .*(\d).* (backer)
action (book) var assemble $2 $3; var asmCount1 $1 when .*(\d).* (large) cloth (padding)$
action (book) var assemble $2 $3; var asmCount1 $1 when .*(\d).* (large) leather (backing)$
action (book) var assemble $2; var asmCount1 $1 when .*(\d).* (string)$
action (book) var assemble2 $2 $3; var asmCount2 $1 when .*(\d).* (small) cloth (padding)$
action (book) var assemble2 $2 $3; var asmCount2 $1 when .*(\d).* (small) leather (backing)$
action (book) var assemble2 $2 $3; var asmCount2 $1 when .*(\d).* (long|short) leather (cord)$
action (book) var assemble2 backer; var asmCount2 $1 when .*(\d).* backing material
action (book) var assemble2 $2; var asmCount2 $1 when .*(\d).* leather (strips)$
action (book) var assemble2 $2; var asmCount2 $1 when .*(\d).* (mechanism)$
action (book) var fount.need $1 when .*(\d).* mana fount$

### KERTIGEN HALO IDENTIFICATION
var HaloType NULL
action var HaloType $1 when (\w+) with a gleaming Kertigen halo

### ELEMENTAL WATER CUBE TIMER SETUP
if !def(MC.WATERCUBE.TIME) then put #var MC.WATERCUBE.TIME $gametime
if !def(MC.WATERCUBE.LAST) then put #var MC.WATERCUBE.LAST {#evalmath ($gametime - 900)}

#### MIGRATED FROM MASTERCRAFT MAIN SCRIPT SO THAT TOOL REPAIR WORKS IN ALL SCRIPTS
if $MC_END.EARLY = 1 then 
     {
         action instant var order.quantity 1 when You must bundle and deliver (\d+) more within
         action instant var order.quantity 1;put #var MC.order.quality $2 when I need (\d+).*(finely-crafted|of superior quality|of exceptional quality),
     }
else 
     {
         action instant var order.quantity $1 when You must bundle and deliver (\d+) more within
         action instant var order.quantity $1;put #var MC.order.quality $2 when I need (\d+).*(finely-crafted|of superior quality|of exceptional quality),
     }
action instant var (analyze) item.quality $2 when (is|are|have|has) (riddled with mistakes and practically|of dismal quality|very poorly-crafted|of below-average quality|of mediocre quality|of average quality|of above-average quality|well-crafted|finely-crafted|of superior quality|of exceptional quality|of outstanding quality|masterfully-crafted)
action instant var coin.temp $1 when You can purchase.*for (\d+) (Lirums|Kronars|Dokoras)\.
action instant math coin.intake add $1 when You hand .* your logbook and bundled items, and are given (\d+)
action instant math coin.intake subtract $1 when pay the sales clerk (\d+)
action instant math coin.intake subtract %coin.temp when takes some coins from you and hands you.*\.$
action instant var tool.repair $2 when This appears to be a crafting tool and .* (is|are|have|has) (.*?)(?: \(\d+-\d+\%\))?\.
action instant var tool.gone 1; var $1.gone 1 when The (.+) is all used up, so you toss
action instant var grind 1 when TURN the GRINDSTONE several times
action instant var chapter $1 when You seem to recall this item being somewhere in chapter (\d+) of the instruction book.
#     action goto lack.coin when ^LACK COIN
     action (analyze) off
###########################################################################
### Character Profiles. Please edit these for your character(s). 
###########################################################################
if $MC_TOOLBELT_%society.type != NULL then
	{
		echo Toolbelt for %society.type configured
	}
#Forging settings
if "%society.type" = "Forging" then
	{
     eval discipline tolower($MC_FORGING.DISCIPLINE)
     if !matchre("blacksmith|weapon|armor", "%discipline") then goto discfail
     eval work.difficulty tolower($MC_FORGING.DIFFICULTY)
     eval work.material tolower($MC_FORGING.MATERIAL)
     eval order.pref tolower(ingot)
     eval main.storage tolower(%forging.storage)
     eval deed.order tolower($MC_FORGING.DEED)
	}
#Outfitting settings
if "%society.type" = "Outfitting" then
	{
     eval discipline tolower($MC_OUT.DISCIPLINE)
     if "%discipline" != "tailor" then goto discfail
     eval work.difficulty tolower($MC_OUT.DIFFICULTY)
     eval work.material tolower($MC_OUT.MATERIAL)
     eval order.pref tolower($MC_OUT.PREF)
     eval main.storage tolower(%outfitting.storage)
     eval deed.order tolower($MC_OUT.DEED)
	}
#Engineering settings
if "%society.type" = "Engineering" then
	{
     eval discipline tolower($MC_ENG.DISCIPLINE)
     if !matchre("carving|shaping|tinkering", "%discipline") then goto discfail
     eval work.difficulty tolower($MC_ENG.DIFFICULTY)
     eval work.material tolower($MC_ENG.MATERIAL)
     eval deed.size
     eval order.pref tolower($MC_ENG.PREF)
     eval main.storage tolower(%engineering.storage)
     eval deed.order tolower($MC_ENG.DEED)
	}
#Alchemy Settings
if "%society.type" = "Alchemy" then
	{
     eval discipline tolower($MC_ALC.DISCIPLINE)
     if "%discipline" != "remed" then goto discfail
     eval work.difficulty tolower($MC_ALC.DIFFICULTY)
     var work.material
     var deed.size
     var order.pref 
     eval main.storage tolower(%alchemy.storage)
     var deed.order 
	}
#Enchanting Settings
if "%society.type" = "Enchanting" then
	{
     eval discipline tolower($MC_ENCHANTING.DISCIPLINE)
     if "%discipline" != "artif" then goto discfail
     eval work.difficulty tolower($MC_ENCHANTING.DIFFICULTY)
     var work.material
     var deed.size
     var order.pref 
     eval main.storage tolower(%enchanting.storage)
     var deed.order 
	}
goto endinclude

discfail:
	put #echo %discipline is not a valid %society.type Discipline. Please try again.
	exit


####################################################################################################
### End of Character Profiles. The following is necessary for location settings and script operation. 
####################################################################################################

     
location.vars:
	#Haven Forging
     var HF.room.list 442|441|443|405|404|398|402|403|409|408|399|406|407|400|410|411|401
     var HF.master.room 398|399|400|401
     var HF.work.room 405|409|403|407|411
     var HF.smelt.room 402|404|406|408|410
     var HF.grind.room %HF.work.room 
	#Haven Outfitting
     var HO.room.list 448|450|449|451|458|459|455|452|453|454|456|457|460
     var HO.master.room 448|449|450|451|452|453|454
     var HO.work.room 458|459|460|455|456|457
     var HO.wheel.room 458|459|460
     var HO.loom.room 455|456|457
	#Haven Engineering
     var HE.room.list 461|462|463|464|465|466|467|468|469
     var HE.master.room 462|461|463|464|465|466
     var HE.work.room 467|468|469|464|462
	#Haven Alchemy
     var HA.tools.room 470
     var HA.supplies.room 472
     var HA.books.room 482
     var HA.work.room 479|478|477|475|474|473|481|476
     var HA.room.list 470|471|473|474|475|481|472|476|479|478|477|480|482
     var HA.master.room 470|471|473|474|475|481|472|476|479|478|477|480|482
	#Haven Enchanting
     var HENT.tools.room 533
     var HENT.supplies.room 532
     var HENT.books.room 534
     var HENT.work.room 535|536|537|538|539|540|541
     var HENT.room.list 526|527|528|529|530|531|532|533|534|535|536|537|538|539|540
     var HENT.master.room 526|529|530|531|527|528
	#Crossing Forging
     var CF.room.list 903|865|962|961|960|902|905|904|906|963|907|908|909
     var CF.master.room 903|865|962|961|960|902|905|904|906|963|907|908|909
     var CF.smelt.room 903|904|960|961
     var CF.work.room 907|908|909|962|963
     var CF.grind.room 907|908|909|962|963
	#Crossing Outfitting
     var CO.room.list 873|910|911|912|913|914|915|916|917|918|919|920|921|922|923|924
     var CO.master.room 873|910|911|912|913|914|915|916
     var CO.work.room 917|918
     var CO.wheel.room 922|923|924
     var CO.loom.room 919|920|921
	#Crossing Engineering
     var CE.room.list 851|925|874|926|927|928|929|930
     var CE.master.room 851|925|874|926|927|928|929|930
     var CE.work.room 928|929|930
	#Crossing Alchemy
     var CA.room.list 898|931|932|933|934
     var CA.master.room 898|931|932|933|934
     var CA.work.room 898|931|932|933|934
     #Crossing Enchanting
     var CENT.tools.room 997
     var CENT.supplies.room 996
     var CENT.books.room 995
     var CENT.work.room 1000|1001|1002|1003
     var CENT.room.list 994|995|996|997|998|999|1000|1001|1002|1003
     var CENT.master.room 994|995|996|997|998|999
	#Lava Forge
     var LvF.room.list 774|777|776|775|778|782|779|784|780|786|781|783|785
     var LvF.master.room 775|778|782|779|784|780|786
     var LvF.smelt.room 778|779|780
     var LvF.work.room 781|783|785
     var LvF.grind.room 782|786|784
	#Leth Premie Forge
     var LPF.room.list 248|238|239|240|241|242|243|244|245|246|247|253|252|251|250|249|237
     var LPF.master.room 248|238|239|240|241|242|243|244|245|246|247|253|252
     var LPF.work.room 251|250|249
     var LPF.grind.room 252|253|247
     #Ratha Forging
     var RF.room.list 818|819|820|821|822|823|824|825|826|827|828|829|830|831|832
     var RF.master.room 819|820|821|822|823|824|825|826|827|828|829|830|831|832
     var RF.work.room 830|831|832
     var RF.grind.room 821|822|823
     #Ratha Outfitting
     var RO.room.list 850|851|852|846|843|845|847|848|849|844|841|839|840|842
     var RO.master.room 844|841|839|840|842|843|845|846
     var RO.work.room 845|846
     var RO.wheel.room 847|848|849
     var RO.loom.room 850|851|852
    #Ratha Engineering
     var RE.room.list 853|854|855|856|857|858|859|860|861|862
     var RE.master.room 853|854|855|856|857|858|859
     var RE.work.room 860|861|862
	#Ratha Alchemy
     var RA.room.list 863|864|865|866|867|868|869|870|871|872|873
     var RA.master.room 863|864|865|866|867|868|869|870
     var RA.work.room 871|872|873	
	#Shard Forging
     var SF.room.list 644|661|645|648|647|649|650|651|652|653|654|655|656|657|658|659|660|646
     var SF.master.room 644|645|649|650|653|654|655|658|646|661
     var SF.work.room 648|652|657|660
     var SF.grind.room %SF.work.room
     var SF.smelt.room 647|651|656|659
     #Shard Alchemy
     var SA.room.list 700|701|702|703|704|705
     var SA.master.room 700|701|702|703|704|705
     var SA.work.room 700|701|702|703|704|705
     #Shard Engineering
     var SE.room.list 711|712|713|714|715|716|717|718
     var SE.master.room 711|712|713|714|715|716|717|718
     var SE.work.room 712|713|714|715
     #Shard Outfitting
     var SO.room.list 719|720|721|722|723|724|725|726|727|728|729|730|731
     var SO.master.room 719|720|721|722|723|724|725
     var SO.work.room 726|727|728|729|730|731
     #Shard Enchanting
     var SENT.tools.room 757
     var SENT.supplies.room 758
     var SENT.books.room 759
     var SENT.work.room 762|763|764|765|766|767
     var SENT.room.list 755|756|757|758|759|760|761|762|763|764|765|766|767
     var SENT.master.room 756
     
	#Hibarnhivdar Forging
     var HibF.room.list 401|402|403|404|405|406|407|408|409|410|411|412|413
     var HibF.master.room 401|402|403|404|405|406|407|408|409|410|411|412|413
     var HibF.work.room 403|404|405|406
     var HibF.grind.room 413|412|411|410
     #Hibarnhivdar Engineering
     var HIBE.tools.room 481
     var HIBE.supplies.room 477
     var HIBE.books.room 482
     var HIBE.work.room 479|478|480
     var HIBE.room.list 478|479|480|481|482|477|476|475
     var HIBE.master.room 475|476|477|478|479|480|481|482
     #Hibarnhivdar Alchemy
     var HIBA.tools.room 464
     var HIBA.supplies.room 460
     var HIBA.books.room 459
     var HIBA.work.room 461|462|463
     var HIBA.room.list 457|458|459|460|461|462|463|464|465
     var HIBA.master.room 464|465|457|458|459|460|461|462|463    
     #Hibarnhivdar Enchanting
     var HIBENT.tools.room 432
     var HIBENT.supplies.room 433
     var HIBENT.books.room 431
     var HIBENT.work.room 436|437|438|435
     var HIBENT.room.list 436|437|438|435|430|431|432|433|434|429
     var HIBENT.master.room 436|437|438|435|430|431|432|433|434|429
     #Hibarnhivdar Outfitting
     var HIBO.room.list 466|467|468|469|470|471|472|473|474
     var HIBO.master.room 466|467|468|469|470|471|472|473|474
     var HIBO.work.room 469|467|470|468
     var HIBO.wheel.room 469|467|470|468
     var HIBO.loom.room 469|467|470|468    
     
	#Mer'Kresh Forging
     var MKF.room.list 332|333|334|335|336|337|338|339|340|341|342|343|344|345|346|347|348
     var MKF.tools.room 335
	var MKF.supplies.room 334
     var MKF.books.room 333
     var MKF.master.room 333|334|335|336|337|338
	var MKF.smelt.room 337|338|339|340|341
     var MKF.work.room 344|345|346|347|348
     var MKF.grind.room %MKF.work.room
     
     #Fang Cove Engineering
     var FE.room.list 206|207|208|209|210|220|221|182
     var FE.master.room 206|207|208|209|210|182
     var FE.work.room 220|221
     
     #Fang Cove Forging
     var FF.room.list 196|197|198|199|200|201|202|203|204|215|216|217|218|219|247|248|249
     var FF.master.room 196|197|198|199|200|201|202|203|204
     var FF.work.room 217|219|249
     var FF.grind.room 217|219|249
     var FF.smelt.room 216|218|248

     #Fang Cove Outfitting
     var FO.room.list 183|184|185|186|187|188|189|211|212|213|214
     var FO.master.room 183|184|185|186|187|188|189
     var FO.work.room 211|212|213|214     
     
     #Fang Cove Alchemy
     var FA.room.list 190|191|192|193|194|195
     var FA.master.room 190|191|192|193|194|195
     var FA.work.room 190|191
     
     #Fang Cove Enchanting
     var FENT.tools.room 235
     var FENT.supplies.room 236
     var FENT.books.room 234
     var FENT.work.room 241|240|238|239
     var FENT.room.list 232|233|234|235|236|237|238|239|240|241|182
     var FENT.master.room 232|233|234|235|236|237|182
     
     #Muspari Forging
     var MUF.room.list 504|505|506|507|508|509|510|511|512|513|514|515|516|517|518|519|520
     var MUF.master.room 504|505|506|507|508|509|510|511|512|513|514
     var MUF.work.room 516|518|520
     var MUF.grind.room 516|518|520
     var MUF.smelt.room 515|517|519
     
     #Muspari Engineering
     var MUE.room.list 521|522|523|524|525|526|527|528|529|530
     var MUE.master.room 521|522|523|524|525|526|527
     var MUE.work.room 528|529|530
     
     #Muspari Outfitting
     var MUO.room.list 489|490|491|492|493|494|495|496|497|498|499|500|501|502|503
     var MUO.master.room 489|490|491|492|493|494|495|496|497
     var MUO.work.room 498|499|500|501|502|503
     
     #Muspari Alchemy
     var MUA.room.list 531|532|533|534|535|536|537|538|539
     var MUA.master.room 531|532|533|534|535|536
     var MUA.work.room 537|538|539
	
	#Repair Locations
     var crossing.repair.room Rangu
     var crossing.repair Rangu
     var haven.repair.room 398
     var haven.repair clerk
     var ratha.repair.room 854
     var ratha.repair Glarstan
     var shard.repair.room Forging Clerk
     var shard.repair clerk
     var muspari.repair.room 506
     var muspari.repair Rokumru
     var fang.repair.room 205
     var fang.repair clerk

     var FC 0
     var Master.Found 0
     action instant var Master.Found 1 when ^Heavily muscled for an Elf, Fereldrin|^Yalda is a plump Dwarf|^Standing at an imposing height, the Gor'Tog surveys |^Serric is a muscular Human|^Juln is a muscular Dwarf|^Hagim is slight Gnome man|^Paarupensteen is a balding plump Halfling|^Milline is a tall Elothean woman|^Talia is a honey-brown haired Human|^This well-muscled Elf stands taller than 
     return

check.location: 
	#gosub Crossing.%current.lore
	#return
	var society none
	if $zoneid = 30 && matchre("%HF.room.list", "\b$roomid\b") then var society Haven.Forging
	if $zoneid = 30 && matchre("%HO.room.list", "\b$roomid\b") then var society Haven.Outfitting
	if $zoneid = 30 && matchre("%HE.room.list", "\b$roomid\b") then var society Haven.Engineering
	if $zoneid = 30 && matchre("%HA.room.list", "\b$roomid\b") then var society Haven.Alchemy
	if $zoneid = 30 && matchre("%HENT.room.list", "\b$roomid\b") then var society Haven.Enchanting
	if $zoneid = 1 && matchre("%CF.room.list", "\b$roomid\b") then var society Crossing.Forging
	if $zoneid = 1 && matchre("%CO.room.list", "\b$roomid\b") then var society Crossing.Outfitting
	if $zoneid = 1 && matchre("%CE.room.list", "\b$roomid\b") then var society Crossing.Engineering
	if $zoneid = 1 && matchre("%CA.room.list", "\b$roomid\b") then var society Crossing.Alchemy
     if $zoneid = 1 && matchre("%CENT.room.list", "\b$roomid\b") then var society Crossing.Enchanting
	if $zoneid = 90 && matchre("%RF.room.list", "\b$roomid\b") then var society Ratha.Forging
	if $zoneid = 90 && matchre("%RO.room.list", "\b$roomid\b") then var society Ratha.Outfitting
	if $zoneid = 90 && matchre("%RE.room.list", "\b$roomid\b") then var society Ratha.Engineering
	if $zoneid = 90 && matchre("%RA.room.list", "\b$roomid\b") then var society Ratha.Alchemy
	if $zoneid = 67 && matchre("%SF.room.list", "\b$roomid\b") then var society Shard.Forging
	if $zoneid = 67 && matchre("%SA.room.list", "\b$roomid\b") then var society Shard.Alchemy
	if $zoneid = 67 && matchre("%SE.room.list", "\b$roomid\b") then var society Shard.Engineering
	if $zoneid = 67 && matchre("%SO.room.list", "\b$roomid\b") then var society Shard.Outfitting
     if $zoneid = 67 && matchre("%SENT.room.list", "\b$roomid\b") then var society Shard.Enchanting
	if $zoneid = 116 && matchre("%HibF.room.list", "\b$roomid\b") then var society Hib.Forging
     if $zoneid = 116 && matchre("%HIBENT.room.list", "\b$roomid\b") then var society Hib.Enchanting
	if $zoneid = 116 && matchre("%HIBA.room.list", "\b$roomid\b") then var society Hib.Alchemy
	if $zoneid = 116 && matchre("%HIBE.room.list", "\b$roomid\b") then var society Hib.Engineering
	if $zoneid = 116 && matchre("%HIBO.room.list", "\b$roomid\b") then var society Hib.Outfitting
	if $zoneid = 107 && matchre("%MKF.room.list", "\b$roomid\b") then var society MerKresh.Forging
	if $zoneid = 7 && matchre("%LvF.room.list", "\b$roomid\b") then var society Lava.Forge
	if $zoneid = 61 && matchre("%LPF.room.list", "\b$roomid\b") then var society Leth.Premie.Forge
	if $zoneid = 150 && matchre("%FE.room.list", "\b$roomid\b") then var society Fang.Engineering
	if $zoneid = 150 && matchre("%FF.room.list", "\b$roomid\b") then var society Fang.Forging
	if $zoneid = 150 && matchre("%FO.room.list", "\b$roomid\b") then var society Fang.Outfitting
	if $zoneid = 150 && matchre("%FA.room.list", "\b$roomid\b") then var society Fang.Alchemy
	if $zoneid = 150 && matchre("%FENT.room.list", "\b$roomid\b") then var society Fang.Enchanting
     if $zoneid = 47 && matchre("%MUF.room.list", "\b$roomid\b") then var society Muspari.Forging
     if $zoneid = 47 && matchre("%MUE.room.list", "\b$roomid\b") then var society Muspari.Engineering
     if $zoneid = 47 && matchre("%MUO.room.list", "\b$roomid\b") then var society Muspari.Outfitting
     if $zoneid = 47 && matchre("%MUA.room.list", "\b$roomid\b") then var society Muspari.Alchemy
	pause 1
	assembleloc:
	# if $zoneid = 116 then
		# {
		# var handle.loc 413
		# var cord.loc 413
		# var pole.loc 413
		# var padding.loc 413
		# var hilt.loc 413
		# var haft.loc 413
		# }
	# if $zoneid = 107 then
		# {
		# var handle.loc 337
		# var cord.loc 337
		# var pole.loc 337
		# var padding.loc 337
		# var hilt.loc 337
		# var haft.loc 337
		# }
	# if $zoneid =67 then
		# {
		# var padding.loc 724
		# var handle.loc 724
		# var cord.loc 724
		# var flights.loc 711
		# var strips.loc 711
		# var pole.loc 711
		# var lenses.loc 711
		
	gosub %society
	return

Haven.Forging:
var master Fereldrin
put #tvar master.room %HF.master.room
put #tvar grind.room %HF.grind.room
put #tvar work.room %HF.work.room
put #tvar smelt.room %HF.smelt.room
put #tvar deed.room 442
put #tvar supply.room 400
put #tvar part.room 399
put #tvar tool.room 399
put #tvar oil.room 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Forging
return

Haven.Outfitting:
var master Hagim
put #tvar master.room %HO.master.room
put #tvar work.room %HO.work.room
put #tvar supply.room 450
put #tvar part.room 450
#order parts
put #tvar tool.room 451
put #tvar oil.room 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Outfitting
return

Haven.Engineering:
var master Paarupensteen
put #tvar master.room %HE.master.room
put #tvar work.room %HE.work.room
put #tvar supply.room 466
put #tvar part.room 465
put #tvar tool.room 465
put #tvar ingot.buy 399
put #tvar oil.room 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Engineering
return

Haven.Alchemy:
var master Carmifex
put #tvar master.room %HA.master.room
put #tvar work.room %HA.work.room
put #tvar supply.room 472
put #tvar tool.room 470
put #tvar oil.room 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Alchemy
return

Haven.Enchanting:
var master Trainer
put #tvar master.room %HENT.master.room
put #tvar work.room %HENT.work.room
put #tvar supply.room 532
put #tvar part.room 532
put #tvar tool.room 533
put #tvar oil.room 399
put #tvar repair.room %haven.repair.room
put #tvar repair.clerk %haven.repair
var society.type Enchanting
return

Crossing.Forging:
var master Yalda
put #tvar master.room %CF.master.room
put #tvar grind.room %CF.grind.room
put #tvar work.room %CF.work.room
put #tvar smelt.room %CF.smelt.room
put #tvar deed.room 906
put #tvar supply.room 906
put #tvar part.room 905
put #tvar tool.room 905
put #tvar oil.room 905
put #tvar repair.room %crossing.repair.room
put #tvar repair.clerk %crossing.repair
var society.type Forging
return 

Crossing.Outfitting:
var master Milline
put #tvar master.room %CO.master.room
put #tvar work.room %CO.work.room
put #tvar supply.room 914
put #tvar part.room 914
#order parts
put #tvar tool.room 913
put #tvar oil.room 905
put #tvar repair.room %crossing.repair.room
put #tvar repair.clerk %crossing.repair
var society.type Outfitting
return

Crossing.Engineering:
var master Talia
put #tvar master.room %CE.master.room
put #tvar work.room %CE.work.room
put #tvar supply.room 874
put #tvar part.room 874
put #tvar tool.room 851
put #tvar ingot.buy 906
put #tvar oil.room 905
put #tvar repair.room %crossing.repair.room
put #tvar repair.clerk %crossing.repair
var society.type Engineering
return

Crossing.Alchemy:
var master Lanshado
put #tvar master.room %CA.master.room
put #tvar work.room %CA.work.room
put #tvar supply.room 933
put #tvar tool.room 931
put #tvar oil.room 905
put #tvar repair.room %crossing.repair.room
put #tvar repair.clerk %crossing.repair
var society.type Alchemy
return

Crossing.Enchanting:
var master Trainer
put #tvar master.room %CENT.master.room
put #tvar work.room %CENT.work.room
put #tvar supply.room 996
put #tvar part.room 996
put #tvar tool.room 997
put #tvar oil.room 905
put #tvar repair.room %crossing.repair.room
put #tvar repair.clerk %crossing.repair
var society.type Enchanting
return

Lava.Forge:
var master Borneas
put #tvar master.room %LvF.master.room
put #tvar grind.room %LvF.grind.room
put #tvar work.room %LvF.work.room
put #tvar smelt.room %LvF.smelt.room
put #tvar deed.room 775
put #tvar supply.room 775
put #tvar part.room 777
put #tvar tool.room 777
put #tvar oil.room 777
var society.type Forging
return

Leth.Premie.Forge:
var master None
put #tvar master.room %LPF.master.room
put #tvar grind.room %LPF.grind.room
put #tvar work.room %LPF.work.room
put #tvar deed.room 248
put #tvar supply.room 248
put #tvar part.room 248
put #tvar tool.room 238
put #tvar oil.room 238
var society.type Forging
return

Ratha.Forging:
var master Grimbly
put #tvar master.room %RF.master.room
put #tvar grind.room %RF.grind.room
put #tvar work.room %RF.work.room
put #tvar deed.room 829
put #tvar supply.room 829
put #tvar part.room 819
put #tvar tool.room 819
put #tvar oil.room 819
put #tvar smelt.room 826|827|828
put #tvar repair.room %ratha.repair.room
put #tvar repair.clerk %ratha.repair
var society.type Forging
return

Ratha.Outfitting:
var master Master
put #tvar master.room %RO.master.room
put #tvar work.room %RO.work.room
put #tvar supply.room 844
put #tvar part.room 844
put #tvar tool.room 842
put #tvar oil.room 819
put #tvar repair.room %ratha.repair.room
put #tvar repair.clerk %ratha.repair
var society.type Outfitting
return

Ratha.Engineering:
var master Master
put #tvar master.room %RE.master.room
put #tvar work.room %RE.work.room
put #tvar supply.room 858
put #tvar part.room 858
put #tvar tool.room 857
put #tvar ingot.buy 829
put #tvar oil.room 819
put #tvar repair.room %ratha.repair.room
var #tvar repair.clerk %ratha.repair
var society.type Engineering
return

Ratha.Alchemy:
var master Master
put #tvar master.room %RA.master.room
put #tvar work.room %RA.work.room
put #tvar supply.room 865
put #tvar tool.room 864
put #tvar oil.room 819
put #tvar repair.room %ratha.repair.room
var repair.clerk %ratha.repair
var society.type Alchemy
return

Shard.Forging:
var master Serric
put #tvar master.room %SF.master.room
put #tvar grind.room %SF.grind.room
put #tvar work.room %SF.work.room
put #tvar smelt.room %SF.smelt.room
put #tvar deed.room 661
put #tvar supply.room 658
put #tvar part.room 653
put #tvar tool.room 653
put #tvar oil.room 653
put #tvar repair.room %shard.repair.room
put #tvar repair.clerk %shard.repair
var society.type Forging
return

Shard.Alchemy:
var master Benzia
put #tvar master.room %SA.master.room
put #tvar work.room %SA.work.room
put #tvar supply.room 701
put #tvar tool.room 703
put #tvar oil.room 653
put #tvar repair.room %shard.repair.room
put #tvar repair.clerk %shard.repair
var society.type Alchemy
return

Shard.Engineering:
var master Master
put #tvar master.room %SE.master.room
put #tvar work.room %SE.work.room
put #tvar supply.room 711
put #tvar part.room 711
put #tvar tool.room 718
put #tvar ingot.buy 658
put #tvar oil.room 653
put #tvar repair.room %shard.repair.room
put #tvar repair.clerk %shard.repair
var society.type Engineering
return

Shard.Outfitting:
var master Jakke
put #tvar master.room %SO.master.room
put #tvar work.room %SO.work.room
put #tvar part.room 724
put #tvar supply.room 724
put #tvar tool.room 723
put #tvar oil.room 653
put #tvar repair.room %shard.repair.room
put #tvar repair.clerk %shard.repair
var society.type Outfitting
return

Shard.Enchanting:
var master Trainer
put #tvar master.room %SENT.master.room
put #tvar work.room %SENT.work.room
put #tvar supply.room %SENT.supplies.room
put #tvar part.room %SENT.supplies.room
put #tvar tool.room %SENT.tools.room
put #tvar oil.room 653
put #tvar repair.room %shard.repair.room
put #tvar repair.clerk %shard.repair
var society.type Enchanting
return

Hib.Alchemy:
var master Thynik
put #tvar master.room %HIBA.master.room
put #tvar work.room %HIBA.work.room
put #tvar supply.room %HIBA.supplies.room
put #tvar tool.room %HIBA.tools.room 
put #tvar oil.room 407
put #tvar repair.room 314
put #tvar repair.clerk Ladar
var society.type Alchemy
return

Hib.Engineering:
var master Master
put #tvar master.room %HIBE.master.room
put #tvar work.room %HIBE.work.room
put #tvar supply.room %HIBE.supplies.room
put #tvar part.room %HIBE.supplies.room
put #tvar tool.room %HIBE.tools.room
put #tvar ingot.buy 409
put #tvar oil.room 407
put #tvar repair.room 314
put #tvar repair.clerk Ladar
var society.type Engineering
return

Hib.Forging:
var master Juln
put #tvar master.room %HibF.master.room
put #tvar grind.room %HibF.grind.room
put #tvar work.room %HibF.work.room
put #tvar deed.room 415
put #tvar supply.room 409
put #tvar part.room 413
put #tvar tool.room 407
put #tvar oil.room 407
put #tvar repair.room 314
put #tvar repair.clerk Ladar
var society.type Forging
return

Hib.Enchanting:
var master Trainer
put #tvar master.room %HIBENT.master.room
put #tvar work.room %HIBENT.work.room
put #tvar supply.room %HIBENT.supplies.room
put #tvar part.room %HIBENT.supplies.room
put #tvar tool.room %HIBENT.tools.room
put #tvar oil.room 413
put #tvar repair.room 314
put #tvar repair.clerk Ladar
var society.type Enchanting
return

Hib.Outfitting:
var master Master
put #tvar master.room %HIBO.master.room
put #tvar work.room %HIBO.work.room
put #tvar supply.room 471
put #tvar part.room 471
#order parts
put #tvar tool.room 473
put #tvar oil.room 413
put #tvar repair.room 314
put #tvar repair.clerk Ladar
var society.type Outfitting
return

MerKresh.Forging:
var master Kapric
put #tvar master.room %MKF.master.room
put #tvar grind.room %MKF.grind.room
put #tvar work.room %MKF.work.room
put #tvar deed.room 336
put #tvar supply.room %MKF.supplies.room
put #tvar part.room %MKF.tools.room
put #tvar tool.room %MKF.tools.room
put #tvar oil.room %MKF.tools.room
put #tvar smelt.room %MKF.smelt.room
var society.type Forging
return

Fang.Engineering:
var master Brogir
put #tvar master.room %FE.master.room
put #tvar work.room %FE.work.room
put #tvar supply.room 208
put #tvar part.room 208
put #tvar tool.room 209
put #tvar ingot.buy 200
put #tvar oil.room 215
put #tvar repair.room %fang.repair.room
put #tvar repair.clerk %fang.repair
var society.type Engineering
return

Fang.Forging:
var master Phahoe
put #tvar master.room %FF.master.room
put #tvar grind.room %FF.grind.room
put #tvar work.room %FF.work.room
put #tvar deed.room 203
put #tvar supply.room 200
put #tvar part.room 215
put #tvar tool.room 215
put #tvar oil.room 215
put #tvar smelt.room %FF.smelt.room
put #tvar repair.room %fang.repair.room
put #tvar repair.clerk %fang.repair
var society.type Forging
return

Fang.Outfitting:
var master Varcenti
put #tvar master.room %FO.master.room
put #tvar work.room %FO.work.room
put #tvar supply.room 187
put #tvar part.room 187
put #tvar tool.room 186
put #tvar oil.room 215
put #tvar repair.room %fang.repair.room
put #tvar repair.clerk %fang.repair
var society.type Outfitting
return

Fang.Alchemy:
var master Swetyne
put #tvar master.room %FA.master.room
put #tvar work.room %FA.work.room
put #tvar supply.room 194
put #tvar tool.room 193
put #tvar oil.room 215
put #tvar repair.room %fang.repair.room
put #tvar repair.clerk %fang.repair
var society.type Alchemy
return

Fang.Enchanting:
var master Trainer
put #tvar master.room %FENT.master.room
put #tvar work.room %FENT.work.room
put #tvar supply.room 236
put #tvar part.room 236
put #tvar tool.room 235
put #tvar oil.room 215
put #tvar repair.room %fang.repair.room
put #tvar repair.clerk %fang.repair
var society.type Enchanting
return

Muspari.Engineering:
var master Master
put #tvar master.room %MUE.master.room
put #tvar work.room %MUE.work.room
put #tvar supply.room 525
put #tvar part.room 525
put #tvar tool.room 526
put #tvar oil.room 510
put #tvar ingot.buy 511
put #tvar repair.room %muspari.repair.room
put #tvar repair.clerk %muspari.repair
var society.type Engineering
return

Muspari.Forging:
var master Master
put #tvar master.room %MUF.master.room
put #tvar grind.room %MUF.grind.room
put #tvar work.room %MUF.work.room
put #tvar deed.room 509
put #tvar supply.room 511
put #tvar part.room 510
put #tvar tool.room 510
put #tvar oil.room 510
put #tvar repair.room %muspari.repair.room
put #tvar repair.clerk %muspari.repair
put #tvar smelt.room %MUF.smelt.room
var society.type Forging
return

Muspari.Outfitting:
var master Master
put #tvar master.room %MUO.master.room
put #tvar work.room %MUO.work.room
put #tvar supply.room 493
put #tvar part.room 493
put #tvar tool.room 495
put #tvar oil.room 510
put #tvar repair.room %muspari.repair.room
put #tvar repair.clerk %muspari.repair
var society.type Outfitting
return

Muspari.Alchemy:
var master Master
put #tvar master.room %MUA.master.room
put #tvar work.room %MUA.work.room
put #tvar supply.room 532
put #tvar tool.room 534
put #tvar oil.room 510
put #tvar repair.room %muspari.repair.room
put #tvar repair.clerk %muspari.repair
var society.type Alchemy
return

none:
if (($MC_WORK.OUTSIDE) && (matchre("$scriptlist", "(?i)(MC_.*?\.cmd)"))) then 
     {
     if matchre("$scriptlist", "(?i)(Smelt|Pound|Grind)") then var society.type Forging
     if matchre("$scriptlist", "(?i)(Sew|Spin|Knit|Weave)") then var society.type Outfitting
     if matchre("$scriptlist", "(?i)(Carve|Tinker|Shape)") then var society.type Engineering
     if matchre("$scriptlist", "(?i)Mix") then var society.type Alchemy
     if matchre("$scriptlist", "(?i)Enchant") then var society.type Enchanting
     return
     }
if matchre("$scriptlist", "mastercraft") then 
	{
	put #echo You are not in a valid society
	exit
	}
return


find.room:
	if "%discipline" = "remed" then return
	var find.room $1
	gosub roomplayerstrip
     if ((matchre("%find.room", "$roomid")) && matchre("%tempplayers", "(^$)")) then 
          {
          unvar tempplayers
          return
          }
     unvar tempplayers
     var temp 0
     eval temp.max count("%find.room","|")
find.room2:
     gosub automove %find.room(%temp)
     pause 0.1
     gosub roomplayerstrip
     echo ROOMID: $roomid
      if ((matchre("%find.room", "\b$roomid\b")) && matchre("$roomplayers", "(^$)")) then
		{
		unvar temp
		unvar temp.max
          unvar tempplayers
		return
		}
     math temp add 1
     unvar tempplayers
     if %temp > %temp.max then gosub find.room.wait
	 pause 0.2
     goto find.room2
	return
	
roomplayerstrip:
	eval tempplayers replace("$roomplayers", "Also here: ", "")
	eval tempplayers replace("$roomplayers", ", ", "|")
	eval tempplayers replace("%tempplayers", " and " "|")
     eval tempplayers replace("$roomplayers", "$MC_FRIENDLIST", "")
     eval tempplayers replace("%tempplayers", "\|+", "|")
     eval tempplayers replace("%tempplayers", "^\|", "")
     eval tempplayers replace("%tempplayers", "\|$", "")
     return
	
find.room.wait:
     var temp 0
     gosub automove $tool.room
     echo *** All workrooms occupied, waiting 30 seconds before trying again...
     put #parse All workrooms occupied
     pause 30
     return

find.master:
     if (def(automapper.typeahead) && ($automapper.typeahead != 0) then
          {
          var currenttypeahead $automapper.typeahead
          put #var automapper.typeahead 0
          }
     # action (master) put #script abort automapper when eval matchre("$roomobjs", "%master")
     action (master) put #parse YOU HAVE ARRIVED when eval matchre("$monsterlist", "%master")
     gosub check.location
     var Master.Found 0
     var temp 0
     eval temp.max count("$master.room","|")
     #pause 1
     #send look %master
     #pause 1
     #if %Master.Found = 1 then
     if matchre("$roomobjs", "%master") then
          {
               unvar temp
               unvar temp.max
               action (master) off
               if (def(automapper.typeahead)) then put #var automapper.typeahead %currenttypeahead
               return
          }
find.master2:
     pause 1
     if matchre("$roomobjs", "%master") then
		{
               unvar temp
               unvar temp.max
               action (master) off
               if (def(automapper.typeahead)) then put #var automapper.typeahead %currenttypeahead
               return
		}
     gosub automove $master.room(%temp)
     #send look %master
     #pause 1
     #if %Master.Found = 1 then
     if matchre("$roomobjs", "%master") then
		{
               unvar temp
               unvar temp.max
               action (master) off
               if (def(automapper.typeahead)) then put #var automapper.typeahead %currenttypeahead
               return
		}
     math temp add 1
     if %temp > %temp.max then
	{
	goto find.master
     echo %master not found in any room specified. Check your master room list for this society!
     exit
	}
	goto find.master2
	return

door:
     matchre arch What were you
     matchre return Obvious
     put go door
     matchwait
     
arch:
     matchre MOVE_RANDOM What were you
     matchre return Obvious
     put go arch
     matchwait
     
MOVE_RANDOM:
     delay 0.0001
     random 1 8
     if (%r = 1) && (!$north) then goto MOVE_RANDOM
     if (%r = 2) && (!$northeast) then goto MOVE_RANDOM
     if (%r = 3) && (!$east) then goto MOVE_RANDOM
     if (%r = 4) && (!$southeast) then goto MOVE_RANDOM
     if (%r = 5) && (!$south) then goto MOVE_RANDOM
     if (%r = 6) && (!$southwest) then goto MOVE_RANDOM
     if (%r = 7) && (!$west) then goto MOVE_RANDOM
     if (%r = 8) && (!$northwest) then goto MOVE_RANDOM
     #
     if (%r = 1) then var Direction north
     if (%r = 2) then var Direction northeast
     if (%r = 3) then var Direction east
     if (%r = 4) then var Direction southeast
     if (%r = 5) then var Direction south
     if (%r = 6) then var Direction southwest
     if (%r = 7) then var Direction west
     if (%r = 8) then var Direction northwest
     #
     if (%r = 1) then var Reverse.Direction south
     if (%r = 2) then var Reverse.Direction southwest
     if (%r = 3) then var Reverse.Direction west
     if (%r = 4) then var Reverse.Direction northwest
     if (%r = 5) then var Reverse.Direction north
     if (%r = 6) then var Reverse.Direction northeast
     if (%r = 7) then var Reverse.Direction east
     if (%r = 8) then var Reverse.Direction southeast
     #
     var Exits 0
     if ($north) then math Exits add 1
     if ($northeast) then math Exits add 1
     if ($east) then math Exits add 1
     if ($southeast) then math Exits add 1
     if ($south) then math Exits add 1
     if ($southwest) then math Exits add 1
     if ($west) then math Exits add 1
     if ($northwest) then math Exits add 1
     #
     # don't move "back" on a path unless we hit a dead end
     if (%Exits > 1) && ("%Last.Direction" = "%Reverse.Direction") then goto MOVE_RANDOM
     #
     var Last.Direction %Direction
     # Trigger to set variable for occupied room, when roaming.
     action instant var Occupied 1 when ^Also here\:|^Also in the room\:
     var Occupied 0
     gosub MOVE_RESUME
     if (%Occupied) then goto MOVE_RANDOM
     return
####################################################################################
MOVE:
     delay 0.0001
     var Direction $0
     var movefailCounter 0
MOVE_RESUME:
     matchre MOVE_RESUME ^\.\.\.wait|^Sorry\,
     matchre MOVE_RESUME ^You make your way up the .*\.\s*Partway up\, you make the mistake of looking down\.\s*Struck by vertigo\, you cling to the .* for a few moments\, then slowly climb back down\.
     matchre MOVE_RESUME ^You pick your way up the .*\, but reach a point where your footing is questionable\.\s*Reluctantly\, you climb back down\.
     matchre MOVE_RESUME ^You approach the .*\, but the steepness is intimidating\.
     matchre MOVE_RESUME ^You struggle
     matchre MOVE_RESUME ^You blunder
     matchre MOVE_RESUME ^You slap
     matchre MOVE_RESUME ^You work
     matchre MOVE_RESUME make much headway
     matchre MOVE_RESUME ^You flounder around in the water\.
     matchre MOVE_RETREAT ^You are engaged to .*\!
     matchre MOVE_STAND ^You start up the .*\, but slip after a few feet and fall to the ground\!\s*You are unharmed but feel foolish\.
     matchre MOVE_STAND ^Running heedlessly over the rough terrain\, you trip over an exposed root and land face first in the dirt\.
     matchre MOVE_STAND ^You can't do that while lying down\.
     matchre MOVE_STAND ^You can't do that while sitting\!
     matchre MOVE_STAND ^You must be standing to do that\.
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_STAND ^Stand up first.
     matchre MOVE_DIG ^You make no progress in the mud \-\- mostly just shifting of your weight from one side to the other\.
     matchre MOVE_DIG ^You find yourself stuck in the mud\, unable to move much at all after your pathetic attempts\.
     matchre MOVE_DIG ^You struggle forward\, managing a few steps before ultimately falling short of your goal\.
     matchre MOVE_DIG ^Like a blind\, lame duck\, you wallow in the mud in a feeble attempt at forward motion\.
     matchre MOVE_DIG ^The mud holds you tightly\, preventing you from making much headway\.
     matchre MOVE_DIG ^You fall into the mud with a loud \*SPLUT\*\.
     matchre MOVE_FAILED ^You can't go there
     matchre MOVE_FAILED ^I could not find what you were referring to\.
     matchre MOVE_FAILED ^What were you referring to\?
     matchre MOVE_RETURN ^It's pitch dark
     matchre MOVE_RETURN ^Obvious
     send %Direction
     matchwait
MOVE_STAND:
     pause 0.1
     matchre MOVE_STAND ^\.\.\.wait|^Sorry\,
     matchre MOVE_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_STAND ^The weight
     matchre MOVE_STAND ^You try
     matchre MOVE_RETREAT ^You are already standing\.
     matchre MOVE_RETREAT ^You stand(?:\s*back)? up\.
     matchre MOVE_RETREAT ^You stand up\.
     send stand
     matchwait
MOVE_RETREAT:
     pause 0.1
     matchre MOVE_RETREAT ^\.\.\.wait|^Sorry\,
     matchre MOVE_RETREAT ^You retreat back to pole range\.
     matchre MOVE_RETREAT ^You try to back away
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_RESUME ^You retreat from combat\.
     matchre MOVE_RESUME ^You are already as far away as you can get\!
     send retreat
     matchwait
MOVE_DIG:
     pause 0.1
     matchre MOVE_DIG ^\.\.\.wait|^Sorry\,
     matchre MOVE_DIG ^You struggle to dig off the thick mud caked around your legs\.
     matchre MOVE_STAND ^You manage to dig enough mud away from your legs to assist your movements\.
     matchre MOVE_DIG_STAND ^Maybe you can reach better that way\, but you'll need to stand up for that to really do you any good\.
     matchre MOVE_RESUME ^You will have to kneel
     send dig
     matchwait
MOVE_DIG_STAND:
     pause 0.1
     matchre MOVE_DIG_STAND ^\.\.\.wait|^Sorry\,
     matchre MOVE_DIG_STAND ^The weight
     matchre MOVE_DIG_STAND ^You try
     matchre MOVE_DIG_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_DIG ^You stand(?:\s*back)? up\.
     matchre MOVE_DIG ^You are already standing\.
     send stand
     matchwait
MOVE_FAILED:
     evalmath movefailCounter (movefailCounter + 1)
     if (%movefailCounter > 3) then goto MOVE_FAIL_BAIL
     pause 0.5
     goto MOVE_RESUME
MOVE_FAIL_BAIL:
     put #echo
     put #echo >$Log Crimson *** MOVE FAILED. ***
     put #echo Crimson *** MOVE FAILED.  ***
     put #echo
     exit
MOVE_RETURN:
     if $roomid = 0 then goto door
     return
     
automove:
	 pause 0.2
     var toroom $0
     if $roomid = 0 then 
          {
          gosub door
          put #mapper reset
          }
automovecont:
     pause 0.2
     match automovecont2 Bonk! You smash your nose.
     match return YOU HAVE ARRIVED
     match automovecont1 YOU HAVE FAILED
     put #goto %toroom
     matchwait 90
     if $roomid = 0 then 
          {
          gosub door
          }
     
     put #mapper reset
     goto automovecont

automovecont1:
     pause
     put look
     pause
	goto automovecont

automovecont2:
     pause
     if matchre("$scriptlist", "automapper") then send #script abort automapper
     pause
     return

mark:
	if matchre("$MC.Mark", "(?i)off") then return
     send get my stamp
     waitforre ^You get
     send mark $MC.order.noun with my stamp
     waitforre ^Roundtime
     send stow my stamp
     waitforre ^You put
     return

anvilcheck:
	var anvilingot 0
	matchre clean ^The anvil already has|unfinished .+ (\S+)\.
	matchre return The anvil's surface looks clean
	matchre ingot On the.* anvil you see a %work.material ingot
	matchre manualclean On the.* anvil you see a 
	put look on anvil
	matchwait 2

	
clean:
	send clean anvil
	send clean anvil
	pause 0.5
	pause 0.5
	return

manualclean:
	send get ingot from anvil
	send drop ingot
	return
	
ingot:
     var tempvolume null
     send analyze ingot on anvil
	waitforre About (\d+) volume of metal was used in this|^Roundtime|What where you
     var tempvolume $1
     if "%tempvolume" != "null" then
		{
			if %volume > %tempvolume then goto manualclean
		}
	var anvilingot 1
	return
	
summonwater:
	match summonwater2 Brushing your fingers
	match manualwater What were you referring
	match manualwater Rub what?
	match manualwater Lacking the power to activate
	send rub white waterskin in %main.storage
	matchwait
summonwater2:
	gosub GET water from white waterskin in %main.storage
	gosub PUT_IT my water in my %main.storage
	var water.gone 0
	return
	
summonoil:
	match summonoil2 Brushing your fingers
	match RETURN What were you referring
	match RETURN Rub what?
	match RETURN Lacking the power to activate
    send rub my oilskin pouch
	matchwait
summonoil2:
    gosub GET oil from oilskin pouch
	gosub PUT_IT my oil in my %main.storage
	var oil.gone 0
	return

manualwater:
	gosub automove alchemy suppl
	action (order) on
     pause 0.5
	gosub ORDER
     pause 0.2
	action (order) off
	gosub ORDER 1
	gosub PUT_IT my water in my %main.storage
	var water.gone 0
	return

summonalcohol:
	match summonalcohol2 Brushing your fingers
	match manualalcohol What were you referring
	match manualalcohol Rub what?
	match manualalcohol Lacking the power to activate
	send rub moonshine jug in %main.storage
	matchwait
summonalcohol2:
	gosub GET alcohol from moonshine jug in %main.storage
	gosub PUT_IT my alcohol in my %main.storage
	var water.gone 0
	return

manualalcohol:
	gosub automove alchemy suppl
	action (order) on
	gosub ORDER
     pause 0.2
	action (order) off	
	gosub ORDER $alcohol.order
	gosub PUT_IT my alcohol in my %main.storage
	var water.gone 0
	return
	
##############################
### MIGRATED FROM MASTERCRAFT - TO WORK WITH ALL INDIVIDUAL SCRIPTS

# This sub added for picking up any repair ticket in inventory when MC FIRST STARTS - to get items back
repair.start:
     var temp.room $roomid
     gosub automove $repair.room
     gosub RepairAllItems
     gosub ReturnAllItems
     gosub automove %temp.room
     return

get.tools:
     var temp.room $roomid
	gosub automove $repair.room
     var toolcount 0
     eval toolstotal count("$MC_WORK.TOOLS","|")
	gosub EMPTY_HANDS
get.tools1:
     if matchre ("(?i)$MC_WORK.TOOLS(%toolcount)", "(?i)%clerktools") then 
	 {
          matchre got.tool \"Ah, yes, we have one of your tools like that.\" 
          matchre missing.tool \"It doesn't look like we have anything like that of yours here.\"
          matchre tool.error \"Well, you need a free hand if I'm going to help you.\"
          put ask $repair.clerk for $MC_WORK.TOOLS(%toolcount)
          matchwait 10
     }
     math toolcount add 1
     if (%toolcount > %toolstotal) then goto clerk.tools.done
     goto get.tools1

tool.error:
     echo >log green MASTERCRAFT: Error getting tools from clerk - hands full even after clearing
	 goto clerk.tools.done

missing.tool:
     put #echo >log green MASTERCRAFT: $MC_WORK.TOOLS(%toolcount) tool not in storage?
     math toolcount add 1
     if %toolcount > %toolstotal then goto clerk.tools.done
     goto get.tools1

got.tool:
     gosub EMPTY_HANDS
     math toolcount add 1
     if %toolcount > %toolstotal then goto clerk.tools.done
     goto get.tools1
	 
clerk.tools.done:
     gosub automove %temp.room
	return

check.tools:
     evalmath lastToolRepairTime $gametime - $last%society.typeRepair
     if %lastToolRepairTime < 100 then return
     var temp 0
     eval MaxTemp count("$MC_WORK.TOOLS","|")
check.tools2:
     gosub ToolCheckRight $MC_WORK.TOOLS(%temp)
     gosub repair.tool $MC_WORK.TOOLS(%temp)
     unvar repair.temp
     gosub STOW_RIGHT
     math temp add 1
     if %temp > %MaxTemp then
          {
               unvar temp
               unvar MaxTemp
               return
          }
     gosub check.tools2
     if $MC.Mark = "on" then
          {
               gosub GET my stamp from my %main.storage
               gosub repair.tool stamp
               gosub PUT_IT my stamp in my %main.storage
          }
     put #var last%society.typeRepair $gametime
     return

repair.tool:
     var repair.temp $0
repair.tool_1:
     var too.damaged 0
     if %tool.gone = 1 then gosub new.tool
     send analyze my %repair.temp
     pause 1
     if "%tool.repair" = "in pristine condition" || "%tool.repair" = "practically in mint condition" then return
     pause .1
     if "%auto.repair" = "off" then
          {
               if !def(repair.room) then return
               var temp.room $roomid
               gosub automove $repair.room
               gosub RepairAllItems
               gosub ReturnAllItems
               gosub automove %temp.room
               return
          }
     action var auto.repair off;var too.damaged 1 when ^The .+ has suffered too much damage and needs to be repaired at a crafting repair shop
     send craft blacksmith
     waitforre ^From the blacksmithing crafting discipline you have been trained in (.*)\.$
     var repair.techs $0
     pause .5
     if (contains("%repair.techs", "Tool Repair") then
          {
               gosub toolcheck
               pause .5
               if !matchre("$righthand|$lefthand", "%repair.temp") then gosub GET my %repair.temp
               if "$lefthand" != "Empty" then gosub PUT_IT $lefthandnoun in my %main.storage
               gosub GET my wire brush
               gosub PUT rub my %repair.temp with my brush
               gosub PUT_IT my wire brush in my %main.storage
               if (%too.damaged = 1) then goto repair.tool_1
               gosub GET my oil
               gosub PUT pour my oil on my %repair.temp
               gosub PUT_IT my oil in my %main.storage
               goto repair.tool_1
          }
     else
          {
               echo ***  Pausing script for you to get %repair.temp repaired!
               echo ***  You should probably repair all of your relevant tools while you're there.
               echo ***  Type GOGO in your original crafting hall to resume script...
               put #parse GO REPAIR
               waitforre (?i)gogo
               return
          }
     return
     
toolcheck:
     var brush.gone 1
     var oil.gone 1
     action var brush.gone 0 when ^You tap an iron wire brush
     action var oil.gone 0 when ^You tap a flask of oil
     gosub put tap brush
	gosub put tap brush in portal
     gosub put tap oil
	gosub put tap oil in portal
     pause 0.5
     if ((%brush.gone = 1) || (%oil.gone = 1)) then gosub new.tool
     return

RepairAllItems:
     if "$righthand" != "Empty" then gosub RepairItem $righthandnoun
     eval totaltool count("$MC_WORK.TOOLS", "|")
     var currenttool 0
RepairAllItems_1:
     if %currenttool > %totaltool then return
     gosub RepairItem $MC_WORK.TOOLS(%currenttool)
     math currenttool add 1
     goto RepairAllItems_1
     return

RepairItem:
     var item $0
     gosub GET my %item
     pause .2
     if "$righthand $lefthand" == "Empty Empty" then return
     gosub PUT give $repair.clerk
     gosub PUT give $repair.clerk
     gosub STOW_RIGHT
     wait
     pause .2
     return

ReturnAllItems:
     match ticket You get
     match ReturnAllItems2 I could not find
     match ReturnAllItems2 What were you referring to
     send get my ticket
     matchwait
ReturnAllItems2:
     match ticket You get
     match return I could not find
     match return What were you referring to
     send get my ticket from my portal
     matchwait

Ticket:
     match tool.store You hand
     match tool.store What is it
     send give ticket to $repair.clerk
     matchwait 15

ticket.pause:
     pause 60
     goto ticket

tool.store:
     gosub STOW_RIGHT
     goto ReturnAllItems
     

new.tool:
     var temp.room $roomid
     gosub STOW_RIGHT
     gosub GET %work.material
     gosub PUT_IT %work.material in my %main.storage
     var temp.room $roomid
     gosub automove $tool.room
     action (order) on
     gosub ORDER
     action (order) off
     if %oil.gone = 1 then gosub summonoil
     if %stain.gone = 1 then
          {
               gosub automove $tool.room
               action (order) on
               pause 0.5
               gosub ORDER
               pause 0.2
               action (order) off
               gosub ORDER $stain.order
               gosub PUT_IT my stain in my %main.storage
               var stain.gone 0
          }
     if %oil.gone = 1 then
          {
               gosub automove $oil.room
               action (order) on
               pause 0.5
               gosub ORDER
               pause 0.2
               action (order) off
               gosub ORDER $oil.order
               gosub PUT_IT my oil in my %main.storage
               var oil.gone 0
          }
     if %brush.gone = 1 then
          {
               gosub automove $oil.room
               action (order) on
               pause 0.5
               gosub ORDER
               pause 0.2
               action (order) off
               gosub ORDER $brush.order
               gosub PUT_IT my brush in my %main.storage
               var brush.gone 0
          }
     gosub automove %temp.room
     unvar temp.room
     var tool.gone 0
     return
     

lack.coin:
     if "%get.coin" = "off" then goto lack.coin.exit
     var temp.room $roomid
     action (withdrawl) goto lack.coin.exit when (^The clerk flips through her ledger|^The clerk tells you)
     if matchre("116", "\b$zoneid\b") then gosub automove 1teller
     else gosub automove teller
     gosub PUT withd $MC_WITHD.AMOUNT
     gosub automove %temp.room
     var need.coin 0
     action remove (^The clerk flips through her ledger|^The clerk tells you)
     pause 1
#     if matchre("$scriptlist", "MC_") then return
#     if %reqd.order > 0 then goto purchase.material
#     if %asmCount1 > 0 then gosub purchase.assemble
#     if %asmCount2 > 0 then gosub purchase.assemble2
#	 goto purchase.material
	 return

lack.coin.exit:
     echo You need some startup coin to purchase stuff! Go to the bank and try again!
     put #parse Need coin
     exit
     
return.tools:
	 gosub automove $repair.room
     var toolcount 0
     eval toolstotal count("$MC_WORK.TOOLS","|")
	 gosub EMPTY_HANDS
return.tools1:
     if matchre ("$MC_WORK.TOOLS(%toolcount)", "%clerktools") then 
	 {
		gosub GET $MC_WORK.TOOLS(%toolcount)
          matchre next.tool ^What were you referring to?
          matchre next.tool \"Feel free to come back for your item any time,\"
          matchre not.a.tool \"This isn't the kind of thing I store
          matchre no.clerk.room \"You don't have enough space in your storage.  Clear some things out first.\"
          put put my $MC_WORK.TOOLS(%toolcount) on counter
          matchwait 10
		put #echo >log green MASTERCRAFT: Missing match in return.tools
     }
     #"
     math toolcount add 1
     if (%toolcount > %toolstotal) then return
     goto return.tools1

next.tool:
     math toolcount add 1
     if (%toolcount > %toolstotal) then return
     goto return.tools1

not.a.tool:
	 put #echo >log green MASTERCRAFT: $MC_WORK.TOOLS(%toolcount) is not a tool that can be stored - adjust your variables
     math toolcount add 1
     if (%toolcount > %toolstotal) then return
     goto return.tools1

no.clerk.room:
     put #echo >log green MASTERCRAFT: Ran out of room with clerk - adjust your variables
     return

##############################
#### EMPTY HANDS SUB
EMPTY_HANDS:
     pause 0.0001
     gosub STOW_RIGHT
     gosub STOW_LEFT
	return
     
ToolCheckRight:
	var tools $0
	if "$righthand" = "Empty" then
		{
		gosub GET MY %tools
          if !matchre("$righthand", "%tools") then gosub GET my %tools from my portal
		return
		}
	if !matchre("%tools", "$righthandnoun") then
		{
		gosub STOW_RIGHT
		gosub GET my %tools
          if !matchre("$righthand", "%tools") then gosub GET my %tools from my portal
		}
	return
	
ToolCheckLeft:
	var tools $0
	if "$lefthand" = "Empty" then
		{
		if (matchre("%tools", "tongs") && (%worn.tongs = 1)) then gosub HOLD my %tools
		else gosub GET MY %tools
          if !matchre("$lefthand", "%tools") then gosub GET my %tools from my portal
		return
		}
	if !matchre("%tools", "$lefthandnoun") then
		{
		gosub STOW_LEFT
		gosub GET my %tools
          if !matchre("$lefthand", "%tools") then gosub GET my %tools from my portal
		}
	return
#### KERTIGEN HALO HANDLING
#### INITIAL HALO HANDLING TO REMOVE TOOLS
HALO_REMOVE:
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_LEFT
     echo
     echo *** REMOVING TOOLS FROM HALO
     echo
     pause 0.1
     put look in my %tool.storage
     pause 2
     pause 2
     pause 0.1
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_RIGHT
     if !matchre("%HaloType", "NULL") then
          {
               gosub GET my %HaloType from my %tool.storage
               pause 0.5
               pause 0.5
               pause 0.1
               send pull halo
               wait
               pause 0.5
               put stow %HaloType
               pause 0.3
          }
     if !matchre("$righthand", "halo") then gosub GET my kertigen halo
     pause 0.1
     if !matchre("$righthand", "halo") then gosub GET my halo from my portal
     if !matchre("$righthand", "halo") then gosub GET my halo from my portal
     pause 0.1
     if (matchre("%discipline", "weapon|armor|blacksmith") || matchre("$roomname", "Forging Society")) then
          {
               gosub HALO_SHIFT $MC_HAMMER
               gosub HALO_SHIFT $MC_TONGS
               gosub HALO_SHIFT $MC_PLIERS
               gosub HALO_SHIFT $MC_BELLOWS
               gosub HALO_SHIFT $MC_STIRROD
               gosub HALO_SHIFT $MC_HAMMER
          }
     if (matchre("%discipline", "tailor") || matchre("$roomname", "Outfitting Society")) then
          {
               gosub HALO_SHIFT $MC_NEEDLES
               gosub HALO_SHIFT $MC_SCISSORS
               gosub HALO_SHIFT $MC_YARDSTICK
               gosub HALO_SHIFT $MC_AWL
               gosub HALO_SHIFT $MC_SLICKSTONE
          }
     if (matchre("%discipline", "carving|shaping|tinkering") || matchre("$roomname", "Engineering Society")) then
          {
               gosub HALO_SHIFT $MC_CHISEL
               gosub HALO_SHIFT $MC_SAW
               gosub HALO_SHIFT $MC_RASP
               gosub HALO_SHIFT $MC_RIFFLER
               gosub HALO_SHIFT $MC_SHAPER
               gosub HALO_SHIFT $MC_DRAWKNIFE
          }
     if (matchre("%discipline", "remedy") || matchre("$roomname", "Alchemy Society")) then
          {
               gosub HALO_SHIFT $MC_BOWL
               gosub HALO_SHIFT $MC_MORTAR
               gosub HALO_SHIFT $MC_STICK
               gosub HALO_SHIFT $MC_PESTLE
               gosub HALO_SHIFT $MC_SIEVE
               gosub HALO_SHIFT stick
          }
     if (matchre("%discipline", "aritf") || matchre("$roomname", "Enchanting Society")) then
          {
               gosub HALO_SHIFT $MC_BURIN
               gosub HALO_SHIFT $MC_LOOP
               gosub HALO_SHIFT $MC_BRAZIER
          }
     if matchre("$lefthand", "halo") then gosub STOW_LEFT
     if matchre("$righthand", "halo") then gosub STOW_RIGHT
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_RIGHT
     return
HALO_SHIFT:
     var shifting $0
     pause 0.001
     if !matchre("$righthand $lefthand", "(%LastHalo|halo)") then goto HALO_ERROR
     matchre HALO_SUCCESS ^Your Kertigen halo flares brightly
     matchre HALO_ERROR ^What tool did you want\?
     put turn my halo to %shifting
     matchwait 7
HALO_SUCCESS:
     pause 0.001
     echo
     echo *** Shifted Halo to %shifting
     echo
     pause 0.1
     pause 0.2
     if matchre("$lefthand", "%shifting") then var LastHalo $lefthandnoun
     if matchre("$righthand", "%shifting") then var LastHalo $righthandnoun
     pause 0.2
     pause 0.5
     echo ** LastHalo: %LastHalo
     pause 0.001
     send pull my kertigen halo
     pause 0.5
     pause 0.1
     var LastHalo halo
     pause 0.1
     if !matchre("$lefthand", "(halo|Empty)") then gosub STOW_LEFT
     if !matchre("$righthand", "(halo|Empty)") then gosub STOW_RIGHT
     return
HALO_ERROR:
     echo
     echo *** %shifting not found in Halo
     echo
     return
     
HALO_RESTACK:
     echo
     echo *** RE-ADDING TOOLS TO HALO
     echo
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_LEFT
     if (matchre("%discipline", "weapon|armor|blacksmith") || matchre("$roomname", "Forging Society")) then
          {
               if "%repair" = "on" then gosub check.tools
               gosub HALO_STACK $MC_HAMMER
               gosub HALO_STACK $MC_TONGS
               gosub HALO_STACK $MC_PLIERS
               gosub HALO_STACK $MC_BELLOWS
               gosub HALO_STACK $MC_STIRROD
          }
     if (matchre("%discipline", "tailor") || matchre("$roomname", "Outfitting Society")) then
          {
               if "%repair" = "on" then gosub check.tools
               gosub HALO_STACK $MC_NEEDLES
               gosub HALO_STACK $MC_SCISSORS
               gosub HALO_STACK $MC_YARDSTICK
               gosub HALO_STACK $MC_AWL
               gosub HALO_STACK $MC_SLICKSTONE
          }
     if (matchre("%discipline", "carving|shaping|tinkering") || matchre("$roomname", "Engineering Society")) then
          {
               if "%repair" = "on" then gosub check.tools
               gosub HALO_STACK $MC_CHISEL
               gosub HALO_STACK $MC_SAW
               gosub HALO_STACK $MC_RASP
               gosub HALO_STACK $MC_RIFFLER
               gosub HALO_STACK $MC_SHAPER
               gosub HALO_STACK $MC_DRAWKNIFE
          }
     if (matchre("%discipline", "remedy") || matchre("$roomname", "Alchemy Society")) then
          {
               if "%repair" = "on" then gosub check.tools
               gosub HALO_STACK $MC_BOWL
               gosub HALO_STACK $MC_MORTAR
               gosub HALO_STACK $MC_STICK
               gosub HALO_STACK $MC_PESTLE
               gosub HALO_STACK $MC_SIEVE
          }
     if (matchre("%discipline", "aritf") || matchre("$roomname", "Enchanting Society")) then
          {
               if "%repair" = "on" then gosub check.tools
               gosub HALO_STACK $MC_BURIN
               gosub HALO_STACK $MC_LOOP
               gosub HALO_STACK $MC_BRAZIER
          }
     pause 0.001
     put study my halo
     pause 0.5
     pause 0.2
     if matchre("$lefthand", "halo") then gosub STOW_LEFT
     if matchre("$righthand", "halo") then gosub STOW_RIGHT
     return
     
HALO_STACK:
     var item $0
     pause 0.001
     if !matchre("$righthand", "(%LastHalo|Empty|halo)") then gosub STOW_RIGHT
     if !matchre("$righthand", "(%LastHalo|halo)") then gosub GET my kertigen halo
     pause 0.1
     if !matchre("$righthand", "(%LastHalo|halo)") then gosub GET my halo from my portal
     pause 0.1
     gosub GET my %item
     pause 0.2
     if !matchre("$righthand $lefthand", "(?i)%item") then return
     send put my halo on my %item
     pause 0.5
     pause 0.3
     if matchre("$lefthand", "(?i)%item") then gosub STOW_LEFT
     return
     
WATERCUBE_TIMER:
     if !def(MC.WATERCUBE.TIME) then put #var MC.WATERCUBE.TIME $gametime
     put #var MC.WATERCUBE.LAST {#evalmath ($gametime - $MC.WATERCUBE.TIME)}
     if ($MC.WATERCUBE.LAST >= 900) then gosub WATERCUBE
     if ($MC.WATERCUBE.LAST < 900) then
          {
               echo
               echo *** Cube of Water still on cooldown!
               echo *** Last use: $MC.WATERCUBE.LAST seconds
               echo
          }
     return

WATERCUBE:
     pause 0.01
     echo
     echo *** USING ELEMENTAL CUBE OF WATER!
     echo
     put touch my $MC_WATERCUBE
     pause 0.2
     put #var MC.WATERCUBE.TIME $gametime
     return

GetHerbs:
     var startingRoom $roomid
     var herb $0
     echo
     echo #############
     echo # Stocking up on %herb
     echo # Attempting to Forage
     echo #############
     echo
     pause 0.6
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_LEFT
     ### TO THE BEST PLACE TO FIND HERBS NEARBY
     ## ALCHEMY ONLY IN CROSS/HAVEN/SHARD/RATHA/MUSPARI/FC
     if ($zoneid = 1) then gosub AUTOMOVE willow
     if ($zoneid = 30) then
          {    
               gosub AUTOMOVE egate
               gosub AUTOMOVE 4
          }
     if ($zoneid = 47) then gosub AUTOMOVE 68
     if ($zoneid = 67) then
          {    
               gosub AUTOMOVE east
               gosub AUTOMOVE campfire
          }
     if ($zoneid = 90) then gosub AUTOMOVE green
     if ($zoneid = 150) then gosub AUTOMOVE 45
     pause 0.8
     pause 0.1
     var HerbLoop 0
     var HerbsFound 0
ForageHerbs:
     echo
     echo *** Forage Count: %HerbLoop
     echo
     math add HerbLoop 1
     pause 0.2
     pause 0.2
     send forage %herb
     pause
     pause 0.5
     pause 0.2
     if matchre("$righthand", "%herb") then
          {
               math HerbsFound add 1
               gosub STOW_RIGHT
          }
     if matchre("$lefthand", "%herb") then
          {
               math HerbsFound add 1
               gosub STOW_LEFT
          }
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_LEFT
     if ((%HerbLoop > 6) && (%HerbsFound = 0)) then
          {
               echo *** DAMNIT NO HERBS FOUND!
               echo *** Maybe you just suck at Outdoorsmanship?
               echo *** Or is this a bad spot?
               return
          }
FORAGE_DONE:
     pause 0.1
     if matchre($zoneid, "(31|32|33)") then gosub automove river
     if matchre($zoneid, "(31|32|33)") then gosub automove river
     if ($zoneid = 66) then gosub automove east
     if ($zoneid = 66) then gosub automove east
     pause 0.2
     gosub AUTOMOVE %work.room
     pause 0.5
HerbProcess:
     pause 0.001
     put get my %herb
     pause 0.2
     pause 0.5
     pause 0.1
     if ("$righthand" != "Empty") then
          {
          get my %herb from my portal
          pause 0.6
          pause 0.3             
          }
     if ("$righthand" != "Empty") then return
HerbPress:
     put put my $righthandnoun in press
     pause 0.5
     pause 0.1
     put put my $righthandnoun in grinder
     pause 0.5
     pause 0.1
     pause 0.2
     if ("$righthand" != "Empty") then gosub STOW_RIGHT
     if ("$lefthand" != "Empty") then gosub STOW_LEFT
     goto HerbProcess

SWAP:
     pause 0.0001
     send swap
     pause 0.1
     pause 0.3
     return
     
Action_My:
var command analyze $MC.order.noun on my brazier
goto Action_1
Action:
var command $0
Action_1:
matchre Action_1 ^\.\.\.wait|type ahead
matchre Analyze ^That tool does not seem suitable for that task\.
matchre Analyze appear suitable for working
matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
matchre Action_My ^Analyze what\?
send %command
matchwait 10
var got.analyze NO
return

Analyze:
     var got.analyze YES
	if (%society.type = Enchanting) then
          {
               if matchre("$MC_BRAZIER", "(?i)NULL") then
                    {
                         gosub Action analyze $MC.order.noun on brazier
                    }
               else gosub Action analyze $MC.order.noun on my brazier
          }
     else gosub Action analyze $MC.order.noun
	return

return

     ### ORDERING SUB, FOR SHOPS
ORDER:
     var Order $0
     var LOCATION ORDER_1
     ORDER_1:
     pause 0.1
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre ORDER_1 ^The attendant says\,\s*\"You (can|may) purchase .*\.\s*Just order it again and we'll see it done\!\" 
     matchre fullhands ^You realize your hands are full, and stop\.
     matchre RETURN ^The attendant takes some coins from you and hands you .*\.
     matchre RETURN pay the sales clerk
     matchre RETURN ^\[You may purchase items from the shopkeeper with ORDER
     if %need.coin = 1 then
        {
        var temp.room $roomid
        gosub lack.coin
        goto ORDER_1
        }
     if matchre("%Order", "\d+") then send order %Order
     if !matchre("%Order", "\d+") then 
		{
		if matchre("%Order", "\w+") then send buy %Order
		else send Order
		}
     matchwait 15
     if %need.coin = 1 then
        {
        var temp.room $roomid
        gosub lack.coin
        goto ORDER_1
        }
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN ORDER! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Order = %Order
     put #log $datetime MISSING MATCH IN ORDER! (mc_include.cmd)
     return

fullhands:
	gosub EMPTY_HANDS
	goto ORDER_1
	
WAIT:
     pause 0.0001
     pause 0.1
     if (!$standing) then put STAND
     goto %LOCATION
 
#### PUT SUB
PUT:
     var Command $0
     var LOCATION PUT_1
     pause 0.0001
     PUT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre PUT_STOW ^You need a free hand
     matchre WAIT ^\[Enter your command again if you want to\.\]
     matchre RETURN ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre RETURN ^You sit down
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^Please rephrase that command\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^.* what\?
     matchre RETURN ^You find a hole
     matchre RETURN ^You (?:hand|touch|push|move|put|tap|drop|place|toss|set|swap|add) .*(?:\.|\!|\?)
     matchre RETURN ^Your .*\.
     matchre RETURN ^You don't have a .* coin on you\!\s*The .* spider looks at you in forlorn disappointment\.
     matchre RETURN ^The .* spider turns away\, looking like it's not hungry for what you're offering\.
     matchre RETURN ^Brother Durantine nods slowly\.
     matchre RETURN ^Durantine waves a small censer over a neatly-wrapped package and intones a short prayer before he hands it to you\.
     matchre RETURN ^After a moment\, .*\.
     matchre RETURN ^Quietly touching your lips with the tips of your fingers as you kneel\, you make the Cleric's sign with your hand\.
     matchre RETURN ^Maybe you should stand up\.
     matchre RETURN ^You sense a successful empathic link has been forged|^Touch what|^I could not find
     matchre RETURN ^The clerk counts out .*\.
     matchre RETURN ^A clerk says politely
     matchre RETURN ^A clerk shakes his head
     matchre RETURN ^The .+ has suffered too much damage and needs to be repaired at a crafting repair shop
     matchre RETURN ^The .* is not damaged enough to warrant repair\.
     matchre RETURN ^There is no more room in .*\.
     matchre RETURN ^There is nothing in there\.
     matchre RETURN ^In the .* you see .*\.
     matchre RETURN ^Searching methodically
     matchre RETURN ^This spell cannot be targeted\.
     matchre RETURN ^You cannot figure out how to do that\.
     matchre RETURN ^You will now store .* in your .*\.
     matchre RETURN ^You.*analyze
     matchre RETURN ^You lay your hand upon
     matchre RETURN ^You glance down .*\.
     matchre RETURN ^You glance heavenward
     matchre RETURN ^You turn .*\.
     matchre RETURN ^You chatter away\.\.\.
     matchre RETURN ^You are now
     matchre RETURN ^You search
     matchre RETURN ^You get
     matchre RETURN ^You have nothing to 
     matchre RETURN ^There isn't any more room in .* for that\.
     matchre RETURN ^You are already focusing your appraisal on a subject\.
     matchre RETURN ^You are already under the effects of an appraisal focus\.
     matchre RETURN ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
     matchre RETURN ^You can't seem to focus on that\.\s*Perhaps you're too mentally tired from researching similar principles recently\.
     matchre RETURN ^\s*LINK ALL CANCEL\s*\- Breaks all links
     matchre RETURN (bundle them with your logbook and then give|you trace|you just received a work order|You hand|You slide|You place)
     matchre RETURN ^(You have no idea how to craft|The book is already turned|You turn your book|You realize you have items bundled with the logbook)
     matchre RETURN (You measure out|You carefully break off|^You hand|\"There isn't a scratch on that|\"I don't repair those here\.)
     matchre RETURN (Just give it to me again if you want|completely undamaged and does not need repair|not damaged enough to warrant repair)
     matchre RETURN ^(You find your jar|The (\S+) can only hold)
     matchre RETURN ^(You .*open|You .*close|That is already open|That is already closed)
     matchre RETURN ^You count out
     # matchre RETURN ^
     matchre RETURN ^\s*Encumbrance\s*\:
     send %Command
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Command = %Command
     put #log $datetime MISSING MATCH IN PUT (mc_include.cmd)
     return
     
READ:
     var LOCATION READ
     var Read $0
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre READ_RETURN (?<!Page).*Page (\d+): %Read
     send read my book
     matchwait
READ_RETURN:
	 var page $1
	 return
     
     
STUDY:
     var Study $0
     var LOCATION STUDY_1
     pause 0.0001
     STUDY_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     match STUDY_1 You begin
     match STUDY_1 You continue studying the
     match STUDY_1 You continue to study
     match RETURN You take on a studious look
     match STUDY_END Why do you need to study this chart again?
     matchre STUDY_NEXT (^With|^In) a sudden moment of clarity
     matchre GET_BOOK ^But you are not holding it
     matchre GET_BOOK ^But you're not holding it 
     matchre RETURN You study|You scan|You notate|You review
     matchre RETURN ^You now feel ready to begin the crafting process.
     send study %Study
     matchwait

GET_BOOK:
	gosub GET %discipline book
	goto STUDY_1
#### DOUBLE PUT SUB
PUT_IT:
     var PutIt $0
     var LOCATION PUT_IT_1
     pause 0.0001
     PUT_IT_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
	 matchre RETURN ^That's too heavy to go in there\!
     matchre RETURN ^With a flick
     matchre RETURN ^You (?:put|drop) .*\.
     matchre RETURN ^Please rephrase that command\.
     matchre RETURN ^.* what\?
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?     
     matchre RETURN ^The (\S+) can only hold
     matchre RETURN ^Perhaps you should
     matchre TRASH ^This appears too far altered to enchant|^The %rawmat is already enchanted|^You have no idea how to craft
     matchre BAG_FULL no matter how you arrange it
     matchre PUT_IT_1 ^\[Putting an item on the brazier begins the enchanting process
     send put %PutIt
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PUT_IT! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime PutIt = %PutIt
     put #log $datetime MISSING MATCH IN PUT_IT (mc_include.cmd)
     return
     
TRASH:
     if matchre("$roomobjs", "(bucket|bin)") then
		{
		if !matchre("%rawmat", "%all.tools") then gosub PUT_IT %rawmat in bin
		else goto endearly
		}
     else 
	    {
		if !matchre("%rawmat", "%all.tools") then gosub PUT drop %rawmat
		else goto endearly
		}
     gosub clear
     goto start.enchant
     
BAG_FULL:
    gosub combine.check "%main.storage" %order.pref
    #send open $MC_REMNANT.STORAGE
    #gosub combine.check "$MC_REMNANT.STORAGE" %order.pref
    #send close $MC_REMNANT.STORAGE
    pause 1    
    RETURN
	
#### GET SUB
GET:
     var Get $0
     var LOCATION GET_1
     pause 0.0001
     GET_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre HOLD_1 ^But that is already in your inventory\.
     matchre RETURN ^You get .*\.
     matchre RETURN ^You pick up .*\.
     matchre RETURN ^You carefully remove .* from the bundle\.
     matchre RETURN ^You are already holding that\.
     matchre RETURN ^Get what\?
     matchre RETURN ^You grab .*(?:\.|\!|\?)
     matchre RETURN ^As best it can\, .* moves in your direction\.
     matchre RETURN ^You need a free hand to pick that up\.
     matchre RETURN ^That can't be picked up\.
     matchre RETURN ^Please rephrase
     matchre RETURN ^Analyze what
     matchre UNTIE ^You pull at it|^You pull at|^You should untie
     matchre GET_DOUBLECHECK ^I could not find what you were referring to\.
     matchre GET_DOUBLECHECK ^What were you referring to\?
     matchre GET_DOUBLECHECK ^Perhaps you should
	matchre WRONG_ITEM ^That is far too dangerous to remove
     send get %Get
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN GET! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Get = %Get
     put #log $datetime MISSING MATCH IN GET (mc_include.cmd)
     return
GET_DOUBLECHECK:
     var LOCATION GET_2
     pause 0.0001
     put look in my portal
     pause 0.001
     pause 0.001
     pause 0.001
     GET_2:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre HOLD_1 ^But that is already in your inventory\.
     matchre RETURN ^You get .*\.
     matchre RETURN ^You pick up .*\.
     matchre RETURN ^You carefully remove .* from the bundle\.
     matchre RETURN ^You are already holding that\.
     matchre RETURN ^Get what\?
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^You grab .*(?:\.|\!|\?)
     matchre RETURN ^As best it can\, .* moves in your direction\.
     matchre RETURN ^You need a free hand to pick that up\.
     matchre RETURN ^Perhaps you should
     matchre UNTIE ^You pull at it|^You pull at|^You should untie
	matchre WRONG_ITEM ^That is far too dangerous to remove
     send get %Get from my portal
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN GET2! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Get = %Get
     put #log $datetime MISSING MATCH IN GET2 (mc_include.cmd)
     return

UNTIE:
	send untie %Get
	var BELTTOOLS 1
	return
	
WRONG_ITEM:
	matchre WRONG_ITEM ^\.\.\.wait|^Sorry\,
	send get my %Get
	matchwait 5
	return
	
 
#### HOLD SUB
HOLD:
     var Get $0
     var LOCATION HOLD_1
     pause 0.0001
     HOLD_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre WAIT ^You struggle with .* great weight but can't quite lift it\!
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre RETURN ^You sling .*\.
     matchre RETURN ^You get .*\.
     matchre RETURN ^You take .*\.
     matchre RETURN ^You pull .*\.
     matchre RETURN ^You remove .*\.
     matchre RETURN ^You loosen .*\.
     matchre RETURN ^You remove .* from your belt\.
     matchre RETURN ^You are already holding that\.
     matchre RETURN ^Get what\?
     matchre RETURN ^Hold hands with whom
     matchre RETURN ^You work your way out of
     matchre RETURN ^You aren't
     matchre RETURN ^I could not find what you were referring to\.
     matchre RETURN ^What were you referring to\?
     matchre GET_1 ^Perhaps you should be holding that
     send hold %Get
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN HOLD! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Get = %Get
     put #log $datetime MISSING MATCH IN HOLD (mc_include.cmd)
     return
 
#### STOW SUB
STOW:
     var Stow $0
     var LOCATION STOW_1
     pause 0.0001
     STOW_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre WEAR_CHECK ^.* is too long to fit in .*\.
     matchre RETURN ^You put .*\.
     matchre RETURN already in your inventory
     matchre RETURN ^You open your pouch and put .* inside\, closing it once more\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Stow what\?  Type 'STOW HELP' for details\.
     matchre STOW_LEFT You need a free hand
     matchre STOW.UNLOAD ^You should unload
     send stow %Stow
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN STOW! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Stow = %Stow
     put #log $datetime MISSING MATCH IN STOW (mc_include.cmd)
     return
     
STOW_LEFT:
     if "$lefthandnoun" != "" then
          {
               if matchre("%tiedtools", "$lefthand") then 
                    {
					pause .05
					pause .5
                    send tie #$lefthandid to my $MC_TOOLBELT_%society.type
                    }
               else 
                         {
						if matchre("%alltools", "$lefthandnoun") then 
							{
								gosub PUT_IT #$lefthandid in my %tool.storage
							}
						else
							{
								gosub PUT_IT #$lefthandid in my %main.storage
							}
					}
          }
	return
     
STOW_RIGHT:
     if "$righthandnoun" != "" then
          {
               if matchre("%tiedtools", "$righthand") then 
                    {
					pause .05
					pause .5
                    send tie my $righthandnoun to my $MC_TOOLBELT_%society.type
                    }
               else 
                         {
                              if matchre("$righthand", "crafting book") then
                                   {
                                        put wear book
                                        pause 0.5
                                   }
						if matchre("%alltools", "$righthandnoun") then 
							{
								gosub PUT_IT #$righthandid in my %tool.storage
							}
						else
							{
								gosub PUT_IT #$righthandid in my %main.storage
							}
					}
          }
	return
     
		
#### WEAR SUB
WEAR_CHECK:
          if matchre("$righthand", "stone quarterstaff|stone lance") then 
		{
		put drop $righthand
		return
		}
		goto WEAR_1
WEAR:
     var Stow $0
     var LOCATION WEAR_1
     pause 0.0001
     WEAR_1:

     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre WEBBED ^You can't do that while entangled in a web
     matchre STUNNED ^You are still stunned
     matchre STOW_1 ^You can't wear that\!
     matchre STOW_1 ^You can't wear any more items like that\.
     matchre STOW_1 ^This .* can't fit over the .* you are already wearing which also covers and protects your .*\.
     matchre RETURN ^You (?:sling|put|slide|slip|attach|work|strap) .*\.
     matchre RETURN ^You are already wearing that\.
     matchre RETURN ^What were you referring to\?
     matchre RETURN ^Wear what\?
     send wear %Stow
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN WEAR! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Stow = %Stow
     put #log $datetime MISSING MATCH IN WEAR (mc_include.cmd)
     return
     
#### SPELL CASTING
PREPARE:
     var Prepare $0
     var LOCATION PREPARE_1
     pause 0.0001
PREPARE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
	matchre SPELL_CAST_RETURN ^But you've already prepared the
     matchre SPELL_CAST_RETURN ^You have already fully prepared
     matchre SPELL_CAST_RETURN ^You are already preparing the .* spell\!
     matchre SPELL_CAST_RETURN ^You begin chanting .* to invoke the .* spell\.
     matchre SPELL_CAST_RETURN ^You mutter .* to yourself while preparing the .* spell\.
     matchre SPELL_CAST_RETURN ^With .* movements you prepare your body for the .* spell\.
     matchre SPELL_CAST_RETURN ^You raise your .* skyward\, chanting the .* of the .* spell\.
     matchre SPELL_CAST_RETURN ^You rock back and forth\, humming tunelessly as you invoke the .* spell\.
     matchre SPELL_CAST_RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
     matchre SPELL_CAST_RETURN ^Your eyes darken to black as a starless night as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^You close your eyes and breathe deeply, gathering energy for the .* spell\.
     matchre SPELL_CAST_RETURN ^You trace an arcane sigil in the air\, shaping the pattern of the .* spell\.
     matchre SPELL_CAST_RETURN ^Your eyes darken to black as a starless night as you prepare the .* spell\.
	matchre SPELL_CAST_RETURN ^You trace a geometric sigil in the air, shaping the pattern of the .* spell\.
     matchre SPELL_CAST_RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
     matchre SPELL_CAST_RETURN ^A soft breeze surrounds your body as you confidently prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^Tiny tendrils of lightning jolt between your hands as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^Heatless orange flames blaze between your fingertips as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^Entering a trance-like state\, your hands begin to tremble as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^You adeptly sing the incantations for the .* spell\, setting the words to a favorite tune\.
     matchre SPELL_CAST_RETURN ^You bring your hand slowly to your forehead as you begin chanting the words of the .* spell\.
     matchre SPELL_CAST_RETURN ^Icy blue frost crackles up your arms with the ferocity of a blizzard as you begin to prepare the .* spell\!
     matchre SPELL_CAST_RETURN ^You have to strain to harness the energy for this spell, and you aren't sure you can get enough to cast it\.
     matchre SPELL_CAST_RETURN ^You giggle to yourself as you move through the syncopated gestures that accompany the preparations of the .* spell\.
     matchre SPELL_CAST_RETURN ^Darkly gleaming motes of sanguine light swirl briefly about your fingertips as you gesture while uttering the .* spell\.
     matchre SPELL_CAST_RETURN ^As you begin to solemnly intone the .* spell a blue glow swirls about forming a nimbus that surrounds your entire being\.
     matchre SPELL_CAST_RETURN ^Your skin briefly withers and tightens\, becoming gaunt as the energies of the .* spell begin to build up through your body\.
     matchre SPELL_CAST_RETURN ^You trace an intricate rune in the air with your finger\, illusory lines lingering several seconds as you prepare the .* spell\.
     matchre SPELL_CAST_RETURN ^You begin reciting a solemn incantation\, causing familiar patterns of geometric shapes to circle your hand as the .* spell forms\.
     matchre SPELL_CAST_RETURN ^You take up a handful of dirt in your palm to prepare the .* spell\.  As you whisper arcane words\, you gently blow the dust away and watch as it becomes swirling motes of glittering light that veil your hands in a pale aura\.
     matchre SPELL_CAST_RETURN ^You recall the exact details
     matchre SPELL_CAST_RETURN ^But you've already prepared the Chaos symbiosis
     matchre SPELL_CAST_DONE ^What do you want to prepare\?
     matchre SPELL_CAST_DONE ^That is not a spell you can cast\.
     matchre SPELL_CAST_DONE ^You wouldn't have the first clue how to do that\.
     matchre SPELL_CAST_DONE ^You stop\, convinced that there's no way to control that much mana\.
     matchre SPELL_CAST_FAIL ^You have to strain to harness the energy for this spell, and you aren't sure you can get enough to cast it\.
     send prepare %Prepare
     matchwait 15
     put #echo >$Log Crimson $datetime *** MISSING MATCH IN PREPARE! (mc_include.cmd) ***
     put #echo >$Log Crimson $datetime Prepare = %Prepare
     put #log $datetime MISSING MATCH IN PREPARE! (mc_include.cmd)
     goto SPELL_CAST_RETURN

SPELL_CAST_DONE:
     put #queue clear
     put #var symb 0
     pause 0.0001
     return
SPELL_CAST_FAIL:
     gosub RELEASE MANA
SPELL_CAST_RETURN:
     pause 0.0001
     return
RELEASE:
     var Release $0
     var LOCATION RELEASE_1
     pause 0.0001
     RELEASE_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre RETURN ^\s*Encumbrance\s*\:
     put -release %Release;-encumbrance
     matchwait
     
SPELL_CAST_TARGET:
     var Target $0
     var LOCATION SPELL_CAST_TARGET_1
     pause 0.0001
SPELL_CAST_TARGET_1:
     matchre WAIT ^\.\.\.wait|^Sorry\,
     matchre STUNNED ^You are still stunned
     matchre WEBBED ^You can't do that while entangled in a web
     matchre IMMOBILE ^You don't seem to be able to move to do that
     matchre SPELL_CAST_DONE ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?
     matchre SPELL_CAST_DONE ^You gesture
     matchre SPELL_CAST_DONE ^Focus the power of justice on whom\?
     matchre SPELL_CAST_FAIL ^You don't have a spell prepared\!
     matchre SPELL_CAST_FAIL ^Your concentration slips for a moment\, and your spell is lost\.
     put -cast %Target;-2 gesture
     matchwait

#### RETURNS
RETURN_CLEAR:
     pause 0.0001
     put #queue clear
     pause 0.0001
     return
RETURN:
     pause 0.0001
     return     
	
endinclude: