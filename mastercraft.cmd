#debug 10
# Mastercraft by Dasffion
# Based on MasterCraft - by the player of Jaervin Ividen
# A crafting script suite...
# many versions later - Latest updates 02/07/2021
#
# Script Usage: .mastercraft                                        --to only do one work order
#                    .mastercraft <no. of orders>                    --to perform more than one
#                    .mastercraft <no. of orders> <difficulty>     --to ask for a different difficulty than you have set in your character profile.
#
#   Mastercraft takes the tedium out of workorders, and works in practically every society for practically every craft. It will get and
#     turn in orders, buy extra parts, repair tools, manage materials, check item quality, and will even reduce your order difficulty if
#     you fail the item too often.
#
#     There are a few things to note in using this script, however:
#     1. You must have all required tools and books in your crafting bag for the craft you choose (repairing also requires oil and brush to be
#        available).
#     2. Workorders can only be automated within societies. Individual scripts can be run elsewhere if you desire, but part purchasing and order
#        turn-in will not be automatic.
#     3. Make sure your stock materials (specifically ingots) are managed in sizes your character can lift. If he can't pick up an ingot, I don't
#      know how you'll be able to cut it down to a more manageable size.
#     4. If you have less than 50 Forging skill, your analyzes may not pick up item quality or ingot size. To do orders with low forging skill,
#        be sure to have a yardstick to measure with. Your character will otherwise not be able to tell if he has enough material to actually complete the order.        
#     5. Last but not least, don't change the scriptfile names (ie mastercraft.cmd to mc.cmd) unless you want to parse through them yourself and edit
#        the script calls. Each subscript is called by name here and runs as a **second, separate script.** This allows for each subscript to be
#        used standalone. Also, some subscripts (pound, carve, knit, sew, etc.) check to see if Mastercraft.cmd is running before continuing certain
#        tasks. Be careful when renaming scriptfiles.
#      
#     Be sure to setup your character's crafting profile in **MC_SETUP.CMD BEFORE USING THESE SCRIPTS.** There are some things scripting
#     cannot do for you, such as make personal decisions.
#
#     Included in this suite:
#          mastercraft.cmd
#          mc_include.cmd
#          mc_pound.cmd
#          mc_sew.cmd
#          mc_knit.cmd
#          mc_carve.cmd
#          mc_enchant.cmd
#          mc_shape.cmd
#          mc_smelt.cmd
#          mc_grind.cmd
#          mc_weave.cmd
#          mc_spin.cmd
#          mc_tinker.cmd
#     
#     Each script can be run completely standalone from Mastercraft if you want to create multiple items or just individual orders. Using them
#     as such will require you to be responsible for your own material management and quality control. Be sure to read the beginning section for
#     each script if you intend to use it standalone.
#
# Happy Crafting!

#debug 10
include MC_SETUP.cmd
include mc_include.cmd


#TO-DO LIST
#Write up stone material management. Sift through deeds to find appropriate size and workability.
#Look at way to change thread in sew based on thickness
#Tempering, balancing, honing, sealing, reinforcing scripts.

#1.3
#     Added tinkering. If you do not want to press mechanisms bring your own.
#     Added logic for not taking work orders with more than 70 lumber due to weight and stack issues
#     Added study earlier in the process to determine difficulty. This will prevent buying mats for a work order that you will abandon
#     Added SmallOrders global variable, this will prevent you from getting orders that will require you to smelt (i.e. more than 5 volume per piece)
#     Added logic for buying the correct number of materials and not over buying.


#Carving
#-stone (needs material/deed management, currently not supported)


#Bug Fixes v 0.1.7 - Shroom
# Fixed several match tables
# Added hard double check for 'get <item> in my portal' when regular GET doesn't work (for Eddy bags)
# Added Support for HALOS - global MC_KERTIGEN.HALO in MC_Setup
# IF HALO IS ON - Should attempt getting Halo and pulling all the tools off it before the crafting session
# When finished with crafting, should put all the tools back on the Halo
# Added support to work with the Master Kertigan Crafting Books

#Bug Fixes v 0.1.6
#Added bone armor to carving.
#Removed oil purchasing from grind.cmd, is now handled in mastercraft.cmd.
#Smoothed out some responses in carve.cmd, including some analyzes.
#Polish ordering now gets your item back from the correct bag, and should work fine for workorders.
#Will now check your bag for oil, pins, or polish, depending on society/craft before starting.
#Smoothed out pins/thread ordering in sew.cmd.
#Added support for untieing expired items from a logbook.
#Added support for adjustable and wearable tongs in pound.cmd (to come later to smelt.cmd)
#Fixed error in pound.cmd that wouldn't always leave product in hand when finished.
#Also fixed a bellows call after analyzing in pound.cmd.




     
####################################################################################################
#### Various variables and actions needed for script functionality. Most are just initializing for later manipulation.
####################################################################################################
     var repeat 0
     if_1 var repeat %1
     var full.order.noun
     var coin.intake 0
     var orders.completed 0
	 var gottools 0
     var tool.gone 0
     var oil.gone 0
	 var polish.gone 0
	 var stain.gone 0
     var brush.gone 0
     var fail2 0
     var tool.repair 0
     var order.type 0
     var diff.change 0
     var ordinal zeroth|first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|eleventh
     var countarray zero|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eightteen|nineteen|twenty|twenty-one|twenty-two|twenty-three|twenty-four|twenty-five|twenty-six|twenty-seven|twenty-eight|twenty-nine|thirty
     var assemble NULL
     var assemble2 NULL
     var difficultytry add 0
     var NOWO $MC_%society.type_NOWO
     gosub clearvolume
	 var all.tools $MC_HAMMER|$MC_TONGS|$MC_SHOVEL|$MC_BELLOWS|$MC_STIRROD|$MC_PLIERS|$MC_NEEDLES|$MC_SCISSORS|$MC_SLICKSTONE|$MC_AWL|$MC_CHISEL|$MC_RIFFLER|$MC_RASP|$MC_SAW|$MC_DRAWKNIFE|$MC_SHAPER|$MC_CLAMP|$MC_TINKERTOOL|$MC_CARVINGKNIFE|$MC_BOWL|$MC_MORTAR|$MC_PESTLE|$MC_STICK|$MC_SIEVE|$MC_LOOP|$MC_BURIN|$MC_IMBUE.ROD|$MC_BRAZIER

      
     if matchre("%discipline", "weapon|blacksmith") then var work.tools $MC_HAMMER|$MC_TONGS|$MC_SHOVEL|$MC_BELLOWS|$MC_STIRROD
     if "%discipline" = "armor" then var work.tools $MC_HAMMER|$MC_TONGS|$MC_SHOVEL|$MC_BELLOWS|$MC_STIRROD|$MC_PLIERS
     if "%discipline" = "tailor" then
          {
               if "%order.pref" = "cloth" then var work.tools $MC_NEEDLES|$MC_SCISSORS|$MC_SLICKSTONE
               if "%order.pref" = "leather" then var work.tools $MC_NEEDLES|$MC_SCISSORS|$MC_SLICKSTONE|$MC_AWL
               if "%order.pref" = "yarn" then var work.tools $MC_NEEDLES
          }
     if "%discipline" = "carving" then
          {
               if "%order.pref" = "stone" then var work.tools $MC_CHISEL|$MC_RIFFLER|$MC_RASP
               if "%order.pref" = "bone" then 
                    {
                         var order.pref stack
                         var work.tools $MC_SAW|$MC_RIFFLER|$MC_RASP
                    }
          }
     if "%discipline" = "shaping" then
          {
               var work.tools $MC_DRAWKNIFE|$MC_SHAPER|$MC_RASP|$MC_CLAMP|$MC_CARVINGKNIFE
          }
     if "%discipline" = "tinkering" then 
          {
               var work.tools $MC_DRAWKNIFE|$MC_SHAPER|$MC_CLAMP|$MC_PLIERS|$MC_TINKERTOOL|$MC_CARVINGKNIFE
          }
     if "%discipline" = "remed" then
          {
               var work.tools $MC_BOWL|$MC_MORTAR|$MC_PESTLE|$MC_STICK|$MC_SIEVE
          }
     if "%discipline" = "artif" then
          {
               var work.tools $MC_LOOP|$MC_BURIN|$MC_IMBUE.ROD|$MC_BRAZIER
          }
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
	 if (matchre("(%clerktools)", "%work.tools") && (%gottools = 0)) then gosub get.tools
	 var gottools 1
      put #var MC_WORK.TOOLS %work.tools
##############################
#
#  Obtaining an order
#

##############################

check.for.order:
     if matchre("$MC_KERTIGEN.HALO", "(?i)ON") then gosub HALO_REMOVE
     if !matchre("$righthand|$lefthand", "logbook") then
          {
               gosub EMPTY_HANDS
               gosub GET my %society.type logbook from my %main.storage
               pause 0.2
          }
     if !matchre("$righthand|$lefthand", "logbook") then
          {
               gosub EMPTY_HANDS
               gosub GET my %society.type logbook
          }
     matchre new.order is not currently tracking|has expired
     matchre turn.in This work order appears to be complete
     matchre time.order You must bundle and deliver (\d+) more within the next (\d+)
     put read my %society.type logbook
     matchwait

untie.order:
     if !matchre("$righthand", "logbook") then
          {
               if matchre("$righthand", "%alltools") then gosub PUT_IT $righthandnoun in my %tool.storage
               else gosub PUT_IT $righthandnoun in my %main.storage
          }
     if !matchre("$lefthand", "logbook") then
          {
               if matchre("$lefthand", "%alltools") then gosub PUT_IT $lefthandnoun in my %tool.storage
               else gosub PUT_IT $lefthandnoun in my %main.storage
          }
     gosub untie.early
     goto new.order

time.order:
     evalmath avg.time floor($2/$1)
     if %avg.time < 12 then goto new.order
     goto identify.order

new.order:
     var fail 0
     var diff.change 0
     if %difficultytry > 4 then
          {
               gosub diff.change
               var difficultytry 0
          }
     gosub find.master
     if !matchre("$righthand|$lefthand", "logbook") then
          {
               gosub EMPTY_HANDS
               gosub GET my %society.type logbook from my %main.storage
          }
     if !matchre("$righthand|$lefthand", "logbook") then
          {
               gosub EMPTY_HANDS
               gosub GET my %society.type logbook
          }
     matchre untie.order ^You realize you have items
     matchre new.order ^To whom are you|need to be holding a \S+ work order logbook
     matchre new.order.wait but you just received a work order
     matchre identify.order this is an order for
     send ask %master for %work.difficulty %discipline work
     matchwait

new.order.wait:
     echo Pausing 2 seconds to get another order.
     pause 2
     goto new.order
     
##############################
#
#  Setting the Crafting Item
#
##############################

identify.order:
     if !$MC_END.EARLY then
          {
               if %order.quantity > $MC_MAX.ORDER then goto new.order
               if %order.quantity < $MC_MIN.ORDER then goto new.order
          }
     

     if "%discipline" = "weapon" then
          {     
               matchre chapter.1 This logbook is tracking a work order requiring you to craft (a metal dagger|a metal kythe|a metal carving knife|a metal oben|a metal briquet|a metal koummya|a metal stiletto|a metal rapier|a metal poignard|a metal pasabas|a metal pugio|a metal thrusting blade|a metal short sword|a metal scimitar|a metal katar|a metal sabre|a metal misericorde|a metal hanger|a metal kris|a metal parang|a metal takouba|a metal curlade|a metal jambiya|a metal adze|a metal leaf blade sword|a metal sashqa|a metal telek|a metal mambeli|a metal nehlata|a metal gladius|a metal falcata|a metal baselard|a metal throwing dagger|a light throwing axe|a metal dart|a metal hand axe|a metal foil|a metal hatchet|a metal sunblade|a metal cutlass|a metal kasai|a metal shotel|a metal dao) from any material\.
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a metal broadsword|a metal namkomba|a metal arzfilt|a metal hunting sword|a metal kudalata|a metal nimsha|a metal spatha|a metal back-sword|a metal longsword|a metal recade|a metal round axe|a metal battle axe|a metal nehdalata|a metal robe sword|a metal condottiere|a metal falchion|a metal cinquedea|a metal schiavona|a metal abassi|a metal hurling axe|a metal dagasse) from any material\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (a metal two-handed sword|a metal kaskara|a metal warring axe|a metal shh'oi'ata|a metal marauder blade|a metal greatsword|a metal greataxe|a metal flamberge|a metal claymore|a metal periperiu sword|a metal karambit|a metal double axe|a metal twin-point axe|a metal igorat axe) from any material\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a metal cudgel|a metal bola|a metal prod|a metal cuska|a metal cosh|a metal bulhawf|a metal gavel|a metal komno|a metal bludgeon|a metal hhr'tami|a metal hand mallet|a spiked metal club|a metal scepter|a spiked metal hammer|a metal zubke|a spiked metal mace|a spiked metal gauntlet|a metal marlingspike|a short metal hammer|a metal mace|a metal club|a metal belaying pin|a metal hand mace|a metal war hammer|a ridged metal gauntlet|a metal boomerang|a metal garz|a metal boko|a metal war club|a flanged metal mace|a metal mallet|a metal k'trinni sha-tai|a metal throwing club) from any material\.
               matchre chapter.5 This logbook is tracking a work order requiring you to craft (a metal horseman's flail|a metal morning star|a heavy metal chain|a spiked metal hara|a metal ball and chain|a spiked ball and chain|a metal greathammer|a metal ukabi|a heavy metal mace|a metal throwing hammer|a metal imperial war hammer|a metal throwing mallet|a double-headed hammer|a hurlable war hammer|a metal hara|a metal hhr'ata|a heavy metal mallet|a metal sledgehammer) from any material\.
               matchre chapter.6 This logbook is tracking a work order requiring you to craft (a metal footman's flail|a metal two-headed hammer|a metal akabo|a metal maul|a double-sided ball and chain|a heavy sledgehammer|a metal war mattock|a metal dire mace|a metal vilks kodur|a giant metal mallet) from any material\.
               matchre chapter.7 This logbook is tracking a work order requiring you to craft (a metal javelin|a two-pronged halberd|a light metal spear|a metal khuj|a metal scythe|a metal partisan|a metal bardiche|a metal military fork|a metal lochaber axe|a metal duraka skefne|a metal guisarme|a metal pole axe|a metal halberd|a metal fauchard|a metal tzece|a metal ngalio|a metal coresca|a metal pike|a metal awgravet ava|a metal lance|a metal hunthsleg|a metal spetum|a metal allarh|a metal ranseur|a metal spear|a metal ilglaiks skefne|a metal glaive) from any material\.
               matchre chapter.8 This logbook is tracking a work order requiring you to craft (a metal cane|some metal elbow spikes|a metal nightstick|some metal knee spikes|a metal quarterstaff|some spiked metal knuckles|some metal knuckles|some metal hand claws|a metal pike staff) from any material\.
               matchre chapter.9 This logbook is tracking a work order requiring you to craft (a metal throwing spike|a metal boarding axe|a metal bastard sword|a metal half-handled riste|a metal war sword|a thin-bladed metal fan|a metal broadaxe|a metal riste|a metal bar mace|a thick-bladed metal fan|a metal splitting maul) from any material\.
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "armor" then
          {
               matchre chapter.1 This logbook is tracking a work order requiring you to craft (a metal ring mask|a metal ring vest|a metal ring aventail|a metal ring mantle|some metal ring gloves|a metal ring lorica|a metal chain mask|some metal mail vambraces|a metal ring cap|some metal chain sleeves|a metal chain aventail|a metal mail tasset|some metal chain gloves|a metal chain vest|a metal mail mask|a metal chain mantle|a metal chain cap|a metal chain lorica|a metal mail aventail|a metal ring robe|a metal ring helm|a metal ring shirt|some metal ring greaves|a mail balaclava|a metal mail cap|some metal mail sleeves|a metal chain helm|a metal mail vest|a metal ring balaclava|a metal mail mantle|some metal chain greaves|a metal mail lorica|some metal ring vambraces|a metal chain robe|a metal ring tasset|a metal chain shirt|some metal mail gloves|a metal ring hauberk|a metal mail helm|a metal mail robe|a metal chain balaclava|a metal mail shirt|some metal mail greaves|a metal chain hauberk|some metal chain vambraces|a metal mail hauberk|some metal ring sleeves|a metal chain tasset) from any material\.
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a metal scale mask|some brigandine sleeves|a metal scale aventail|a metal lamellar balaclava|some metal scale gloves|some lamellar vambraces|a metal brigandine mask|a metal lamellar tasset|a metal brigandine aventail|a metal scale vest|a metal scale cap|a metal scale lorica|some metal scale greaves|a brigandine shirt|a metal lamellar aventail|some lamellar sleeves|a metal brigandine cap|a metal brigandine vest|a metal scale helm|a metal brigandine mantle|some metal lamellar gloves|a metal brigandine lorica|some brigandine greaves|a metal scale robe|a metal lamellar cap|a metal scale shirt|a metal brigandine helm|a metal lamellar shirt|a metal scale balaclava|a brigandine hauberk|some metal scale vambraces|a metal lamellar robe|a metal scale tasset|a metal lamellar vest|some metal scale sleeves|a metal lamellar mantle|some lamellar greaves|a metal lamellar lorica|a metal lamellar helm|a metal scale hauberk|a brigandine balaclava|a lamellar hauberk|some brigandine vambraces|a metal brigandine tasset) from any material\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (a light plate mask|a metal sallet|a light plate aventail|some light plate greaves|a plate mask|a metal great helm|a metal dome helm|some heavy plate greaves|a plate aventail|some heavy plate vambraces|some light plate gauntlets|some plate sleeves|a heavy plate mask|a metal heavy backplate|a metal morion|a heavy plate fauld|a heavy plate aventail|a metal breastplate|some plate gauntlets|a light plate cuirass|a metal bascinet|some heavy plate sleeves|a metal barbute|a heavy breastplate|heavy plate gauntlets|a plate cuirass|a metal visored helm|some light field plate|some light plate vambraces|some light half plate|a light backplate|a heavy plate cuirass|a light plate fauld|some field plate|a metal closed helm|some half plate|a metal armet|some light full plate|some plate greaves|some heavy field plate|some plate vambraces|some full plate|some light plate sleeves|ome heavy half plate|a metal backplate|some heavy full plate|a plate fauld|a light breastplate) from any material\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a metal shield handle|a metal ceremonial shield|a metal shield boss|a metal kite shield|a metal target shield|a metal skirmisher's shield|a metal ordinary shield|a metal jousting shield|a metal round sipar|a metal tower shield|a metal medium shield|a metal warrior's shield|a metal triangular sipar|a metal aegis|a metal targe|a metal heater shield|a metal oval shield|a metal battle shield|a metal medium buckler|a metal war shield|a metal circular buckler|a metal curved shield) from any material\.
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "blacksmith" then
          {
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a diagonal-peen hammer|some metal bolt tongs|a curved metal shovel|a slender metal pickaxe|a metal cross-peen hammer|a ball-peen hammer|some straight metal tongs|a sturdy metal shovel|a stout metal pickaxe|a flat-headed metal pickaxe|some flat-bladed tongs|some segmented tongs|some curved metal tongs|a wide metal shovel|a square metal shovel|some box-jaw tongs|a narrow metal pickaxe|a weighted metal pickaxe|a straight-peen hammer|some articulated tongs|some angular metal tongs|a tapered metal shovel) from any material\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (some short metal chisels|a textured metal rasp|some long metal chisels|some rough metal pliers|some square metal rifflers|a metal slender bow saw|a thin metal rasp|some sharpened chisels|a metal straight bone saw|some elongated rifflers|some squat metal rifflers|a flat metal rasp|some plain metal pliers|some thick metal pliers|some sturdy metal chisels|a tapered metal rasp|a coarse metal rasp|some hooked metal pliers|some curved metal pliers|a metal tapered bone saw|a metal curved bone saw|a metal serrated bone saw|some reinforced chisels|some curved metal rifflers) from any material\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a metal hide scraper|some squat knitting needles|some smooth knitting needles|some knobby sewing needles|a stout metal yardstick|a rectangular yardstick|some plain sewing needles|some bent metal scissors|some straight metal scissors|a serrated hide scraper|a curved hide scraper|a compact metal awl|a pointed metal awl|some polished knitting needles|some tapered knitting needle|a slender metal awl|a flat metal yardstick|a detailed yardstick|some curved metal scissors|some serrated scissors|some ribbed sewing needles|some thin sewing needles|a narrow metal awl) from any material\.
               matchre chapter.5 This logbook is tracking a work order requiring you to craft (a small metal brazier|a round mixing stick|a tapered pestle|a round pestle|a flat mixing stick|a grooved pestle|a square wire sieve|an oblong wire sieve|a tapered mixing stick|a grooved mixing stick|a flat pestle|a trapezoidal wire sieve|a metal brazier|a triangular wire sieve) from any material\.
               matchre chapter.6 This logbook is tracking a work order requiring you to craft (a shallow metal cup|a metal rod|a metal lockpick ring|a slender metal rod|a metal herbal case|a tall metal mug|a metal jewelry box|a short metal mug|a metal flights box|a soft metal keyblank|a metal razor|a metal horseshoe|a large metal flask|a back scratcher|a metal armband|some metal barbells|a metal instrument case|a large metal horseshoe|a metal chest|a small metal flask|a metal backtube|a metal ankle band|a metal starchart tube|a metal lockpick case|some metal clippers|a metal origami case|a metal crown|a metal bolt box|a metal torque|a metal talisman case|a metal mask|a metal flask|a metal headdress|a metal oil lantern) from any material\.
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "tailor" then
          {
               matchre chapter.1 This logbook is tracking a work order requiring you to craft (some small cloth padding|some large cloth padding) from any (material|fabric)\.
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a cloth ankleband|a floppy cloth hat|some cloth fingerless gloves|a cloth veil|a cloth armband|a cloth head scarf|some cloth ankle socks|some cloth robes|some cloth socks|a cloth tunic|a cloth belt|a baggy cloth shirt|a cloth headband|a billowing cloth shirt|some elbow-length gloves|a front-laced cloth dress|some pleated cloth gloves|a knee-length cloth dress|some cloth knee socks|a cloth dress|a cloth eyepatch|some baggy cloth pants|a cloth commoner's cloak|a cloth top hat|a cloth dress belt|a cloth dress hat|a segmented cloth belt|some hooded cloth robes|a cloth dunce hat|a cloth cape|a cloth hat|a hooded cloth cloak|some cloth field shoes|a cloth tabard|some cloth slippers|a formal cloth tunic|some elegant cloth gloves|a short-sleeved tunic|a cloth scarf|a cloth dress shirt|a cloth cloak|a cloth gown|a cloth shirt|a floor-length cloth dress|a sleeveless cloth shirt|some cloth dress pants|a cloth sash|a deeply-hooded cloak|a cloth kilt|a cloth shaman's robe|a cloth skirt|some flowing cloth robes|some cloth pants|a cloth mage's robe|a double-wrapped belt) from any (material|fabric)\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (a cloth napkin|a cloth talisman pouch|a cloth rag|a cloth herb pouch|a cloth hip pouch|a cloth carryall|a cloth weapon strap|a cloth knapsack|a cloth gem pouch|a cloth backpack|a cloth towel|a cloth charm bag|a cloth thigh bag|a cloth bandolier|a cloth pouch|a cloth haversack|a cloth utility belt|a cloth duffel bag|a cloth sack|a small cloth rucksack|a cloth bag|a cloth rucksack|a cloth arm pouch) from any (material|fabric)\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a quilted cloth mask|some insulated cloth pants|a quilted cloth aventail|an insulated cloth hood|a padded cloth mask|a quilted cloth tabard|a padded cloth aventail|a padded cloth mantle|a quilted cloth cap|a padded cloth vest|some quilted cloth gloves|an insulated cloth tasset|some quilted cloth pants|some padded cloth sleeves|an insulated cloth mask|some insulated cloth vambraces|an insulated cloth aventail|a padded cloth tabard|a padded cloth cap|a quilted cloth shirt|some padded cloth gloves|a quilted cloth robe|a quilted cloth hood|an insulated cloth mantle|a quilted cloth tasset|an insulated cloth vest|some quilted cloth vambrace|some insulated cloth sleeves|some padded cloth pants|an insulated cloth tabard|an insulated cloth cap|a padded cloth shirt|some insulated cloth gloves|a quilted cloth hauberk|a padded cloth hood|a padded cloth robe|a quilted cloth mantle|an insulated cloth shirt|a quilted cloth vest|a padded cloth hauberk|a padded cloth tasset|an insulated cloth robe|some quilted cloth sleeves|an insulated cloth hauberk|some padded cloth vambraces) from any (material|fabric)\.
               matchre chapter.5 This logbook is tracking a work order requiring you to craft (a knitted napkin|a knitted skirt|a knitted armband|a knitted shirt|some knitted socks|some knitted gloves|a knitted ankleband|some knitted legwarmers|a knitted headband|a knitted towel|some knitted mittens|some knitted hose|a knitted hood|a knitted sweater|some knitted booties|a knitted cloak|a knitted hat|a knitted blanket|a knitted scarf|some knitted slippers) from any (?:material|fabric)\.
               matchre chapter.7 This logbook is tracking a work order requiring you to craft (some fingerless gloves|a leather dress belt|a leather ankleband|a segmented belt|a leather armband|a sleeveless leather shirt|a leather belt|a leather shirt|a leather headband|a double-wrapped belt|a leather eyepatch|a leather dress|some elbow-length gloves|a leather tunic|a commoner's cloak|a hooded leather cloak|a leather hat|a leather utility belt|some leather shoes|a leather cape|some leather moccasins|a deeply-hooded cloak|a leather cloak|a leather skirt) from any (cloth|material|leather)\.
               matchre chapter.8 This logbook is tracking a work order requiring you to craft (a leather weapon strap) from any (material|leather)\.
               matchre chapter.9 This logbook is tracking a work order requiring you to craft (a rugged leather mask|a thick leather tasset|a rugged leather aventail|a rugged leather jerkin|a thick leather mask|a coarse leather cowl|a thick leather aventail|some coarse greaves|a rugged leather cap|some coarse vambraces|some rugged gloves|a coarse leather tasset|a coarse leather mask|a thick leather vest|a thick leather cap|some thick leather sleeves|some thick gloves|a thick leather jerkin|a rugged leather helm|a rugged leather robe|a coarse leather aventail|a rugged leather coat|a coarse leather cap|a thick leather mantle|some coarse gloves|a coarse leather vest|a thick leather helm|some coarse leather sleeves|a rugged leather cowl|a coarse leather mantle|some rugged greaves|a coarse leather jerkin|some rugged vambraces|a thick leather coat|a rugged leather tasset|some rugged leathers|a coarse leather helm|a thick leather robe|a thick leather cowl|a coarse leather coat|some thick greaves|some thick leathers|some thick vambraces|a coarse leather robe|some rugged leather sleeves|some coarse leathers|a rugged leather vest|a rugged leather mantle) from any (material|leather)\.
               matchre chapter.10 This logbook is tracking a work order requiring you to craft (a leather shield handle|a leather oval shield|a long leather cord|a leather targe|a leather target shield|a medium leather shield|an ordinary leather shield|a leather kite shield|a leather buckler|a small leather shield) from any (material|leather)\.
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "carving" then
          {
               matchre chapter.1 This logbook is tracking a work order requiring you to craft (a small stone block|a deep stone basin|a large stone block|a small stone sphere|a thin stone slab|a flat slickstone|a short stone pole|a large stone sphere|a thick stone slab|a grooved stone stirring rod|a smooth slickstone|a polished slickstone|a stout stone stirring rod|a notched stone stirring rod|a shallow stone basin|a forked stone stirring rod|a long stone pole|a slender stone stirring rod) from any material\.
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a rough stone table|a stone buffet table|a high stone table|a stone dining table|a square stone table|a stone refectory table|a round stone table|a stone meditation table|an oval stone table|a stone parquet table|a long stone table) from any material\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (some smooth stones|a stone bola|a stone bludgeon|a stone hand sword|a stone carving knife|a heavy stone mallet|some elongated stones|a stone javelin|a stone hand axe|a stone spear|a stone war club|a stone war mattock|some balanced stones|a stone maul|a stone war hammer|a stone flail|some stone spikes|some stone shards) from any material\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a stone band|a stone talisman case|a stone toe ring|a stone belt buckle|a stone nose ring|a stone armband|a stone pin|an articulated stone bracelet|a stone anklet|a stone tiara|a stone bracelet|a stone locket|a stone tailband|a stone choker|a stone hairpin|a stone diadem|a stone cloak pin|a stone circlet|a pair of stone earrings|an articulated stone necklace|a stone medallion|a stone crown|a stone amulet|an articulated stone belt|a stone pendant|a stone mask|a stone brooch|a stone earcuff) from any material\.
               matchre chapter.5 This logbook is tracking a work order requiring you to craft (a Human image|an Elothean image|a Kaldar image|a Prydaen image|an Elf image|a Rakash image|a Gor'Tog image|a S'Kra Mur image|a Halfling image|a Dwarf image|a Gnome image) from any material\.
               matchre chapter.6 This logbook is tracking a work order requiring you to craft (a long bone pole|a short bone pole) from any material\.
               matchre chapter.7 This logbook is tracking a work order requiring you to craft (a round bone table|a square bone table) from any material\.
               matchre chapter.8 This logbook is tracking a work order requiring you to craft (a bone bludgeon|a bone javelin|a bone carving knife|a light bone spear|a bone hand axe|a bone maul|a bone war club|a bone mattock|a bone shiv|a bone flail|a bone hand sword|a bone mallet) from any material\.
               matchre chapter.9 This logbook is tracking a work order requiring you to craft (a bone band|a bone brooch|a bone nose ring|a bone armband|a bone toe ring|a bone belt buckle|a bone bracelet|a bone choker|a bone anklet|a bone locket|a bone pin|a bone tiara|a bone cloak pin|an articulated bone bracelet|a bone hairpin|some bone bangles|a bone tailband|an articulated bone necklace|a shallow bone cup|a bone circlet|a bone pendant|a bone crown|a bone amulet|a bone comb|a bone medallion|a bone haircomb|a pair of bone earrings|a bone earcuff) from any material\.
               matchre chapter.10 This logbook is tracking a work order requiring you to craft (a segmented bone mask|a segmented bone mantle|a segmented bone aventail|a segmented bone tabard|a notched bone mask|a ribbed bone balaclava|a notched bone aventail|some ribbed bone greaves|a segmented bone cap|some ribbed vambraces|some segmented bone gloves|some notched bone sleeves|a ribbed bone mask|a ribbed bone tasset|a ribbed bone aventail|a notched bone vest|a notched bone cap|a notched bone mantle|some notched bone gloves|a notched bone tabard|a segmented bone helm|a segmented bone robe|a ribbed bone cap|a segmented bone coat|some ribbed bone gloves|some ribbed bone sleeves|a notched bone helm|a ribbed bone vest|a segmented bone balaclava|a ribbed bone mantle|some segmented bone greaves|a ribbed bone tabard|some segmented vambraces|a notched bone robe|a segmented bone tasset|a notched bone coat|a ribbed bone helm|a segmented bone hauberk|a notched bone balaclava|a ribbed bone robe|some notched bone greaves|a ribbed bone coat|some notched vambraces|a notched bone hauberk|some segmented bone sleeves|a ribbed bone hauberk|a notched bone tasset|a segmented bone vest) from any material\.
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "shaping" then
          {
               matchre chapter.1 This logbook is tracking a work order requiring you to craft (a short wood pole) from any material\.
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a toy bow|a simple shortbow|a practice shortbow|a farmer's bow|a light shortbow|a sturdy shortbow|a shortbow|an apline shortbow|a saddle bow|a flight bow|a steppe bow|a battle shortbow| a forester's shortbow|a Nisha shortbow|a competition shortbow) from any material\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (a simple longbow|a practice longbow|a longbow|a sturdy longbow|a flatbow|a skirmisher's bow|a reflex longbow|a self bow|a recurve longbow|a forester's longbow|a battle longbow|a competition longbow) from any material\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a composite bow|a double-backed bow|a recurve bow|a forester's bow|a reflex bow|a savannah bow|a footman's bow|a horseman's bow|a battle bow|a competition bow) from any material\.
               matchre chapter.7 This logbook is tracking a work order requiring you to craft (a wood toe ring|a wood nose ring|a wood band|a wood pin|a wood anklet|a wood bracelet|a wood tailband|a wood hairpin|a shallow wood cup|a wood cloak pin|a pair of wood earrings|a wood medallion|a wood amulet|a wood pendant|a wood earcuff|a wood brooch|a wood armband|a wood belt buckle|a wood choker|a wood locket|a wood circlet|an articulated wood necklace|a wood crown|a wood mask|a wood haircomb) from any material\.
               matchre chapter.8 This logbook is tracking a work order requiring you to craft (a wood bead|a detailed wood bead|a wood totem|a detailed wood totem|a wood humanoid bead|a wood figurine|a detailed wood figurine|a wood statuette|a detailed wood stattuette|a wood statue|a detailed wood statue|) from any material\.
               matchre chapter.9 This logbook is tracking a work order requiring you to craft (a wood nightstick|a wood cane|a wood walking cane|a wood quarterstaff|a wood crook|a wood bo staff|a weighted staff) from any material\.
               #matchre chapter.10 This logbook is tracking a work order requiring you to craft (a rough wood table|a low wood table|a high wood table|a round wood table|a square wood table|a long wood table|an oval wood table|a wood dining table|a wood buffet table|a wood refectory table|a wood parquet table|a wood meditation table) from any material\.
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "tinkering" then
          {
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a toy crossbow|a simple crossbow|a practice crossbow|a farmer's crossbow|a slim crossbow|a sturdy light crossbow|a light crossbow|a flight crossbow|a saddle crossbow|an alpine crossbow|a lockbow|a light forester's crossbow|a light battle crossbow|a steppe crossbow|a latchbow) from any material\.
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (a simple heavy crossbow|a practice heavy crossbow|a heavy crossbow|a sturdy heavy crossbow|a flat crossbow|a skirmisher's crossbow|a slurbow|an arena crossbow|a recurve crossbow|a forester's crossbow|a battle crossbow|a competition crossbow) from any material\.
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (an arbalest|a reinforced arbalest|a recurve arbalest|a forester's arbalest|a siege arbalest|a mariner's arbalest|a footman's arbalest|a horseman's arbalest|a battle arbalest|a competition arbalest) from any material\.
               matchre chapter.5 This logbook is tracking a work order requiring you to craft (a simple stonebow|a stonebow |a sturdy stonebow|a alpine stonebow|a saddle stonebow|a lobbing stonebow|a steppe stonebow|a battle stonebow|a forester's stonebow|a slingbow|a pelletbow) from any material\.
               #matchre chapter.7 This logbook is tracking a work order requiring you to craft (boar-tusk bolts|cougar-claw bolts|hele'la bolts|angiswaerd bolts|sabertooth bolts|elsralael bolts|basilisk bolts|soot-stained bolts|ice-adder bolts|drake-fang bolts|jagged-horn bolts) from any material\.
               matchre chapter.9 This logbook is tracking a work order requiring you to craft (a small music box|a simple telescope|a miniature female soldier|a miniature male soldier|a musical box|a telescope|a clockwork telescope)
               
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
          }
     if "%discipline" = "remed" then
          {
               action var volume $1 when ^The notes indicate that remedies such as this must be bundled in quantities containing exactly (\d+) uses
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (some blister cream|some moisturizing ointment|some itch salve|some lip balm)
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (some limb salve|some limb ungent|some neck salve|some abdominal salve|some chest salve|some neck ungent|some abdominal ungent|some chest ungent|some head ungent|some head salve)
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (a neck potion|an eye potion|some neck tonic|some back tonic|some eye tonic|a back potion|some limb tonic)
               matchre chapter.5 This logbook is tracking a work order requiring you to craft (some body ointment|some body poultices)
               matchre chapter.6 This logbook is tracking a work order requiring you to craft (a body draught|a body elixer)
               put read my %society.type logbook
               matchwait 1
               goto new.order.wait
          }
               
     if "%discipline" = "artif" then
               {
               matchre chapter.2 This logbook is tracking a work order requiring you to craft (a radiant trinket|a mana trinket|a cambrinth retuner|a flash trinket|a wind trinket|an earth trinket)
               matchre chapter.3 This logbook is tracking a work order requiring you to craft (training ritual focus|basic lunar ritual focus|basic elemental ritual focus|basic life ritual focus|basic holy ritual focus)
               matchre chapter.4 This logbook is tracking a work order requiring you to craft (common material minor fount|common material lesser fount|common material greater fount)
               matchre chapter.6 This logbook is tracking a work order requiring you to craft (a bubble wand|ease burden runestone|seal cambrinth runestone|(?<!ease )burden runestone|manifest force runestone|strange arrow runestone|gauge flow runestone|dispel runestone|lay ward runestone)
               put read my %society.type logbook
               matchwait 2
               goto new.order.wait
               }
     echo Discipline is not set properly
     put #echo >Log Discipline is not set properly
     exit          

chapter.name:
     if "%discipline" = "tinkering" then var order.type lumber
     if matchre("%full.order.noun", "(?:.*\s)(\S+$)") then put #var MC.order.noun $1
     if matchre("%full.order.noun", ".* ball and chain") then put #var MC.order.noun ball
     put #var MC.full.order.noun %full.order.noun
     echo Item Full Name : %full.order.noun
     echo Item Base Name : $MC.order.noun
     echo Chapter Item Is In : %order.chapter
     echo Quantity Desired : %order.quantity
     goto keep.order
      
chapter.1:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type cloth
     if "%discipline" = "carving" then var order.type stone
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 1
     pause .5
     goto chapter.name
     
chapter.2:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type cloth
     if "%discipline" = "carving" then var order.type stone
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 2
     pause .5
     goto chapter.name
     
chapter.3:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type cloth
     if "%discipline" = "carving" then var order.type stone
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 3
     pause .5
     goto chapter.name
     
chapter.4:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type cloth
     if "%discipline" = "carving" then var order.type stone
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 4
     pause .5
     goto chapter.name
     
chapter.5:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type yarn
     if "%discipline" = "carving" then var order.type stone
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 5
     pause .5
     goto chapter.name
     
chapter.6:
     var full.order.noun $1
     if "%discipline" = "carving" then var order.type stack
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 6
     pause .5
     goto chapter.name
     
chapter.7:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type leather
     if "%discipline" = "carving" then var order.type stone
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 7
     pause .5
     goto chapter.name
     
chapter.8:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type leather
     if "%discipline" = "carving" then var order.type stack
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 8
     pause .5
     goto chapter.name
     
chapter.9:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type leather
     if "%discipline" = "carving" then var order.type stack
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 9
     pause .5
     goto chapter.name
     
chapter.10:
     var full.order.noun $1
     if "%discipline" = "tailor" then var order.type leather
     if "%discipline" = "carving" then var order.type stack
     if "%discipline" = "shaping" then var order.type lumber
     var order.chapter 10
     pause .5
     goto chapter.name

keep.order:
     if matchre("%full.order.noun", "$MC_BLACKLIST") then goto new.order.wait
     if (("%discipline" = "tailor") && ("%order.pref" != "%order.type")) then goto new.order.wait
     if (("%discipline" = "carving") && ("%order.pref" != "%order.type")) then goto new.order.wait
     if "$MC.order.quality" = "finely-crafted" then put #var MC.order.quality.fail riddled with mistakes and practically useless|of dismal quality|very poorly-crafted|of below-average quality|of mediocre quality|of average quality|of above-average quality|well-crafted
     if "$MC.order.quality" = "of superior quality" then put #var MC.order.quality.fail riddled with mistakes and practically useless|of dismal quality|very poorly-crafted|of below-average quality|of mediocre quality|of average quality|of above-average quality|well-crafted|finely-crafted
     if "$MC.order.quality" = "of exceptional quality" then put #var MC.order.quality.fail riddled with mistakes and practically useless|of dismal quality|very poorly-crafted|of below-average quality|of mediocre quality|of average quality|of above-average quality|well-crafted|finely-crafted|of superior quality
     if "$MC.order.quality" = "" then goto new.order
     goto turn.page

turn.page:
     gosub PUT_IT my %society.type logbook in my %main.storage
     gosub GET my %discipline book
     if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
     action (book) on
     #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES 
     put turn my book to discipline %discipline
     pause 0.5
     pause 0.2
     #################################################################
     gosub PUT turn my book to chapter %order.chapter
     gosub READ %full.order.noun
#     waitforre (?<!Page).*Page (\d+): %full.order.noun
#     var page $1
     gosub PUT turn my book to page %page
     action (book) off
     if %NOWO then goto calc.material
	if !matchre("$righthand|$lefthand", book) then gosub GET %discipline book
     if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
     gosub STUDY my book
     if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
          {
               math difficultytry add 1
               put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
               pause 0.5
               goto new.order
          }
     goto calc.material

      
#################################
#
#  Gathering materials and parts
#
#################################

calc.material:
     var material.volume 0
     var bigenough 0
     var asmCount1 0
     var asmCount2 0
     pause 0.5
     if matchre("%discipline", "weapon|armor|blacksmith") then
          {
               pause .1
               action (book) on
               if !matchre("$righthand", "book") then gosub GET my %discipline book
			pause .5
			pause .1
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               send read my book
               waitforre metal ingot .(\d+) volume
               var volume $1
               action (book) off
               pause 0.1
               evalmath mass.volume %volume * %order.quantity
               if $MC_SMALL.ORDERS = 1 then
                    {
                         if (("%work.material" = "bronze") && (%volume > 5)) then goto new.order
                         if (("%work.material" = "steel") && (%volume > 10)) then goto new.order
                    }
               gosub parts.inv
               if %%order.pref.item.count > 11 then var %%order.pref.item.count 11
               if %%order.pref.item.count > 0 then gosub count.material ingot
               if %%order.pref.deed.count > 11 then var %%order.pref.deed.count 11
               if %%order.pref.deed.count > 0 then gosub count.material deed
               if %bigenough < %order.quantity then gosub lack.material
               if %mass.volume > %material.volume then gosub lack.material
               pause 0.5
               echo Total Volume Req'd: %mass.volume
               echo Volume per Item: %volume
               echo Number of Items Req'd: %order.quantity
               echo Inventory: %material.volume volumes
               if %oil.count < 1 then
               {
                    gosub automove $oil.room
                    action (order) on
                    gosub ORDER
                    pause .5
                    action (order) off
                    gosub ORDER $oil.order
                    gosub PUT_IT my oil in my %main.storage
               }
          }
     if "%discipline" = "tailor" then
          {
               pause .1
               action (book) on     
               if !matchre("$righthand", "book") then gosub GET my tailoring book
               pause .5
			pause .1
               send read my book
               waitforre .*(cloth|leather|yarn).*\((\d+) yards?\)
               var volume $2
               action (book) off
               pause 0.1
               var mass.volume %volume
               math mass.volume multiply %order.quantity
               gosub parts.inv
               if %%order.pref.item.count > 11 then var %%order.pref.item.count 11
               if %%order.pref.item.count > 0 then gosub count.material %order.pref
               if %%order.pref.deed.count > 11 then var %%order.pref.deed.count 11
               if %%order.pref.deed.count > 0 then gosub count.material deed
               if %mass.volume > %material.volume then gosub lack.material
               gosub combine.check "%main.storage" "%work.material %order.pref"
               pause 0.5
               echo Total Yards Req'd: %mass.volume
               echo Yards per Item: %volume
               echo Number of Items Req'd: %order.quantity
               echo Inventory: %material.volume yards
               if %pins.count < 1 then
               {
                    gosub automove $tool.room
                    action (order) on
                    gosub ORDER
                    action (order) off
                    gosub ORDER $pins.order
                    gosub PUT_IT my pin in my %main.storage
               }
          }
     if (("%discipline" = "carving") && ("%order.pref" = "stack")) then
          {
               pause .1
               action (book) on
               pause .5
               if !matchre("$righthand", "book") then gosub GET my carving book
               #################################################################
               send read my book
               waitforre .*bone stack.*\((\d+) (piece|pieces)\)
               var volume $1
               action (book) off          
               gosub STUDY my book
               if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                    {
                         gosub PUT_IT my book in my %main.storage
                         math difficultytry add 1
                         put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         goto new.order
                    }
               pause 0.1
               var mass.volume %volume
               math mass.volume multiply %order.quantity
   			   if (("%order.pref" = "stack") && (%mass.volume > 99)) then goto new.order
               gosub parts.inv          
               if %%order.pref.item.count > 11 then var %%order.pref.item.count 11
               if %%order.pref.item.count > 0 then gosub count.material stack
               if %%order.pref.deed.count > 11 then var %%order.pref.deed.count 11
               if %%order.pref.deed.count > 0 then gosub count.material deed
               if %mass.volume > %material.volume then gosub lack.material
               gosub combine.check "%main.storage" %order.pref
               pause 0.5
               echo Total Pieces Req'd: %mass.volume
               echo Pieces per Item: %volume
               echo Number of Items Req'd: %order.quantity
               echo Inventory: %material.volume pieces
               if %polish.count < 1 then
                    {
                         gosub automove $tool.room
                         action (order) on
                         gosub ORDER
                         action (order) off
                         gosub ORDER $polish.order
                         gosub PUT_IT my polish in my %main.storage
                    }
          }
     if ((matchre("%discipline", "tinkering|shaping")) && ("%order.pref" = "lumber")) then
          {
               pause .1
               action (book) on
               pause .5
               if !matchre("$righthand", "book") then gosub GET my %discipline book
               pause 0.5
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               #################################################################               
               pause 0.2
               send read my book
               waitforre .*lumber.*\((\d+) (piece|pieces)\)
               var volume $1
               action (book) off
               pause 0.1
               var mass.volume %volume
               math mass.volume multiply %order.quantity
               if %mass.volume > 70 then goto new.order
               gosub parts.inv          
               if %%order.pref.item.count > 11 then var %%order.pref.item.count 11
               if %%order.pref.item.count > 0 then gosub count.material lumber
               if "%assemble2" = "mechanism" then gosub count.material mechanism
               if %%order.pref.deed.count > 11 then var %%order.pref.deed.count 11
               if %%order.pref.deed.count > 0 then gosub count.material deed
               if %mass.volume > %material.volume then gosub lack.material     
               gosub combine.check "%main.storage" %order.pref
               pause 0.5
               echo Total Pieces Req'd: %mass.volume
               echo Pieces per Item: %volume
               echo Number of Items Req'd: %order.quantity
               echo Inventory: %material.volume pieces
                if %stain.count < 1 then
                    {
                         gosub automove $tool.room
                         action (order) on
                         gosub ORDER
                         action (order) off
                         gosub ORDER $stain.order
                         gosub PUT_IT my stain in my %main.storage
                    }
         }     
     if matchre("%discipline", "remed") then
          {
               pause .1
               action (book) on
               pause 0.5          
               if !matchre("$righthand", "book") then gosub GET my %discipline book
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               ### ADDED THIS// MAYBE REMOVE???
               send read my book
               pause 2
               #action (book) off
               ###########################
               pause 0.1
               gosub EMPTY_HANDS
               var herb1 NULL
               var herb2 NULL
               var herb1.volume 5
               if %order.chapter = 2 then var herb2.volume 1
               if matchre("%full.order.noun", "some blister cream|some moisturizing ointment|some itch salve|some lip balm") then var herb1 flowers
               if "%full.order.noun" = "some blister cream" then var herb2 nemoih
               if "%full.order.noun" = "some moisturizing ointment" then var herb2 plovik
               if "%full.order.noun" = "some itch salve" then var herb2 jadice
               if "%full.order.noun" = "some lip balm" then var herb2 nilos
               if matchre("%full.order.noun", "some neck salve|some neck ungent") then var herb1 georin
               if matchre("%full.order.noun", "some abdominal salve|some abdominal ungent") then var herb1 nilos
               if matchre("%full.order.noun", "some chest salve|some chest ungent") then var herb1 plovik
               if matchre("%full.order.noun", "some head salve|some head ungent") then var herb1 nemoih
               if matchre("%full.order.noun", "some limb salve|some limb ungent") then var herb1 jadice 
               if matchre("%full.order.noun", "a neck potion|some neck tonic") then var herb1 riolur
               if matchre("%full.order.noun", "a chest potion|some chest tonic") then var herb1 root
               if matchre("%full.order.noun", "a back potion|some back tonic") then var herb1 junliar
               if (("$zoneid" = "150") && (matchre("%full.order.noun", "a back potion|some back tonic"))) then var herb1 junliar
               if (("$zoneid" = "67") && (matchre("%full.order.noun", "a back potion|some back tonic"))) then var herb1 junliar
               if matchre("%full.order.noun", "an eye potion|some eye tonic") then var herb1 aevaes
               if matchre("%full.order.noun", "some face ointment|some face poultices") then var herb1 pollen
               if matchre("%full.order.noun", "some body ointment|some body poultices") then var herb1 genich
               if matchre("%full.order.noun", "a body draught|a body elixer") then var herb1 ojhenik
               var order.pref %herb1
               evalmath mass.volume %volume * %order.quantity * 5
               if %order.chapter = 2 then var mass.volume2 %order.quantity
               var %herb1.material.volume 0
               var %herb2.material.volume 0
               gosub parts.inv
               if %%herb1.item.count > 11 then var %%herb1.item.count 11
               if %%herb1.item.count > 0 then 
                    {
                         gosub count.material %herb1
                         var %herb1.material.volume %material.volume
                    }
               if %order.chapter = 2  && %%herb2.item.count > 0 then
                    {
                         gosub count.material %herb2
                         var %herb2.material.volume %material.volume
                    }
               if %mass.volume > %%herb1.material.volume then 
                    {
                         var order.type %herb1
                         gosub lack.material %herb1
                    }
               if ((%order.chapter = 2) && (%order.quantity > %%herb2.material.volume)) then 
                    {
                         var order.type %herb2
                         gosub lack.material %herb2
                    }
               gosub combine.check "%main.storage" %herb1
               pause 0.5
               echo Total Herbs Required: %mass.volume
               Echo Herbs per Item: %volume
               echo Number of Items Required: %order.quantity
               echo Inventory: %%herb1.material.volume
               if (%water.count < 1) then
                    {
                         gosub summonwater
                    }
               if (%alcohol.count < 1) then
                    {
                         gosub summonalcohol
                    }
               if %coal.count < 1 then
                    {
                         gosub automove forging suppl
                         action (order) on
                         gosub ORDER
                         action (order) off
                         gosub ORDER $catalyst.order
                         gosub PUT_IT my nugget in my %main.storage
                         gosub automove alchemy supplies
                    }
                    
          }
     if ("%discipline" = "artif") then
     {
          pause .1
          action (book) on
          var sigil
          action var order.pref $1 when ^\s+\(\d\)\s+[Aa] (?:finished|basic|small).* (runestone|totem|wand|rod|sphere)
          action var sigil %sigil|$1 when ^\s+\(\d\)\s+(?:primary|secondary) sigil \((\S+)\)
          pause .5
          if !matchre("$righthand", "book") then gosub GET my %discipline book
		pause .1
          if !matchre("$righthand|$lefthand", "book") then gosub GET crafting book
          pause 0.1
          ######
          send read my book
          pause 2
          action (book) off
          pause 0.1
          if !matchre("$MC.order.noun", "fount|loop") then put #var MC.order.noun %order.pref
          eval sigil replacere("%sigil", "^\|", "")
          eval sigil replace("%sigil", "any", "%sigil(0)"
          eval sigil.total count("%sigil", "|")
          gosub sigil.count
          if ((%sigil.total > 0) && ("%sigil(0)" = "%sigil(1)")) then var sigil %sigil(0)
          eval sigil.total count("%sigil", "|")
          var assemble %sigil(0)
          var asmCount1 %need.%sigil(0)
          if %sigil.total > 0 then 
               {
                    var assemble2 %sigil(1)
                    var asmCount2 %need.%sigil(1)
               }
          gosub parts.inv
          if (%order.quantity > %%order.pref.item.count) then gosub lack.material
          pause 0.5
          echo Number of Items Req'd: %order.quantity
          if ("%discipline" = "artif") then gosub count.material fount
          if %fount.uses < %order.quantity then
               {
			        gosub get my fount
					put drop my fount
					math fount.count subtract 1
                    if %fount.count < 1 then 
                              {
					          gosub automove enchanting tool
                                   gosub ORDER 3
                                   gosub PUT_IT my fount in my %main.storage
                              }
               }
          if %salt.count < 1 then
               {
                    gosub automove forging tool
                    action (order) on
                    gosub ORDER
                    action (order) off
                    gosub ORDER $salt.order
                    gosub PUT_IT my salt in my %main.storage
                    gosub automove enchanting supplies
               }
     }          
     goto calc.parts
     
sigil.count:
     if %sigil.total = 0 then 
          {
               var need.%sigil 1
               return
          }
     var sigil.count 0
sigil.count_1:
     if %sigil.count > %sigil.total then return
     eval need.%sigil(%sigil.count) count("%sigil", "%sigil(0)")
     #evalmath need.sigil(%sigil.count) %need.%sigil(%sigil.count)*%order.quantity
     eval replace("%sigil", "%sigil(%sigil.count)"
     math sigil.count add 1
     goto sigil.count_1
          
calc.parts:
     var temp.room 0
     math asmCount1 multiply %order.quantity
     math asmCount2 multiply %order.quantity
     if matchre("$righthand|$lefthand", "book") then gosub PUT_IT my book in my %main.storage
     if matchre("%assemble", "(\S+)") then math asmCount1 subtract %$1.count
     if matchre("%assemble", "(\S+)\s(\S+)") then math asmCount1 subtract %$1.$2.count
     if (matchre("%assemble2", "(\S+)") && ("%assemble2" != "mechanism")) then math asmCount2 subtract %$1.count
     if matchre("%assemble2", "(\S+)\s(\S+)") then math asmCount2 subtract %$1.$2.count
#    if matchre("%assemble2", "(\S+)") then math asmCount2 subtract %$1.count
     if "%assemble2" = "mechanism" then 
          {
               put #tvar totalmechanisms %asmCount2
               math asmCount2 subtract %mechnumber
               put #tvar needmechanisms %asmCount2
               evalmath asmCount2 ceiling(%asmCount2/3)
          }
     pause 2
     gosub check.location
     if %asmCount1 > 0 then gosub purchase.assemble
     if %asmCount2 > 0 then gosub purchase.assemble2
     if "%repair" = "on" then gosub check.tools
     goto process.order

parts.inv:
     var %order.pref.item.count 0
     var %order.pref.deed.count 0
     var %herb1.item.count 0
     var %herb2.item.count 0
     var induction.count 0
     var abolition.count 0
     var congruence.count 0
     var permutation.count 0
     var rarefaction.count 0
     var fount.count 0
	var fount.uses 0
     var water.count 0
     var alcohol.count 0
     var coal.count 0
     var long.pole.count 0
     var short.pole.count 0
     var handle.count 0
     var hilt.count 0
     var haft.count 0
     var large.backing.count 0
     var large.padding.count 0
     var small.backing.count 0
     var small.padding.count 0
     var long.cord.count 0
     var short.cord.count 0
     var pins.count 0
	var backer.count 0
	var strips.count 0
     var oil.count 0
     var polish.count 0
     var stain.count 0
     var string.count 0
     var mechanism.count 0
     var lenses.count 0
     var salt.count
     action (forging) math ingot.item.count add 1 when ^\s*(?:an?|some)(?! deed).*(%work.material) ingot
     action (forging) math %order.pref.deed.count add 1 when ^\s+a deed for (?:an?|some).*(%work.material).*(ingot)
     action (assemble) math long.pole.count add 1 when ^\s+a long \S+ pole
     action (assemble) math short.pole.count add 1 when ^\s+a short \S+ pole
     action (assemble) math handle.count add 1 when ^\s+(a|an) \S+ shield handle
     action (assemble) math hilt.count add 1 when ^\s+a \S+ \S+ hilt
     action (assemble) math haft.count add 1 when ^\s+a \S+ \S+ haft
     action (assemble) math oil.count add 1 when ^\s+a(?: big)? flask of(?: azure| violet)? oil
     action (assemble) math large.backing.count add 1 when ^\s+a large \S+ backing
     action (assemble) math small.backing.count add 1 when ^\s+a small \S+ backing
     action (assemble) math large.padding.count add 1 when ^\s+(a|some) large \S+ padding
     action (assemble) math small.padding.count add 1 when ^\s+(a|some) small \S+ padding
     action (assemble) math large.padding.count add 1 when ^\s+(a|some) large \S+ \S+ padding
     action (assemble) math small.padding.count add 1 when ^\s+(a|some) small \S+ \S+ padding
     action (assemble) math long.cord.count add 1 when ^\s+a long \S+ cord
     action (assemble) math short.cord.count add 1 when ^\s+a short \S+ cord
     action (assemble) math pins.count add 1 when ^\s+some .*?pins
	action (assemble) math backer.count add 1 when backing material
	action (assemble) math strips.count add 1 when leather strips
     action (outfitting) math %order.pref.item.count add 1 when ^\s+(?:an?|some) (%work.material).*(%order.pref)
     action (outfitting) math %order.pref.deed.count add 1 when ^\s+a deed for (?:an?|some).*(%work.material).*(%order.pref)
     action (engineering) math polish.count add 1 when ^\s+a jar of surface polish
     action (engineering) math stain.count add 1 when ^\s+some wood stain
     action (engineering) math string.count add 1 when ^\s+some bow string
     action (engineering) math backer.count add 1 when ^\s+some .+ backer
     action (engineering) math strips.count add 1 when ^\s+some leather strips
     action (engineering) math mechanism.count add 1 when ^\s+(?:an?|some) (\S+) mechanism
     action (engineering) math lenses.count add 1 when ^\s+some lenses
     action (engineering) math %order.pref.item.count add 1 when ^\s+(?:an?|some) (%work.material).*(%order.pref|stack)
     action (engineering) math %order.pref.deed.count add 1 when ^\s+a deed for (?:an?|some).*(%work.material).*(%order.pref|stack)
     action (alchemy) math %herb1.item.count add 1 when ^\s+(?:an?|some).*(%herb1)(?! ?(salve|ointment|ungent|potion|poultices|draught|elixir|tonic|salve|wash|balm))
     action (alchemy) math %herb2.item.count add 1 when ^\s+(?:an?|some).*(%herb2)(?! ?(salve|ointment|ungent|potion|poultices|draught|elixir|tonic|salve|wash|balm))
     action (alchemy) math water.count add 1 when ^\s+(?:an?|some) water
     action (alchemy) math alcohol.count add 1 when ^\s+(?:an?|some) grain alcohol
     action (alchemy) math coal.count add 1 when ^\s+(?:an?|some).*coal nugget
     action (enchanting) math $1.count add 1 when ^\s+(?:an?).* (\S+) sigil-scroll
     action (enchanting) math fount.count add 1 when ^\s+(?:an?).* fount
     action (enchanting) math %order.pref.item.count add 1 when ^\s+(?:an?).*?(?<!imbuement |stirring )(%order.pref)
     action (enchanting) math salt.count add 1 when ^\s+a pouch of aerated salts
     action (forging) off
     action (outfitting) off
     action (engineering) off
     action (alchemy) off
     action (enchanting) off
     if ("%discipline" = "tailor") then action (outfitting) on
     if matchre("%discipline", "weapon|armor|blacksmith") then action (forging) on
     if matchre("%discipline", "carving|shaping|tinkering") then action (engineering) on
     if "%discipline" = "remed" then action (alchemy) on
     if "%discipline" = "artif" then action (enchanting) on
     send inv my %main.storage
     if matchre("%main.storage", "(?i)portal") then send inv my eddy
     waitforre INVENTORY HELP
     pause 2
     if ("%discipline" = "tailor") then action (outfitting) off
     if matchre("%discipline", "weapon|armor|blacksmith") then action (forging) off
     if matchre("%discipline", "carving|shaping|tinkering") then action (engineering) off
     if "%discipline" = "remed" then action (alchemy) off
     if "%discipline" = "artif" then action (enchanting) off
     action (assemble) off
     return     

count.material:
     var countloop 0
     var count $0
     var bigenough 0
     var itemvolume 0
     action (count) math material.volume add $1;var itemvolume $1 when About (\d+) volumes? of metal was used in this
     action (count) math material.volume add $1;var itemvolume $1 when \s+(?:Volume|Yards|Piece|Pieces):\s+(\d+)$
     action (count) math material.volume add $1;var itemvolume $1 when possess a volume of (\d+)\.$
     action (count) math material.volume add $1;var itemvolume $1 when ^You count out (\d+) (piece|pieces|yards)
     action (count) var manual 1 when unable to discern hardly anything about it\.$|make a few observations\.$|learn more about its construction\.$
     var manual 0
     if "%count" = "ingot" then
          {
               var c.action analyze
               var tempcount %ingot.item.count
          }
     if contains("(leather|cloth|yarn)","%count") then
          {
               var c.action count
               var tempcount %%order.pref.item.count
               gosub combine.check "%main.storage" %order.pref
          }
     if "%count" = "stack" then
          {
               var c.action count
               var tempcount %%order.pref.item.count
               gosub combine.check "%main.storage" %order.pref
          }
     if "%count" = "lumber" then
          {
               var c.action count
               var tempcount %%order.pref.item.count
               gosub combine.check "%main.storage" %order.pref
          }
     if "%count" = "deed" then
          {
               var c.action read
               var tempcount %%order.pref.deed.count
          }
     if "%discipline" = "remed" then
          {
               var c.action count
               var tempcount %%count.item.count
               gosub combine.check "%main.storage" %count
          }
     if "%count" = "mechanism" then
          {
               if %mechanism.count = 0 then 
                    {
                         var mechnumber 0
                         return
                    }
               action var mechs $1 when ^There(?:'s only| are| is) (\S+) ((?:parts? left of the (?:\S+) mechanism(?:s)?)|(?:mechanism(?:s)? left for use with))
               var i 0
               send count my mech
               pause 1
               gosub mechcount
               return
          }
	 if "%count" = "fount" then
	      {
               if %fount.count = 0 then 
                    {
                         var fount.uses 0
                         return
                    }
		       action (fountcount) var fount.uses $1 when approximately (\d+) uses? remaining
			   action (fountcount) on
			   var i 0
			   gosub get my fount
			   send anal my fount
			   waitforre ^You.*analyze
			   action (fountcount) off
			   gosub PUT_IT my fount in my %main.storage
			   return
		  }
count.material2:
     action (count) on
     math countloop add 1
     pause 1
     if "%ordinal(%tempcount)" = "zeroth" then math tempcount add 1
     send %c.action %ordinal(%tempcount) %work.material %count in my %main.storage
     pause 1
     if %manual =  1 then 
          {
               var bagcount %tempcount
               goto manual.count
          }
     var vol.%ordinal(%tempcount) %itemvolume
     math tempcount subtract 1
     action (count) off
     pause 1
     evalmath bigenough (floor(%itemvolume/%volume))+%bigenough
     if (("%count" = "deed") && ("%discipline" != "carving")) then
          {
               gosub get %work.material deed from %main.storage
               put tap deed
               gosub PUT_IT %work.material %order.pref in %main.storage
               if %material.volume > %mass.volume then return
          }     
     if ((%tempcount < 1) || (%countloop > 4)) then
          {
               unvar tempcount
               unvar count
               return
          }
     goto count.material2
     return
     
     
     mechcount:
     if "%countarray(%i)" = "%mechs" then 
          {
               var mechnumber %i
               goto foundit
          }
     math i add 1
     pause 0.2
     goto mechcount

foundit:
     return

manual.count:
          action (count) on
          if "$righthand" != "Empty" then 
               {
                    var rightsave $righthand
                    gosub PUT_IT $righthand in my %main.storage
               }
          gosub GET %ordinal(%bagcount) %work.material %count in my %main.storage
          if !contains("$lefthand", "yardstick") then gosub GET yard from my %tool.storage
          send measure my %work.material %count with my yardstick
          math temp subtract 1
          pause 1
          gosub PUT_IT %work.material %count in my %main.storage
          action (count) off
          evalmath bigenough (floor(%itemvolume/%volume))+%bigenough
          pause 1
          var %ordinal(%temp).volume %itemvolume
          if %temp < 1 then
               {
                    unvar temp
                    unvar count
                    unvar bagcount
                    gosub PUT_IT yard in %tool.storage
                    gosub GET %rightsave from my %main.storage
                    unvar rightsave
                    return
               }
          goto manual.count
     
purchase.assemble:
     if "%assemble" = "NULL" then return
     # if (matchre("%discipline", "weapon|armor|blacksmith") && matchre("%assemble", "strips|string|backing|backing|padding|hilt|haft|cord|pole|handle|boss") && $roomid != $part.room) then gosub automove $part.room
     # else if $roomid != $supply.room then gosub automove $supply.room
     gosub automove $part.room
purchase.assemble_1:
     action (order) on
     gosub ORDER
     action (order) off
purchase.assemble_2:
     if $roomid != $part.room then gosub automove $part.room
     if !matchre("%discipline", "tailor|artif") then gosub ORDER %assemble
     else if matchre("%discipline", "tailor|artif") then
          {
               if "%discipline" = "tailor" then 
                    {
                         if "%assemble" = "handle" then gosub ORDER $handle.order
                         if "%assemble" = "large padding" then gosub ORDER $l.padding.order
                    }
               if "%discipline" = "artif" then
                    {
                         if (($zoneid = 150) && ("%assemble" = "abolition")) then gosub order $abolition.order
                         else gosub ORDER $%assemble.order
                    }
          }
     math asmCount1 subtract 1
     pause .2
     if "%discipline" = "artif" then gosub PUT_IT my sigil in my %main.storage
     else gosub PUT_IT my %assemble in my %main.storage
     if %asmCount1 <= 0 then return
     goto purchase.assemble_2

purchase.assemble2:
     if "%assemble2" = "NULL" then return
     if (matchre("%discipline", "weapon|armor|blacksmith") && matchre("%assemble2", "strips|backing|string|backing|padding|hilt|haft|cord|pole|handle|boss|backer") then 
		{
			if ($roomid != $part.room)) then gosub automove $part.room
		}
     elseif $roomid != $supply.room then 
          {
               if "%assemble2" = "mechanism" && $roomid != $ingot.buy then gosub automove $ingot.buy
               if "%assemble2" != "mechanism" then gosub automove $supply.room
          }
     purchase.assemble2_1:
     action (order) on
     gosub ORDER
     action (order) off
     purchase.assemble2_2:
     if matchre("%discipline", "tailor|tinkering|artif") then
          {
               if "%discipline" = "tailor" then
                    {
                         action (order) on
                         gosub ORDER
                         action (order) off
                         if "%assemble2" = "small padding" then gosub ORDER $s.padding.order
                         if "%assemble2" = "small backing" then gosub ORDER $s.backing.order
                         if "%assemble2" = "long cord" then gosub ORDER $l.cord.order
                         if "%assemble2" = "short cord" then gosub ORDER $s.cord.order
                    }
               if "%assemble2" = "mechanism" then
                    {
                         if $roomid != $ingot.buy then gosub automove $ingot.buy
                         gosub ORDER 11
                    }
               if "%discipline" = "artif" then
                    {
                         if (($zoneid = 150) && ("%assemble2" = "abolition")) then gosub order $abolition.order
                         else gosub ORDER $%assemble2.order
                    }
          }
     else gosub ORDER %assemble2
     math asmCount2 subtract 1
     pause .2
     if "%assemble2" != "mechanism" then 
          {
               if "%discipline" = "artif" then gosub PUT_IT my sigil in my %main.storage
               else gosub PUT_IT my %assemble2 in my %main.storage
          }
     if "%assemble2" = "mechanism" then gosub PUT_IT my ingot in my %main.storage
     if %asmCount2 <= 0 then return
     goto purchase.assemble2_2


#################################
#
#  Order Processing
#
#################################

process.order:
     if %diff.change = 1 then goto new.order
     if %tool.gone = 1 then gosub new.tool
     if ((matchre("%discipline", "carving|shaping|tailor|tinkering")) && ($MC_WORK.OUTSIDE = 1) && ($MC_PREFERRED.ROOM != $roomid)) then gosub automove $MC_PREFERRED.ROOM
     if ((($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "$roomid")) || (matchre("%discipline", "blacksmith|armor|weapon"))) then gosub find.room $work.room
     if matchre("%discipline", "weapon|armor|blacksmith") then
          {
               
               put store custom %work.material ingot in %main.storage
               var manual 0
               if (($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "\b$roomid\b")) then gosub find.room $work.room
               gosub EMPTY_HANDS
               pause 1
               gosub gather.ingot
               if (($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "\b$roomid\b")) then gosub find.room $work.room
               gosub anvilcheck
               if %anvilingot = 0 then gosub PUT_IT my %work.material ingot on anvil
               gosub GET my %discipline book
               pause 0.3
               #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
               pause 0.2
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
               pause 0.1
               gosub STUDY my book
               pause .5
               if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                    {
                         gosub GET %work.material ingot on anvil
                         gosub PUT_IT ingot in $MC_FORGING.STORAGE
                         math difficultytry add 1
                         echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         #put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         goto new.order
                    }
               send .MC_Pound
               waitforre ^(POUNDING DONE)|^(SMALL INGOT)
               var tempmessage $1
               if "%tempmessage" = "SMALL INGOT" then gosub small.mat ingot
               unvar tempmessage
               if %grind = 1 then gosub grind
          }
     if "%discipline" = "tailor" then
          {
               put store custom %work.material %order.pref in %main.storage
               if (($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "$roomid")) then gosub find.room $work.room
               gosub EMPTY_HANDS
               pause 2
               if "%order.pref" != "yarn" then
                    {
                         gosub gather.material %order.pref
                         send count my %order.pref
                         waitforre You count out (\d+) yard.*of material there
                         if %volume > $1 then gosub small.mat %order.pref
                         gosub GET my %discipline book
                         #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
                         if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
                         pause 0.1
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
                         pause 0.2
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
                         pause 0.1
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
                         pause 0.1
                         gosub STUDY my book
                         if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                              {
                                   gosub PUT_IT %work.material %order.pref in my %main.storage
                                   math difficultytry add 1
                                   echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                                   #put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                                   goto new.order
                              }
                         gosub PUT_IT my book in my %main.storage
                         send .MC_sew
                         waitforre ^SEWING DONE
                    }
               if "%order.pref" = "yarn" then
                    {
                         gosub gather.material yarn
                         send count my yarn
                         waitforre You count out (\d+) yards of material there
                         if %volume > $1 then gosub small.mat yarn
                         gosub GET my %discipline book
                         if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
                         #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
                         if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
                         pause 0.1
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
                         pause 0.2
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
                         pause 0.1
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
                         pause 0.1
                         ####
                         gosub STUDY my book
                         if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                              {
                                   gosub PUT_IT %work.material yarn in my %main.storage
                                   math difficultytry add 1
                                   echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                                   #put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                                   goto new.order
                              }
                         gosub PUT_IT my book in my %main.storage
                         send .MC_knit
                         waitforre ^KNITTING DONE
                    }
          }
     if "%discipline" = "carving" then
          {
               put store custom %work.material %order.pref in %main.storage
               if (($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "$roomid")) then gosub find.room $work.room
               gosub EMPTY_HANDS
               pause 2
               if "%order.pref" = "stack" then
                    {
                         gosub gather.material stack
                         send count my stack
                         waitforre You count out (\d+) (piece|pieces) of material there
                         if %volume > $1 then gosub small.mat stack
                         gosub GET my %discipline book
                         if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
                         #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
                         if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
                         pause 0.1
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
                         pause 0.2
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
                         pause 0.1
                         if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
                         pause 0.1
                         ####
                         gosub STUDY my book
                         if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                              {
                                   gosub PUT_IT %work.material stack in my %main.storage
                                   echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                                   #put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                                   math difficultytry add 1
                                   goto new.order
                              }
                         gosub PUT_IT my book in my %main.storage
                         if matchre("%full.order.noun", "bead|totem|figurine|statuette|statue") then gosub codex
                         send .MC_carve
                         waitforre ^CARVING DONE
                    }
               if "%order.pref" = "stone" then
                    {
                         echo NOT ADDED YET
                         exit
                    }
          }
     if "%discipline" = "shaping" then
          {
               put store custom %work.material %order.pref in %main.storage
               if (($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "$roomid")) then gosub find.room $work.room
               gosub EMPTY_HANDS
               gosub gather.material %order.pref
               send count my %order.pref
               waitforre You count out (\d+) pieces.*of lumber remaining
               if %volume > $1 then 
                    {
                         gosub small.mat %order.pref
                         send count my %order.pref
                         waitforre You count out (\d+) pieces.*of lumber remaining
                         if %volume > $1 then gosub lack.material
                    }
               gosub GET my %discipline book
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
               pause 0.2
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
               pause 0.1
               ####
               gosub STUDY my book
               if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                    {
                         gosub PUT_IT %work.material %order.pref in my %main.storage
                         math difficultytry add 1
                         echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         #put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         goto new.order
                    }
               gosub PUT_IT my book in my %main.storage
               if matchre("%full.order.noun", "bead|totem|figurine|statuette|statue") then gosub codex
               send .MC_shape
               waitforre ^SHAPING DONE
          }
     if "%discipline" = "tinkering" then
          {
               put store custom %work.material %order.pref in %main.storage
               if (($MC_WORK.OUTSIDE = 0) && !matchre("$work.room", "$roomid")) then gosub find.room $work.room
               gosub EMPTY_HANDS
               gosub gather.material %order.pref
               send count my %order.pref
               waitforre You count out (\d+) pieces.*of lumber remaining
               if %volume > $1 then gosub small.mat %order.pref
               gosub GET my %discipline book
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
               pause 0.2
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
               pause 0.1
               ####
               gosub STUDY my book
               if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                    {
                         gosub PUT_IT %work.material %order.pref in my %main.storage
                         echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         #put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         math difficultytry add 1
                         goto new.order
                    }
               gosub PUT_IT my book in my %main.storage
               send .MC_tinker
               waitforre ^TINKERING DONE
          }
     if "%discipline" = "remed" then
          {
               if (($MC_WORK.OUTSIDE = 0) && !matchre($work.room, $roomid)) then gosub find.room $work.room
               gosub EMPTY_HANDS
               gosub gather.material %herb1
               send count my %herb1
               waitforre You count out (\d+) pieces
               if %volume > $1 then gosub small.mat %herb1
               # gosub GET my %discipline book
               # if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               ### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES 
               # put turn my book to discipline %discipline
               # pause 0.5
               # pause 0.2
               gosub STUDY my book
               if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                    {
                         gosub PUT_IT %work.material %order.pref in my %main.storage
                         math difficultytry add 1
                         echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         # put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         goto new.order
                    }
               gosub PUT_IT my book in my %main.storage
               send .MC_mix $MC.order.noun 1 %herb1 %herb2
               waitforre ^ALCHEMY DONE
          }
     if "%discipline" = "artif" then
          {
               if $MC_WORK.OUTSIDE = 0 && !matchre($work.room, $roomid) then gosub find.room $work.room
               gosub EMPTY_HANDS
               gosub gather.material %order.pref
               gosub GET my %discipline book
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book
               #### ADDED THIS LINE TO HANDLE MT BOOKS THAT HAVE ALL DISCIPLINES
               if !matchre("$righthand|$lefthand", book) then gosub GET crafting book from port
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to discipline %discipline
               pause 0.2
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to chapter %order.chapter
               pause 0.1
               if matchre("$righthand", "crafting book") then gosub PUT turn my book to page %page
               pause 0.1
               ####
               gosub STUDY my book
               if (($MC_DIFFICULTY < 4) && (!%NOWO)) then 
                    {
                         gosub PUT_IT %order.pref in my %main.storage
                         math difficultytry add 1
                         echo *** Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         # put #echo >Log Too difficult to try crafting %full.order.noun, getting new Work Order. You might need %technique technique.
                         goto new.order
                    }
               gosub PUT_IT my book in my %main.storage
               send .MC_enchant "%work.material %order.pref" $MC.order.noun
               waitforre ^ENCHANTING DONE
          }
     if (($MC_END.EARLY = 1) || (%NOWO = 1)) then gosub expcheck
     gosub bundle.order
     if "%repair" = "on" then gosub check.tools
     if %order.quantity = 0 then 
          {
               if %NOWO then goto endearly
               goto order.summary
          }
     goto process.order
     
expcheck:
     if (matchre("%discipline", "weapon|armor|blacksmith") && ($Forging.LearningRate > 25)) then goto endearly
     if (matchre("%discipline", "tailor") && ($Outfitting.LearningRate > 25)) then goto endearly
     if (matchre("%discipline", "carving|shaping|tinkering") && ($Engineering.LearningRate > 25)) then goto endearly
     if (matchre("%discipline", "remed") && ($Alchemy.LearningRate > 25)) then goto endearly
     if (matchre("%discipline", "aritf") && ($Enchanting.LearningRate > 25)) then goto endearly
     return
#"
endearly:
     if matchre("$roomobjs", "(bucket|bin)") then
          {
          if matchre("$lefthand", "$MC.order.noun") then gosub PUT_IT #$lefthandid in $1
          if matchre("$righthand", "$MC.order.noun") then gosub PUT_IT #$lefthandid in $1
          }
     if matchre("$lefthand", "$MC.order.noun") then gosub PUT drop #$lefthandid
     if matchre("$righthand", "$MC.order.noun") then gosub PUT drop #$lefthandid
     gosub untie.early
     gosub PUT_IT my %society.type logbook in my %main.storage
	if matchre("(%clerktools)", "(%work.tools)") then gosub return.tools
     if matchre("$MC_KERTIGEN.HALO", "(?i)ON") then gosub HALO_RESTACK
     put #parse MASTERCRAFT DONE
     exit
     
untie.early:
     matchre return You have nothing bundled with the logbook|^Untie what\?
     matchre trash.early ^You untie the(?:.*)? (\S+) from the logbook
     send untie my %society.type logbook
     matchwait
#"
trash.early:
     var trash $1
     if matchre("$roomobjs", "(bucket|bin)") then
          {
          if matchre("$lefthand", "%trash") then gosub PUT_IT #$lefthandid in $1
          if matchre("$righthand", "%trash") then gosub PUT_IT #$lefthandid in $1
          }
     if matchre("$lefthand", "%trash") then gosub PUT drop #$lefthandid
     if matchre("$righthand", "%trash") then gosub PUT drop #$lefthandid
     goto untie.early


codex:
     gosub GET codex from my %main.storage
     gosub PUT turn codex to chapter 1
     gosub PUT turn codex to page 1
     gosub STUDY my codex
     gosub PUT_IT my book in my %main.storage
     return
     
bundle.order:
     if $MC_%society.type_NOWO then 
          {
               if matchre("$roomobjs", "(bucket|bin)") then
                    {
                    if matchre("$lefthand", "$MC.order.noun") then gosub PUT_IT #$lefthandid in $1
                    if matchre("$righthand", "$MC.order.noun") then gosub PUT_IT #$lefthandid in $1
                    }
               if matchre("$lefthand", "$MC.order.noun") then gosub PUT drop #$lefthandid
               if matchre("$righthand", "$MC.order.noun") then gosub PUT drop #$lefthandid
               math order.quantity subtract 1
               return
          }
     action (analyze) on
     math order.quantity subtract 1
	 bundle.order2:
	 matchre bundle.order2 ^\.\.\.wait|^Sorry
	 matchre bundle.order3 ^You analyze
     if !matchre("$righthand $lefthand", "$MC.order.noun") then gosub GET my $MC.order.noun
     if matchre("$lefthand", "$MC.order.noun") then send analyze #$lefthandid
     if matchre("$righthand", "$MC.order.noun") then send analyze #$righthandid
     matchwait 5
	 bundle.order3:
     action (analyze) off
     if contains("$MC.order.quality.fail", "%item.quality") then
          {
               gosub fail
               return
          }
     if "%deed.order" != "on" then
          {
               gosub GET my %society.type logbook from my %main.storage
               if !matchre("$righthand", "logbook") then gosub PUT swap
               send bundle my $MC.order.noun with my logbook
               send bundle my $righthand with my logbook
               pause 0.5
          }
     else gosub deed.order
     gosub PUT_IT my %society.type logbook in my %main.storage
     if contains("$righthand|$lefthand", "$MC.order.noun") then
          {
               if matchre("$roomobjs", "(bucket|bin)") then
                    {
                    if matchre("$lefthand", "$MC.order.noun") then gosub PUT_IT #$lefthandid in $1
                    if matchre("$righthand", "$MC.order.noun") then gosub PUT_IT #$lefthandid in $1
                    }
               if matchre("$lefthand", "$MC.order.noun") then gosub PUT drop #$lefthandid
               if matchre("$righthand", "$MC.order.noun") then gosub PUT drop #$lefthandid
               var NOWO 1
          }
     gosub EMPTY_HANDS
     if "%repair" = "on" then gosub check.tools
     return

grind:
     if matchre("$grind.room", "\b$roomid\b") then
          {
               send .MC_Grind
               waitforre ^GRINDING DONE
          }
     else
          {
               var temp.room $roomid
               gosub find.room $grind.room
               send .MC_Grind
               waitforre ^GRINDING DONE
               gosub automove %temp.room
               if (("$roomplayers" != "") && (%order.quantity > 1)) then gosub find.room $work.room
          }
     return
     
gather.ingot:
     var tempingot 1
     gosub bigenoughcheck
     if %bigenoughfinal < %order.quantity then gosub smelt
     gosub setold
gather.ingot1:
     if %vol.%ordinal(%tempingot) >= %volume then 
          {
               gosub GET %ordinal(%tempingot) %work.material ingot from my %main.storage
               var ingotchange %ordinal(%tempingot)
               evalmath newvolume %vol.%ordinal(%tempingot) - %volume
               goto ingotchange
          }
     math tempingot add 1
     if %tempingot > %ingot.item.count then 
          {
               gosub smelt
               return
          }
     goto gather.ingot1

bigenoughcheck:
     var bigenoughfinal 0
     var tracker 1
bigenoughcheck1:
     if %tracker > %ingot.item.count then return
     if "%vol.%ordinal(%tracker)" != "" then
          {
               evalmath bigenoughfinal (floor(%vol.%ordinal(%tracker)/%volume))+%bigenoughfinal
          }
     math tracker add 1
     goto bigenoughcheck1
     
setold:
     var oldvolume 1
setold_1:
     if %oldvolume > %ingot.item.count then return
     var oldvol.%ordinal(%oldvolume) %vol.%ordinal(%oldvolume)
     math oldvolume add 1
     goto setold_1
     
ingotchange:
     var tempchange %ingot.item.count
     if %vol.%ingotchange = %volume then 
          {
               var old %ingot.item.count
               evalmath ingot.item.count %ingot.item.count - 1
          }
     var new %ingot.item.count
ingotchange1:
     if %new < 1 then 
          {
               if %new != %old then var vol.%ordinal(%old)
               return
          }
     var vol.%ordinal(%new) %oldvol.%ordinal(%tempchange)
     math tempchange subtract 1
     if "%ordinal(%tempchange)" = "%ingotchange" then math tempchange subtract 1
     math new subtract 1
     if ((%tempchange < 1) && (%newvolume != 0)) then var vol.first %newvolume
     goto ingotchange1
     

gather.material:
     var get.mat $0
     if "%discipline" = "artif" then
          {
               if "%order.pref" = "rod" then var work.material bobcat
               if "%order.pref" = "totem" then var work.material bone
               if "%order.pref" = "bead" then var work.material heron
               if "%order.pref" = "wand" then var work.material rosewood
               if "%order.pref" = "runestone" then var work.material basic
               if "%order.pref" = "sphere" then var work.material small
               evalmath %get.mat.item.count %%get.mat.item.count - 1
               gosub GET %work.material %get.mat from my %main.storage
               return
          }
     if ("%discipline" = "remed") then 
          {
               if %%get.mat.material.volume < %mass.volume then 
                    {
                    var order.type %get.mat
                    gosub lack.material
                    }
               evalmath %get.mat.material.volume %%get.mat.material.volume - 25
               gosub GET %get.mat from my %main.storage
               if (!matchre("$righthand", "%get.mat") && ("%herb1", "junilar")) then
                    {
                         var herb1 junliar
                         var get.mat junliar
                         gosub GET %get.mat from my %main.storage
                    }
               if (!matchre("$righthand", "%get.mat") && ("%herb1", "junliar")) then
                    {
                         var herb1 junilar
                         var get.mat junilar
                         gosub GET %get.mat from my %main.storage
                    }
               return
          }
#     if "%get.mat" = "stone" then {}
     var itemno 1
gather.material_1:
     if %vol.%ordinal(%itemno) >= %volume then 
          {
               gosub GET %ordinal(%itemno) %work.material %get.mat from my %main.storage
               if ("%discipline" = "tailor") then
                    {
                         gosub get %work.material %get.mat from my %main.storage
                         gosub combine.check "%main.storage" %get.mat
                         gosub get %work.material %get.mat from my %main.storage
                    }
               var itemchange %ordinal(%itemno)
               evalmath newvolume %vol.%ordinal(%itemno) - %volume
               goto itemchange
          }
     math itemno add 1
     if %itemno > %%get.mat.item.count then 
          {
               gosub lack.material
               goto calc.material
          }
     goto gather.material_1

     send get %work.material %get.mat from my %main.storage
     waitforre ^(You get|What were)
     var temp $1
     if "%temp" = "You get" then return
     if "%temp" = "What were" then
     {
          send get %work.material deed from my %main.storage
          waitforre ^(You get|What were)
          var temp $1
          if "%temp" = "You get" then
          {
               send tap my deed
               pause 1
               if "$lefthand" = "Empty" && "$righthand" = "Empty" then gosub GET %get.mat
               pause .5
               if !contains("$righthand", "%get.mat") then send swap
               pause .5
               return
          }
     }
     gosub lack.material
     goto calc.material

itemchange:
     var tempchange %%get.mat.item.count
     if %vol.%itemchange = %volume then 
          {
               var old %%get.mat.item.count
               evalmath %get.mat.item.count %%get.mat.item.count - 1
          }
     var new %%get.mat.item.count
itemchange1:
     if %new < 1 then 
          {
               if %new != %old then var vol.%ordinal(%old)
               return
          }
     var vol.%ordinal(%new) %oldvol.%ordinal(%tempchange)
     math tempchange subtract 1
     if "%ordinal(%tempchange)" = "%itemchange" then math tempchange subtract 1
     math new subtract 1
     if ((%tempchange < 1) && (%newvolume != 0)) then var vol.first %newvolume
     goto itemchange1

small.mat:
     var tempitem $0
     gosub combine.check "%main.storage" %tempitem
     if "$righthand" != "Empty" then gosub PUT_IT my %tempitem in my %main.storage
     gosub parts.inv
     unvar tempitem
     if (%material.volume < %mass.volume) then gosub lack.material
     gosub clear
     goto process.order
   
combine.check:
     var combine.storage $1
     var combine.temp $2
     #if "%order.pref" = "bone" then var combine.temp stack
     if contains("$righthand|$lefthand", "book") then gosub PUT_IT book in %main.storage
     if matchre("%discipline", "weapon|armor|blacksmith") then
          {
               if matchre("$righthand|$lefthand", "%combine.temp") then gosub PUT_IT my %combine.temp in my %combine.storage
               return
          }
     var combine.parts 0
	 if contains("$righthand|$lefthand", "book") then gosub PUT_IT book in %main.storage
	gosub combine
     if matchre("$righthand|$lefthand", "%combine.temp") then gosub PUT_IT my %combine.temp in my %combine.storage
     return

smelt:
     if !matchre("$smelt.room", "\b$roomid\b") then gosub find.room $smelt.room
     gosub clearvolume
smelt_2:
     put .MC_Smelt %work.material
     waitfor SMELTING DONE
     put get ingot from %main.storage
     var vol.first %material.volume
     return
     
combine:
     var combine.loop 0
combine1:
     if !matchre("$righthand|$lefthand", "%combine.temp") then gosub GET my %combine.temp
#     if %%order.pref.item.count <= 1 then goto combine.end
     if !matchre("$righthand|$lefthand", "%combine.temp") then gosub GET my %combine.temp from %combine.storage
	 combine2:
	 matchre combine.end You must be holding both substances to combine them.  For more information, see HELP VERB COMBINE.
	 matchre combine.end ^That (.*) is too large to add more to\.|^The resulting
	 matchre combine.continue You combine
     send combine
	 matchwait 5
	 combine.continue:
     math %order.pref.item.count subtract 1
     if !matchre("$lefthand|$righthand", "Empty") then goto combine.end
     pause 0.5
     goto combine

combine.end:
     math combine.loop add 1
     if (matchre("%combine.temp", "junilar") && (%combine.loop < 2)) then
          {
               var combine.temp junliar
               goto combine1
          }
     if matchre("%combine.temp", "junliar") && (%combine.loop < 2)) then
          {
               var combine.temp junilar
               goto combine1
          }
	 var vol.first %material.volume
     if matchre("$righthand|$lefthand", "%combine.temp") then gosub PUT_IT %combine.temp in %combine.storage
     if matchre("$righthand|$lefthand", "%combine.temp") then gosub PUT_IT %combine.temp in %combine.storage
     unvar combine.temp
     unvar combine.storage
     return
   
fail:
    pause 1
    put #echo >Log Failed to craft %full.order.noun, you might need %technique technique.
    if matchre("$roomobjs", "(bucket|bin)") then gosub PUT_IT my $MC.order.noun in $1
    else gosub PUT drop my $MC.order.noun
    math fail add 1
    if %fail = 1 then gosub check.tools
    if %fail > 1 then gosub diff.change
    return

diff.change:
     if %fail2 = 1 then
          {
               echo ***  Work orders are too hard for you right now!
               echo ***  Get some new tools, techniques, or easier materials and try again!
               exit
          }
     var fail2 1
     var diff.change 1
     if "%work.difficulty" = "easy" then return
     if "%work.difficulty" = "challenging" then 
          {
               var work.difficulty easy
               if matchre("%discipline", "blacksmith|armor|weapon") then put #var MC_FORGING.DIFFICULTY easy
               if matchre("%discipline", "carving|shaping|tinkering") then put #var MC_ENG.DIFFICULTY easy
               if "%discipline" = "tailor" then put #var MC_OUT.DIFFICULTY easy
               if "%discipline" = "remed" then put #var MC_ALC.DIFFICULTY easy
               if "%discipline" = "artif" then put #var MC_ENCHANTING.DIFFICULTY easy
          }
     if "%work.difficulty" = "hard" then 
          {
               var work.difficulty challenging
               if matchre("%discipline", "blacksmith|armor|weapon") then put #var MC_FORGING.DIFFICULTY challenging
               if matchre("%discipline", "carving|shaping|tinkering") then put #var MC_ENG.DIFFICULTY challenging
               if "%discipline" = "tailor" then put #var MC_OUT.DIFFICULTY challenging
               if "%discipline" = "remed" then put #var MC_ALC.DIFFICULTY challenging
               if "%discipline" = "artif" then put #var MC_ENCHANTING.DIFFICULTY challenging
          }
     return

order.summary:
     pause 1
     gosub GET my %society.type logbook from my %main.storage
     send read my %society.type logbook
     pause 1
     if %order.quantity > 0 then goto turn.page
     else goto turn.in

turn.in:
     if !matchre("$roomid", "$master.room") then 
          {
               if (("$zoneid" = "67") && ("%discipline" = "artif")) then gosub automove $master.room
               else gosub automove $master.room(1)
          }
     gosub find.master
     if matchre("$lefthand", "logbook") then put swap
     matchre untie.order Apparently the work order time limit has expired
     matchre turn.in1 ^You hand .* your logbook
     matchre turn.in ^You can't give it to someone who's not here
     matchre check.for.order ^The work order isn't yet complete
     send give %master
     matchwait 30
     goto turn.in
turn.in1:
     pause .5
     math orders.completed add 1
     math repeat subtract 1
     echo ***  Order Complete!
     echo Total orders completed: %orders.completed
     echo Total coin intake: %coin.intake
     pause 3
     if %repeat > 0 then
          {
               echo ***  Doing another order!
               goto new.order
          }
     if ((matchre("blacksmith|armor|weapon", "%discipline")) && ($Forging.LearningRate < 20)) then goto new.order
     if ((matchre("carving|shaping|tinkering", "%discipline")) && ($Engineering.LearningRate < 20)) then goto new.order
     if (("%discipline" = "tailor") && ($Outfitting.LearningRate < 20)) then goto new.order
     if (("%discipline" = "remed") && ($Alchemy.LearningRate < 20)) then goto new.order
     if (("%discipline" = "artif") && ($Enchanting.LearningRate < 20)) then goto new.order
     gosub PUT_IT my logbook in my %main.storage
	if matchre("(%clerktools)", "(%work.tools)") then gosub return.tools
     if matchre("$MC_KERTIGEN.HALO", "(?i)ON") then gosub HALO_RESTACK
     put #parse MASTERCRAFT DONE
     exit

deed.order:
     gosub GET my packet
     send push $MC.order.noun with packet
     waitforre you record it on a deed for your records\.$
     gosub PUT_IT packet in %main.storage
     gosub GET my %society.type logbook from my %main.storage
     send bundle my deed with logbook
     waitforre ^you record it on a deed for your records\.$|^You notate the deed in
     return

#"
#################################
#
#  Commonly referenced Gosubs
#
#################################
buyingvolumechange:
     var oldnumber %ingot.item.count
     evalmath tempnumber %ingot.item.count + %reqd.order
     evalmath ingotdiff %tempnumber - %oldnumber
     gosub oldchange
     var tracker 1
buyingvolumechange1:
     if %tracker > %ingotdiff then return
     if "%work.material" = "bronze" then var vol.%ordinal(%tracker) 5
     if "%work.material" = "steel" then var vol.%ordinal(%tracker) 10
     math tracker add 1
     goto buyingvolumechange1
     
oldchange:
     if %oldnumber < 1 then return
     var vol.%ordinal(%tempnumber) %vol.%ordinal(%oldnumber)
     math tempnumber subtract 1
     math oldnumber subtract 1
     goto oldchange

lack.material:
     if "%reorder" = "off" then goto lack.material.exit
     if matchre("%discipline", "weapon|armor|blacksmith") then
          {
               if "%work.material" = "bronze" then var order.num 11
               if "%work.material" = "steel" then var order.num 9
               if !contains("bronze|steel", "%work.material") then goto lack.material.exit
               if "%work.material" = "bronze" then evalmath reqd.order ceiling((((%order.quantity-%bigenough)*%volume) - (%material.volume-(%volume*%bigenough)))/5)
               if "%work.material" = "steel" then evalmath reqd.order ceiling((((%order.quantity-%bigenough)*%volume) - (%material.volume-(%volume*%bigenough)))/10)
               gosub buyingvolumechange
               var main.storage $MC_FORGING.STORAGE
               var order.type ingot
               goto purchase.material
          }
     if "%discipline" = "carving" then
          {
               if "%order.pref" = "stack" then
                    {
                         if "%work.material" = "deer-bone" then var order.num 7
                         if "%work.material" = "wolf-bone" then var order.num 8
                         var order.type stack
                    }
               if "%work.material" = "alabaster" then
                    {
                         if "%deed.size" = "rock" then var order.num 1
                         if "%deed.size" = "boulder" then var order.num 2
                         var order.type deed
                    }
               if "%work.material" = "granite" then
                    {
                         if "%deed.size" = "rock" then var order.num 3
                         if "%deed.size" = "boulder" then var order.num 4
                         var order.type deed
                    }
               if "%work.material" = "marble" then
                    {
                         if "%deed.size" = "rock" then var order.num 5
                         if "%deed.size" = "boulder" then var order.num 6
                         var order.type deed
                    }
               if !contains("deer-bone|wolf-bone|alabaster|granite|marble", "%work.material") then goto lack.material.exit
               evalmath reqd.order (%mass.volume-%material.volume)/10
               evalmath reqd.order ceiling(%reqd.order)
               var main.storage $MC_ENGINEERING.STORAGE
               goto purchase.material
          }
     if "%discipline" = "tailor" then
          {
               if "%order.pref" = "leather" then
                    {
                         if "%work.material" = "rat-pelt" then var order.num 14
                         if "%work.material" = "cougar-pelt" then var order.num 15
                         var order.type leather
                    }
               if "%order.pref" = "cloth" then
                    {
                         if "%work.material" = "linen" then var order.num 7
                         if "%work.material" = "burlap" then var order.num 8
                         if "%work.material" = "wool" then var order.num 9
                         if "%work.material" = "silk" then var order.num 10
                         var order.type cloth
                    }
               if "%order.pref" = "yarn" then
                    {
                         var order.num 13
                         var order.type yarn
                         evalmath reqd.order (%mass.volume-%material.volume)/100
                         evalmath reqd.order ceiling(%reqd.order)
                         var main.storage $MC_OUTFITTING.STORAGE
                         goto purchase.material
                    }
               else 
                    {
                         evalmath reqd.order (%mass.volume-%material.volume)/10
                         evalmath reqd.order ceiling(%reqd.order)
                    }
               if !contains("rat-pelt|cougar-pelt|linen|burlap|wool|silk", "%work.material") then goto lack.material.exit
               var main.storage $MC_OUTFITTING.STORAGE
               goto purchase.material
          }
     if matchre("%discipline", "tinkering|shaping") then
          {
               if "%work.material" = "pine" then 
                    {
                         var order.num 9
                         evalmath reqd.order (%mass.volume-%material.volume)/5
                         evalmath reqd.order ceiling(%reqd.order)
                    }
               if "%work.material" = "maple" then 
                    {
                         var order.num 10
                         evalmath reqd.order (%mass.volume-%material.volume)/5
                         evalmath reqd.order ceiling(%reqd.order)
                    }
               if "%work.material" = "balsa" then  
                    {
                         var order.num 11
                         evalmath reqd.order (%mass.volume-%material.volume)/10
                         evalmath reqd.order ceiling(%reqd.order)
                    }
               var main.storage $MC_ENGINEERING.STORAGE
               goto purchase.material
          }
     if "%discipline" = "remed" then
          {
               if "%order.type" = "nemoih" then var order.num 3
               if "%order.type" = "plovik" then var order.num 4
               if "%order.type" = "jadice" then var order.num 5
               if "%order.type" = "nilos" then var order.num 6
               if "%order.type" = "georin" then var order.num 7
               if "%order.type" = "riolur" then var order.num 8
               if "%order.type" = "junliar" then var order.num 9
               if "%order.type" = "junilar" then var order.num 9
               if "%order.type" = "aevaes" then var order.num 10
               if "%order.type" = "genich" then var order.num 11
               if "%order.type" = "ojhenik" then var order.num 12
               if "%order.type" = "flowers" then var order.num 13
               if "%order.type" = "root" then var order.num 14
               if "%order.type" = "pollen" then var order.num 15     
               if !matchre("%order.type", "pollen|root") then evalmath reqd.order ceiling((%mass.volume-%%order.type.material.volume)/25)
               if matchre("%order.type", "pollen|root") then evalmath reqd.order ceiling((%mass.volume-%%order.type.material.volume)/4)
               goto purchase.material
          }
     if "%discipline" = "artif" then
          {
               evalmath reqd.order %order.quantity - %%order.pref.item.count
               if "%order.pref" = "totem" then var order.num 6
               if "%order.pref" = "runestone" then var order.num runestone
               if "%order.pref" = "wand" then var order.num wand
               if "%order.pref" = "sphere" then var order.num sphere
               if "%order.pref" = "rod" then var order.num rod
               if "%order.pref" = "bead" then var order.num bead
               goto purchase.material
          }
     goto lack.material.exit

purchase.material:
     var purchaselabel purchase.material
     action var need.coin 1 when ^The attendant shrugs and says, "Ugh, you don't have enough
     #"
     if $roomid != $supply.room then gosub automove $supply.room
	 gosub EMPTY_HANDS
first.order:
     if matchre("%discipline", "carving|shaping|tailor|tinkering") then
          {
               if (!matchre("$righthand", "Empty") && !matchre("$lefthand", "Empty")) then gosub EMPTY_HANDS
               if %reqd.order >= 1 then    
                    {
                         gosub ORDER %order.num
                         math reqd.order subtract 1
#                        gosub PUT_IT my %order.type in my %main.storage
                         math %order.pref.item.count add 1
						 gosub combine.order
                         if matchre("%order.type", "lumber") then 
                              {
                                   if "%work.material" = "balsa" then math material.volume add 10
                                   else math material.volume add 5
                              }
                         if matchre("%order.type", "leather|cloth|stack") then math material.volume add 10
                         if matchre("%order.type", "yarn") then math material.volume add 100
                         if ("%discipline" = "remed") then math %herb1.material.volume add 25
                         if %reqd.order < 1 then 
							{
								gosub PUT_IT my %order.type in my %main.storage
								return
							}
                         goto first.order
                    }
               else return
          }
          
     if matchre("%discipline", "weapon|armor|blacksmith") then
          {
               if %reqd.order >= 1 then
                    {
                         gosub EMPTY_HANDS
                         gosub ORDER %order.num
                         math reqd.order subtract 1
                         gosub PUT_IT my %order.type in my %main.storage
                         math %order.pref.item.count add 1
                         if "%work.material" = "bronze" then math material.volume add 5
                         if "%work.material" = "steel" then math material.volume add 10
                         if %reqd.order < 1 then return
                         goto first.order
                    }
               else return
          }
     if "%discipline" = "remed" then
          {
               gosub EMPTY_HANDS
               if %reqd.order >= 1 then    
                    {
                         gosub ORDER %order.num
                         math reqd.order subtract 1
                         gosub PUT_IT my %order.type in my %main.storage
                         math %herb1.item.count add 1
                         if (("%discipline" = "remed") && (!matchre("%order.type", "qun pollen|ithor"))) then math %order.type.material.volume add 25
                         else math %order.type.material.volume add 4
                         if %reqd.order < 1 then return
                         goto first.order
                    }
               else return
          }
     if "%discipline" = "artif" then
          {
               gosub EMPTY_HANDS
               if %reqd.order >= 1 then    
                    {
                         gosub ORDER %order.num
                         #gosub combine.order
                         math reqd.order subtract 1
                         gosub PUT_IT my %order.pref in my %main.storage
                         if %reqd.order < 1 then return
                         goto first.order
                    }
               else return
          }     
     return
     
combine.order:
	 gosub GET my %work.material %order.type from my %main.storage
	 if ("$righthand" != "$lefthand") then 
		{
			gosub EMPTY_HANDS
			return
		}
     matchre combine.order ^\.\.\.wait|^Sorry
     match combine.order.return You combine
     match return too large
     match return You must be holding
     put combine
     matchwait
combine.order.return:
     math %order.pref.item.count subtract 1
	 return
     
stowright:
     gosub PUT_IT #$righthandid in %main.storage
     gosub GET %order.type from %main.storage
     goto combine.order
     

switch:
      gosub PUT_IT %order.type in %main.storage
      gosub GET second %order.type from %main.storage
      goto combine.order
       
lack.material.exit:
         echo Not Enough Material To Make %order.quantity $MC.order.noun !
         put #parse Need material
	     if matchre("(%clerktools)", "(%work.tools)") then gosub return.tools
         exit

return:
     return

clearvolume:
     var vol.first
     var vol.second
     var vol.third
     var vol.fourth
     var vol.fifth
     var vol.sixth
     var vol.seventh
     var vol.eighth
     var vol.ninth
     var vol.tenth
     var vol.eleventh
     return