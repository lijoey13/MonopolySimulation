# Monopoly Board Game Simulation
This program uses R to create a simulation of the classic board game, **Monopoly**.

**GOAL:** The goal is to observe and analyze which spaces on the board get landed on the most, by simulating the movement of pieces while keeping track of which squares the pieces land on.

## Rules for Movement

The Monopoly Board is effectively a circle with 40 spaces on which a player can land. Players move from space to space around the board in a circle (square).

The number of spaces a player moves is determined by the roll of 2 dice. Most often, the player will roll the dice,
move the number of spaces shown on the dice, land on a space, and end their turn there. If this were the entire
game, there would be an equal probability of landing on all 40 spaces after many turns - and the distribution of
space frequency would be uniform.

There are, however, several rules which create variation in the frequency of landing on different spaces.

### Go to Jail

One space, “Go to Jail” sends players directly to jail. You can never actually land on this space. As soon as the player ‘lands’ here, they are immediately sent to jail, and the jail space gets counted as landed upon. This is the only space on the game board that moves a player’s piece. The count of how
often this space is landed on will **always** be 0.

### Rolling Doubles

If a player rolls doubles (two of the same number), the player moves their piece, and then gets to roll the dice again
for another move. However, if a player rolls doubles three times in a row, they are sent directly to jail. (The third space
that the player would have ‘landed on’ does not count, but the jail space gets counted as landed on.)

### Card Decks: Chance and Community Chest

When a player lands on a “Chance” or “Community Chest” space, they draw a card from the respective deck and follows its instructions. The instructions will sometimes give money to or take money from the player with no change in the player’s position on the board. 

Other times, the card will instruct the player to move to another space on the board. The list of cards that can be drawn from each deck is provided.
There are nine cards in the Chance deck that move the player’s token. There are two cards in the Community Chest
deck that move the player’s token. All other cards do not move the player’s token. 

A card may say ‘move to the nearest railroad’ or ‘move to the nearest utility’ or even ‘go to property . . . ’. In these
cases, the player always moves forward. So if a player is on ‘Oriental Avenue,’ the nearest railroad is ‘Pennsylvania
Railroad’ and NOT ‘Reading Railroad.’

For the sake of this simulation, the Chance and Community Chest get counted as landed on when the player
lands on the Chance or Community Chest space. The player may also generate another count if the card moves the
player to another space on the board. In those cases, a tally is counted for the Chance/Community Chest space, the
token is moved, and then a tally is counted for the space where the player ends their turn.

### Jail

If a player lands on space 11 (Jail) simply from rolling the dice, he is not in Jail. He is ‘just visiting’ jail. He
generates a tally for landing on jail, and his play continues on as normal.

A player can be sent to jail in several ways:

  •  he rolls doubles three times in a row;

  • he lands on the “go to jail” space;

  • he draws a card that sends hims to jail.

As soon as the player is sent to jail, their token moves to jail (space 11), generates a count for landing on jail, and
their turn ends immediately.

On the next turn, the player begins in jail and the player will roll the dice. If they roll doubles on the dice, they get
out of jail and moves the number of spaces the dice show. However, even though they rolled doubles, they do NOT
roll again. They takes their move out of jail and their turn ends. If they do not roll doubles, they stay in jail.

A player cannot stay in jail for more than **three** turns. On the third turn they begin in jail, they roll the dice and
moves the number of spaces the dice show no matter what. If they roll doubles, they exit but do not roll again. If they
do not roll doubles, they still exit and do not roll again.

Play then continues as normal.

For this simulation, each time a player ends their turn in Jail, a tally will be counted as having been ‘landed upon.’
There are more rules on jail that include paying a fee to get out early, or using a get out of jail free card. These rules will not be implemented.
We will simply simulate a ‘long stay’ strategy for Jail. This means that the player will
never pay the fee to get out jail early. They will roll the dice and only leave jail if they get doubles or it is their third turn in jail.


## Space Definitions

  • Utilities: Electric Company and Water Works

  • Railroads: Reading Railroad, Pennsylvania Railroad, B & O Railroad, Shortline Railroad

# Simulation

Run 1,000 simulations of a two-player game that lasts 150 turns. This is a total of over 3 hundred
thousand tosses of the dice - 1000 games x 150 turns x 2 players + additional rolls if the player gets doubles.




