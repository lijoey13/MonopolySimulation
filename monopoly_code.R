library(R6)

# gameboard and decks -----------------------------------------------------

gameboard <- data.frame(
  space = 1:40, 
  title = c(
    "Go", "Mediterranean Avenue", "Community Chest", "Baltic Avenue",
    "Income Tax", "Reading Railroad", "Oriental Avenue", "Chance",
    "Vermont Avenue", "Connecticut Avenue", "Jail", "St. Charles Place",
    "Electric Company", "States Avenue", "Virginia Avenue",
    "Pennsylvania Railroad", "St. James Place", "Community Chest",
    "Tennessee Avenue", "New York Avenue", "Free Parking",
    "Kentucky Avenue", "Chance", "Indiana Avenue", "Illinois Avenue",
    "B & O Railroad", "Atlantic Avenue", "Ventnor Avenue", "Water Works",
    "Marvin Gardens", "Go to jail", "Pacific Avenue",
    "North Carolina Avenue", "Community Chest", "Pennsylvania Avenue",
    "Short Line Railroad", "Chance", "Park Place", "Luxury Tax",
    "Boardwalk"), stringsAsFactors = FALSE)
chancedeck <- data.frame(
  index = 1:15, 
  card = c(
    "Advance to Go", "Advance to Illinois Ave.",
    "Advance to St. Charles Place", "Advance token to nearest Utility",
    "Advance token to the nearest Railroad",
    "Take a ride on the Reading Railroad",
    "Take a walk on the Boardwalk", "Go to Jail", "Go Back 3 Spaces",
    "Bank pays you dividend of $50", "Get out of Jail Free",
    "Make general repairs on all your property", "Pay poor tax of $15",
    "You have been elected Chairman of the Board", 
    "Your building loan matures"), stringsAsFactors = FALSE)
communitydeck <- data.frame(
  index = 1:16, 
  card = c(
    "Advance to Go", "Go to Jail",
    "Bank error in your favor. Collect $200", "Doctor's fees Pay $50",
    "From sale of stock you get $45", "Get Out of Jail Free",
    "Grand Opera Night Opening", "Xmas Fund matures", "Income tax refund",
    "Life insurance matures. Collect $100", "Pay hospital fees of $100",
    "Pay school tax of $150", "Receive for services $25",
    "You are assessed for street repairs",
    "You have won second prize in a beauty contest",
    "You inherit $100"), stringsAsFactors = FALSE)

# RandomDice class --------------------------------------------------------

RandomDice <- R6Class(
  classname = "RandomDice",
  public = list(
    verbose = NA,
    initialize = function(verbose = FALSE){
      stopifnot(is.logical(verbose))
      self$verbose = verbose
    },
    roll = function() {
      outcome <- sample(1:6, size = 2, replace = TRUE)
      if(self$verbose){
        cat("Dice Rolled:", outcome[1], outcome[2], "\n")
      }
      outcome
    }
  )
)

# Preset Dice -------------------------------------------------------------

PresetDice <- R6Class(
  classname = "PresetDice",
  public = list(
    verbose = NA,
    preset_rolls = double(0),
    position = 1,
    initialize = function(rolls, verbose = FALSE){
      stopifnot(is.logical(verbose))
      stopifnot(is.numeric(rolls))
      self$preset_rolls = rolls
      self$verbose = verbose
    },
    roll = function(){
      if(self$position > length(self$preset_rolls)){
        stop("You have run out of predetermined dice outcomes.")
      }
      outcome <- c(self$preset_rolls[self$position], 
                   self$preset_rolls[self$position + 1])
      self$position <- self$position + 2
      if(self$verbose){
        cat("Dice Rolled:", outcome[1], outcome[2], "\n")
      }
      outcome
    }
  )
)


# Chance and Community Decks ----------------------------------------------

# This R6 class object shuffles the card deck when initialized.
# It has one method $draw(), which will draw a card from the deck.
# If all the cards have been drawn (position = deck length), then it will
# shuffle the cards again.
# The verbose option cats the card that is drawn on to the screen.
CardDeck <- R6Class(
  classname = "CardDeck",
  public = list(
    verbose = NA,
    deck_order = double(0), 
    deck = data.frame(),
    position = 1,
    initialize = function(deck, verbose = FALSE){
      stopifnot(is.data.frame(deck),
                is.numeric(deck[[1]]),
                is.character(deck[[2]]))
      self$deck_order <- sample(length(deck[[1]]))
      self$verbose <- verbose
      self$deck <- deck
    },
    draw = function(){
      if(self$position > length(self$deck_order)){
        # if we run out of cards, shuffle deck
        # and reset the position to 1
        if(self$verbose){
          cat("Shuffling deck.\n")
        }
        self$deck_order <- sample(length(self$deck[[1]]))
        self$position <- 1
      }
      outcome <- c(self$deck_order[self$position]) # outcome is the value at position
      self$position <- self$position + 1 # advance the position by 1
      if(self$verbose){
        cat("Card:", self$deck[outcome, 2], "\n")
      }
      outcome # return the outcome
    }
  )
)


# R6 Class SpaceTracker ---------------------------------------------------

SpaceTracker <- R6Class(
  classname = "SpaceTracker",
  public = list(
    counts = rep(0, 40),
    verbose = TRUE,
    tally = function(x){
      self$counts[x] <- self$counts[x] + 1
      if(self$verbose){
        cat("Added tally to ", x, ": ", gameboard$title[x], ".\n", sep = "")
      }
    },
    initialize = function(verbose){
      self$verbose <- verbose
    }
  )
)

# R6 Class Player ---------------------------------------------------------

Player <- R6Class(
  classname = "Player",
  public = list(
    pos = 1,
    double = 0,
    jail = 0,
    
    verbose = TRUE,
    move_fwd = function(n){
      if(self$verbose) {
        cat("Player starts at ", self$pos,": ", gameboard$title[self$pos], ".\n", sep = "")
        cat("Player moves forward ", n, ".\n", sep = "")
      }
      self$pos <- self$pos + n
      if(self$pos > 40){
        self$pos <- self$pos - 40
      }
      if(self$verbose){
        cat("Player is now at ", self$pos,": ", gameboard$title[self$pos], ".\n", sep = "")
      }
    },
    
    go_to_jail = function() {
      self$pos <- 11
      if(self$verbose) {
        cat("Player goes to jail. \n")
      }
    },
    
    jail_count = function() {
      self$jail <- self$jail + 1
    },
    
    in_jail = function() {
      if (self$verbose) {
        cat("Person stays in jail.\n")
      }
    },
    
    reset_jail = function() {
      self$jail <- 0
    },
    
    tally_double = function() {
      self$double <- self$double + 1
      if (self$verbose) {
        cat("Doubles count is now ", self$double, ".\n", sep = "")
      }
    },
    
    reset_double = function() {
      self$double <- 0
    },
    
    exit_jail = function() {
      if (self$verbose) {
        cat("Player's third turn in jail. Player must exit jail.\n")
        cat("Player exits jail\n")
      }
      self$jail <- 0
    },
    
    exit_jail_doubles = function() {
      if (self$verbose) {
        cat("In jail but rolled doubles.\n")
        cat("Player exits jail.\n")
      }
      self$jail <- 0
    },
    ## landing on chance
    draw_chance = function() {
      if (self$verbose) {
        cat("Draw a chance card.\n")
      }
      chance_drawn <- chance$draw()
      if (chance_drawn %in% c(1:9)) {
        if (chance_drawn == 1) {
          self$pos <- 1
        } else if (chance_drawn == 2) {
          self$pos <- 25
        } else if (chance_drawn == 3) {
          self$pos <- 12
        } else if (chance_drawn == 4) { # nearest utility
          if (self$pos == 8) {
            self$pos <- 13
          } else if (self$pos == 23) {
            self$pos <- 29
          } else if (self$pos == 37) {
            self$pos <- 13 
          }
        } else if (chance_drawn == 5) {
          if (self$pos == 8) {
            self$pos <- 16
          } else if (self$pos == 23) {
            self$pos <- 26
          } else if (self$pos == 37) {
            self$pos <- 6
          }
        } else if (chance_drawn == 6) {
          self$pos <- 6
        } else if (chance_drawn == 7) {
          self$pos <- 40
        } else if (chance_drawn == 8) {
          self$pos <- 11
        } else if (chance_drawn == 9) {
          self$pos <- self$pos - 3
        } else if (chance_drawn == 11) {
          self$jail <- 0
        }
        if (self$verbose) {
          if (self$pos != 11)
            cat("Player moves to ", self$pos, ": ", gameboard$title[self$pos], ".\n", sep = "")
        }
      } 
    },
    draw_community = function() {
      if (self$verbose) {
        cat("Draw a Community Chest card.\n")
      }
      community_drawn <- community$draw()
      if (community_drawn == 1) {
        self$pos <- 1
      } else if (community_drawn == 2) {
        self$pos <- 11
      }
    },
    initialize = function(verbose = FALSE, pos = 1) {
      self$verbose <- verbose
      self$pos <- pos
    }
  )
)


# turn taking: MAIN function  ------------------------------------------

take_turn <- function(player, spacetracker) {
  
  ## not in jail:
  if (player$jail == 0) {
    dice_rolls <- dice$roll()
    ## rolling non-double:
    if (dice_rolls[1] != dice_rolls[2]) {
      player$move_fwd(sum(dice_rolls))
      #community chest:
      if (player$pos %in% c(3, 18, 34)) {
        spacetracker$tally(player$pos)
        player$draw_community()
        if (player$pos == 11) {
          player$go_to_jail()
          player$jail_count()
        } else if (player$pos == 1) {
          if(player$verbose) {
            cat("Player moves to 1: Go.\n")
          }
        }
      }
      # chance:
      if (player$pos %in% c(8, 23, 37)) {
        spacetracker$tally(player$pos)
        player$draw_chance()
        if (player$pos == 11) {
          player$go_to_jail()
          player$jail_count()
        }
        if (player$pos == 34) {
          player$draw_community()
        }
      }
      # land on go to jail:
      if (player$pos == 31) {
        player$go_to_jail()
        player$jail_count()
      }
      ## rolling double:
    } else if (dice_rolls[1] == dice_rolls[2]) {
      while (dice_rolls[1] == dice_rolls[2] && player$double < 2 && player$jail == 0) {
        player$tally_double()
        player$move_fwd(sum(dice_rolls))
        #community chest:
        if (player$pos %in% c(3, 18, 34)) {
          spacetracker$tally(player$pos)
          player$draw_community()
          if (player$pos == 11) {
            player$go_to_jail()
            player$jail_count()
          } else if (player$pos == 1) {
            if (player$verbose) {
              cat("Player moves to 1: Go.\n")
            }
          }
        }
        # chance:
        if (player$pos %in% c(8, 23, 37)) {
          spacetracker$tally(player$pos)
          player$draw_chance()
          if (player$pos == 11) {
            player$go_to_jail()
            player$jail_count()
            break
          }
        }
        if (player$pos == 31) {
          player$go_to_jail()
          player$jail_count()
          break
        } 
        if (!(player$pos %in% c(3, 18, 34, 8, 23, 37))) {
          spacetracker$tally(player$pos)
        }
        if (player$verbose) {
          cat("\nPlayer rolled doubles, so they take another turn.\n")
        }
        dice_rolls <- dice$roll()
      }
      
      if (dice_rolls[1] == dice_rolls[2] && player$double == 2) {
        player$tally_double()
        player$go_to_jail()
        player$reset_double()
        player$jail_count()
      } else if (player$jail == 0) {
        player$reset_double()
        player$move_fwd(sum(dice_rolls))
        #community chest:
        if (player$pos %in% c(3, 18, 34)) {
          spacetracker$tally(player$pos)
          player$draw_community()
          
          if (player$pos == 11) {
            player$go_to_jail()
            player$jail_count()
          } else if (player$pos == 1) {
            if (player$verbose) {
              cat("Player moves to 1: Go.\n")
            }
          }
        }
        # chance:
        if (player$pos %in% c(8, 23, 37)) {
          spacetracker$tally(player$pos)
          player$draw_chance()
          if (player$pos == 11) {
            player$go_to_jail()
            player$jail_count()
          }
        }
        if (player$pos == 31) {
          player$go_to_jail()
          player$jail_count()
        }
      }
    }
    if (!(player$pos %in% c(3, 18, 34, 8, 23, 37))) {
      spacetracker$tally(player$pos)
    }
    ## in jail:
  } else if (player$jail > 0) {
    dice_rolls <- dice$roll()
    if (dice_rolls[1] == dice_rolls[2]) {
      player$exit_jail_doubles()
      player$move_fwd(sum(dice_rolls))
    } else if (dice_rolls[1] != dice_rolls[2] && player$jail < 3) {
      player$in_jail()
      player$jail_count()
    } else if (dice_rolls[1] != dice_rolls[2] && player$jail >= 3) {
      player$exit_jail()
      player$move_fwd(sum(dice_rolls))
    }
    spacetracker$tally(player$pos)
  }
}

