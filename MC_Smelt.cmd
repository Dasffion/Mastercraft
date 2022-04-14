#Metal Smelting
#debug 10
if_1 goto Continue
echo Usage is: .mc_smelt <material>
echo To smelt more than one material separate them by a space .smelt <material> <material>
exit
Continue:
include mc_include.cmd
gosub setmaterial
eval matcount count("%material", "|")
gosub itemcountclear
var matstow %tool.storage
gosub EMPTY_HANDS
var swap.tongs 0
var worn.tongs 0
var tongs.adj 0



action var worn.tongs 1 when ^You tap some.*(segmented|articulated).*tongs that you are wearing\.$
action var tongs.adj 0 when ^With a yank you fold the shovel
action var tongs.adj 1 when ^You lock the tongs into a fully extended position
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


action INSTANT goto finish when ^At last the metal appears to be thoroughly mixed and you pour it into an ingot mold
goto smeltstart

SetMaterial:
     var material %1
SetMaterial_1:
     shift
     if_1 then 
          {
          var material %material|%1
          goto setmaterial_1
          }
     return
     
itemcountclear:
     counter set 0
itemcountclear_1:
     if %c > %matcount then return
     var %material(%c)nugget 0
     var %material(%c)ingot 0
     var %material(%c)fragment 0
     var %material(%c)bar 0
     counter add 1
     goto itemcountclear_1

SmeltStart:
     counter set 0
     action (settype) on
     action (settype) math $1$2 add 1 when (%material) (ingot|nugget|fragment|bar)
     put inv $MC_FORGING.STORAGE
     if matchre("$MC_FORGING.STORAGE", "(?i)portal") then send inv my eddy
     waitfor [Use INVENTORY
     action (settype) off
     evalmath check %%material(0)nugget + %%material(0)ingot + %%material(0)bar + %%material(0)fragment
     if %check = 0 then goto end
SmeltStart_1:
     if %c > %matcount then goto gettool
     gosub GetMat nugget
     gosub GetMat ingot
     gosub GetMat fragment
     gosub GetMat bar
     counter add 1
     goto SmeltStart_1

GetMat:
     var mattype $1
     if %%material(%c)%mattype < 1 then return
	 GetMat2:
     match putmat You get
     match GetMat3 What do you want to get
     match GetMat3 What were you referring
     match GetMat2 ...wait
     send get my %material(%c) %mattype
     matchwait
GetMat3:
     var mattype $1
     if %%material(%c)%mattype < 1 then return
	 GetMat2:
     match putmat You get
     match return What do you want to get
     match return What were you referring
     match GetMat2 ...wait
     send get my %material(%c) %mattype from my portal
     matchwait

PutMat:
     math %material(%c)%mattype subtract 1
     match toomuch at once would be dangerous
     match GetMat You put
     send put %mattype in cruc
     matchwait

TooMuch:
     gosub PUT_IT my %material(%c) %mattype in my $MC_FORGING.STORAGE
     goto gettool

GetTool:
     gosub ToolCheckRight $MC_STIRROD
     goto stir

Stir:
     match stir ...wait
     match turn crucible's sides
     match fuel needs more fuel
     match bellows stifled coals
     match bellows unable to consume its fuel
     match smeltstart You can only mix a crucible if it has something inside of it.
     match stir Roundtime
     send stir cruc with $MC_STIRROD
     matchwait

Fuel:
     gosub ToolCheckLeft $MC_SHOVEL
     if %swap.tongs = 1 then
          {
               if %tongs.adj = 0 then send adjust my $MC_TONGS
          }
     gosub Action push fuel with $MC_SHOVEL
     gosub STOW_LEFT
     goto stir

Bellows:
     gosub ToolCheckLeft $MC_BELLOWS
     gosub Action push $MC_BELLOWS
     gosub STOW_LEFT
     goto stir

Turn:
     send turn cruc
     goto stir

Finish:
	 pause 0.1
     if matchre("$righthand|$lefthand", "ingot") then gosub PUT_IT ing in my $MC_FORGING.STORAGE
     gosub STOW_RIGHT
     goto end

End:
     put #parse SMELTING DONE
     Echo All material used. Script complete.
     exit
