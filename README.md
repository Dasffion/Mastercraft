<h1>Script Usage:</h1><br>
.mastercraft -- to only do one work order<br>
.mastercraft (no. of orders) --to perform more than one<br>
.mastercraft (no. of orders) (difficulty)  --to ask for a different difficulty than you have set in your character profile.<br><br>

Mastercraft takes the tedium out of workorders, and works in practically every society for practically every craft. 
It will get and turn in orders, buy extra parts, repair tools, manage materials, check item quality, 
and will even reduce your order difficulty if you fail the item too often.

There are a few things to note in using this script, however:

1. You must have all required tools and books in your crafting bag for the craft you choose<br><br> 
2. You must have some gold/plat for the script to handle buying supplies / repairing tools<br><br> 
3. Script DOES handle Self-Repairing tools if you have the tech - requires oil and brush<br>
  If tools are damaged beyond self-repair - It will take them to the NPC repair like normal<br><br>
4. Workorders can only be automated within societies, using the mastercraft script.<br> 
   Individual scripts can be run elsewhere if you desire<br>
   Part purchasing and order turn-in will NOT be automatic when the scripts are run solo.<br><br>
5. Make sure your stock materials (specifically ingots) are managed in sizes your character can lift.<br> 
   If he can't pick up an ingot, I don't know how you'll be able to cut it down to a more manageable size.<br><br> 
6. If you have less than 50 Forging skill, your analyzes may not pick up item quality or ingot size.<br> 
   To do orders with low forging skill, be sure to have a yardstick to measure with.<br>
   Your character will otherwise not be able to tell if he has enough material to actually complete the order.<br><br>      
7. Alchemy recently added support for higher level (challenging/hard) work orders using FORAGED herbs that cannot be bought at the store<br>
   Script assumes you have sufficient Outdoorsmanship to forage the herbs (Around ~350+ is needed??)<br> 
   It forages the herbs and process them (press/crush) to be used in the recipes<br><br> 
8. KERTIGEN HALO support was added in a previous patch - but it may not work well at all (untested recently)<br>
   My recommendation is to NOT USE A HALO AT ALL! Halos are EXTREMELY unwieldy and have a TERRIBLE DOWNSIDE!
   DAMAGING ALL YOUR TOOLS at once if you put ANY tool into it that is not in PERFECT CONDITION
   They are an extremely flawed MT item and my recommendation is DO NOT USE HALOS<br><br> 
9. Last but not least, don't change the scriptfile names (ie mastercraft.cmd to mc.cmd) unless you want to parse through them yourself
   and edit all the script calls. Each subscript is called by name here and runs as a **second, separate script.**
   This allows for each subscript to be used standalone. Also, some subscripts (pound, carve, etc.) check if Mastercraft.cmd is running
   Be very careful when renaming scriptfiles!<br>

Be sure to setup your character's crafting profile in <b>**MC_SETUP.CMD BEFORE USING THESE SCRIPTS!**</b><br>
There are some things scripting cannot do for you, such as make personal decisions.<br>

<b>Included in this suite:</b><br>
   mastercraft.cmd<br>
   mc_include.cmd<br>
   mc_setup.cmd<br>
   mc_mix.cmd<br>
   mc_pound.cmd<br>
   mc_carve.cmd<br>
   mc_sew.cmd<br>
   mc_enchant.cmd<br>
   mc_knit.cmd<br>
   mc_shape.cmd<br>
   mc_smelt.cmd<br>
   mc_grind.cmd<br>
   mc_spin.cmd<br>
   mc_tinker.cmd<br>
   mc_weave.cmd<br>
   mc_triggers.cmd<br>
    
Each script can be run completely standalone from Mastercraft if you want to create multiple items or just individual orders. 
Using them as such will require you to be responsible for your own material management and quality control. 
Be sure to read the beginning section for each script if you intend to use it standalone.

 Happy Crafting!
