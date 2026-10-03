Script Usage:<br>
.mastercraft -- to only do one work order<br>
.mastercraft (no. of orders) --to perform more than one<br>
.mastercraft (no. of orders) (difficulty)  --to ask for a different difficulty than you have set in your character profile.<br>

Mastercraft takes the tedium out of workorders, and works in practically every society for practically every craft. 
It will get and turn in orders, buy extra parts, repair tools, manage materials, check item quality, 
and will even reduce your order difficulty if you fail the item too often.

There are a few things to note in using this script, however:

1. You must have all required tools and books in your crafting bag for the craft you choose<br>
  (Self-repairing tools also requires oil and brush to be available).
2. Workorders can only be automated within societies, using the mastercraft script. Individual scripts can be run elsewhere if you desire<br>
   But part purchasing and order turn-in will NOT be automatic when the scripts are run solo.
3. Make sure your stock materials (specifically ingots) are managed in sizes your character can lift.<br> 
   If he can't pick up an ingot, I don't know how you'll be able to cut it down to a more manageable size.
4. If you have less than 50 Forging skill, your analyzes may not pick up item quality or ingot size.<br> 
   To do orders with low forging skill, be sure to have a yardstick to measure with. Your character will otherwise not be able to tell if he has enough material to actually complete the order.     
5. Alchemy recently added support for higher level (challenging/hard) work orders using FORAGED herbs that cannot be bought at the store<br>
   Script assumes you have sufficient Outdoorsmanship to forage the herbs (Around ~350+ is needed??), it forages them and process them (press/crush) to be used in the recipes
6. Last but not least, don't change the scriptfile names (ie mastercraft.cmd to mc.cmd) unless you want to parse through them yourself<br>
   and edit the script calls. Each subscript is called by name here and runs as a **second, separate script.**<br>
   This allows for each subscript to be used standalone. Also, some subscripts (pound, carve, knit, sew, etc.) check to see if Mastercraft.cmd is running before continuing<br>
  Be careful when renaming scriptfiles.<br>

Be sure to setup your character's crafting profile in **MC_SETUP.CMD BEFORE USING THESE SCRIPTS.** 
There are some things scripting cannot do for you, such as make personal decisions.

Included in this suite:<br>
   mastercraft.cmd<br>
   mc_include.cmd<br>
   mc_pound.cmd<br>
   mc_sew.cmd<br>
   mc_knit.cmd<br>
   mc_carve.cmd<br>
   mc_enchant.cmd<br>
   mc_shape.cmd<br>
   mc_smelt.cmd<br>
   mc_grind.cmd<br>
   mc_weave.cmd<br>
   mc_spin.cmd<br>
   mc_tinker.cmd<br>
   mc_triggers.cmd<br>
    
Each script can be run completely standalone from Mastercraft if you want to create multiple items or just individual orders. 
Using them as such will require you to be responsible for your own material management and quality control. 
Be sure to read the beginning section for each script if you intend to use it standalone.

 Happy Crafting!
