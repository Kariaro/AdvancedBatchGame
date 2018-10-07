# AdvancedBatchGame
I dont always do batch, but when I do. I do it good.


This code is just me having fun with my hobby.
Copy and share. Do what you want. :D

### Creating your own map

In text.txt is the information about how I did a simple map but if you want to hand craft one

```
# Comments is fun? YES ........
#
# You can comment in this file

Width: 15    # Width of the worlds
Height: 5    # Height of the worlds
Player: @    # How your player gonna look
Health: 0    # I have no support for this but whatever

DimensionWidth: 0   # The amount of worlds to the right
DimensionHeight: 1  # The amount of worlds down

SpawnX: 10   # Where the player is gonna spawn
SpawnY: 10   # Same as above
SpawnDX: 0   # What dimension the player spawns in
SpawnDY: 0   # Same as above
Blocks: "#"  # If you want to have a space as a block you need to use ÿ insted

# And the last touch
# You need to end the init with a END
# And you cant comment after END
# The game will behave strange and unexpected
# I havent tried but its not implemented in that way
#
# After end you write a dimension like this
# Map: <x coord>, <y coord>
# ....... ALL THE CHARACTERS REPRESENTING THE MAP.
# Map: <x coord>, <y coord>
# more characters ...
#
# Well i think its better if you check out text.txt for more info.

END
Map 0,0
###############
123456789ABCDEF
123456789ABCDEF
123456789ABCDEF
###############
Map 0,1
###############
123456789ABCDEF
123456789ABCDEF
123456789ABCDEF
###############
```
