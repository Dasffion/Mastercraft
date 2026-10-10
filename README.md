<h1>Script Usage:</h1>
<b>EDIT: MC_Setup.cmd - This contains variables to control crafting settings for all your characters</b><br><br>
.mastercraft -- to only do one work order<br>
.mastercraft (no. of orders) --to perform more than one<br>
.mastercraft (no. of orders) (difficulty)  --to ask for a different difficulty than you have set in your character profile.<br><br>

.mastercraft 2 - complete 2 work orders at your set difficulty <br>
.mastercraft 4 challenging - Complete 4 challenging workorders<br>

Simply setup your variables in MC_Setup, go to the crafting society you want to train in and start mastercraft.<br>
Mastercraft automatically detects which discipline to train based on the Society you start it in.<br>

Mastercraft takes the tedium out of workorders, and works in practically every society for practically every craft. 
It will get and turn in orders, buy extra parts, repair tools, manage materials, check item quality, 
and will even reduce your order difficulty if you fail the item too often.

<h1>MAIN FEATURES:</h1>
<h3>- Trains all 5 Crafting skills<br><br>
- Automates getting and completing Work Orders from Society Masters<br><br>
- Automatically stocks necessary crafting materials<br><br>
- Automatically repairs tools when damaged<br>
    Self-repair tools if Tool Repair tech is known<br>
    NPC/clerk repair if cannot self-repair<br><br>
- Automatically tunes down difficulty<br>
    if you fail to craft an item too many times</h3>

<h3>Supports the following disciplines:<br><br>
FORGING - Weapon / Armor / Blacksmithing<br>
ENGINEERING - Carving / Shaping / Tinkering<br>
OUTFITTING - Tailoring<br>
ALCHEMY - Remedies<br>
ENCHANTING - Artificing</h3><br>

<b>There are a few things to note in using this script, however:</b><br>

1) You must have ALL required tools and books in your crafting bag for the craft you choose<br>
  ( Discipline book / Logbook for work orders / All the tools for that profession )<br> 
  *It does support the special "All Disciplines" Crafting Book by default - no config needed*<br><br>
  NOTE: Mastercraft does buy normal shop supplies/materials such as:<br>
  leather/bone, sigils, ingots, coal nuggets, herbs, oil, brush, etc<br> 
  You just need to make sure you have all the tools!<br><br>
2) You must have some gold/plat for the script to handle buying supplies / repairing tools<br><br>

3) Script DOES handle Self-Repairing tools if you have the blacksmithing technique (Advanced Tool Repair)<br>
  If tools are damaged beyond self-repair - It will take them to the NPC repair like normal<br><br>

4) Workorders are only automated using .mastercraft in crafting societies.<br> 
   Individual scripts can be run elsewhere if you desire<br>
   Part purchasing and order turn-in will NOT be automatic when the scripts are run solo.<br><br>

5) Make sure your stock materials (specifically ingots) are managed in sizes your character can lift.<br> 
   If he can't pick up an ingot, I don't know how you'll be able to cut it down to a more manageable size.<br><br> 

6) If you have less than 50 Forging skill, your analyzes may not pick up item quality or ingot size.<br> 
   To do orders with low forging skill, be sure to have a yardstick to measure with.<br>
   Your character will otherwise not be able to tell if he has enough material to actually complete the order.<br><br>      

7) Recently added Alchemy support for many higher level (challenging/hard) workorders w/ FORAGED herbs that can't be bought at the store.
   Script assumes you have sufficient Outdoorsmanship to forage the herbs (Around ~350+ needed??) 
   It forages the herbs and processes them (press/grind) to be used in the recipes<br><br>

8) KERTIGEN HALO support was added in a past patch - but may not work well at all (untested recently)<br>
   Recommend DO NOT USE HALO AT ALL! Halos are EXTREMELY unwieldy and have terrible downsides!<br>
   If ever add/remove a tool that isn't in PERFECT condition - It DAMAGES *ALL* THE TOOLS IN YOUR HALO!<br>
   Not only that, but they are very clumsy to work with. A highly flawed MT item<br>
   DO NOT USE HALOS AT ALL. It is not worth the slightly reduced itemcount.<br><br>

9) TECHNIQUES - as you gain crafting ranks you can learn more techniques for each discipline.<br>
   Type CRAFT to see your available 'points' - Recommended to learn new techniques often.<br>
   Techniques in your discipline can enable faster crafting / better results / access to higher end recipes / etc.<br>
   Don't forget to choose a CAREER and HOBBY as that will get you even more points to work with<br><br>

10) NOTE - Mastercraft is primarily written/intended as an XP/TRAINING script.<br>
    It is not designed to train every single possible item and does NOT support every single craft recipe.<br> 
    Although a very large number of recipes are supported<br><br>

11) Last but not least, don't change the scriptfile names (ie mastercraft.cmd to mc.cmd) unless you want to parse through them yourself
   and edit all the script calls. Each subscript is called by name here and runs as a **second, separate script.**
   This allows for each subscript to be used standalone. Also, some subscripts (pound, carve, etc.) check if Mastercraft.cmd is running
   Be very careful when renaming scriptfiles!<br><br>
   
Be sure to setup your character's crafting profile in <b>**MC_SETUP.cmd**</b> BEFORE USING THESE SCRIPTS!<br>
There are some things scripting cannot do for you, such as make personal decisions.<br><br>

<b>MC_SETUP.cmd</b> contains all the variables to control your characters crafting settings<br>
This is the ONLY script you need to edit<br>

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
    
Each script can be run completely standalone from Mastercraft<br>
If you want to create multiple items or just individual orders.<br> 
Using them as such will require you to be responsible for your own material management and quality control.<br>
Be sure to read the beginning section for each script if you intend to use it standalone.<br>

 Happy Crafting!
