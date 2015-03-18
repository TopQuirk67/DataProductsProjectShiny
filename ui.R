# ui.R

shinyUI(fluidPage(
        titlePanel("American Football Win Percentage"),
        h4("For a given game situation in American football, this shiny ",
           "app calculates the win probability for the team on offense."),
        h5("The basic idea is that the team's probability of winning depends on the score, time left in the game,",
           "current field position, and down & distance.  For example, if the offense is ahead by 35 points, it is",
           "very likely that they will win.  If it's a tied game with 3 seconds remaining and the offense near",
           "midfield, the win probability should be very close to 50% - a tossup.",
           "I have set the intial inputs to the critical Seattle goal line play at the end of Super Bowl XLIX.",
           "The model is based on a binomial GLM which ",
           "was developed using a randomly selected training set consisting ",
           "of 70% of the NFL regular- and post-season plays from 2002-2012. ",
           "A brief description of American football does not really exist",
           "but you can try ","http://en.wikipedia.org/wiki/American_football",
           "or just have more fun by changing the inputs at the top and watching the ",
           "win probability at the bottom change in response. ",
           "The original dataset can be found ",
           "at http://archive.advancedfootballanalytics.com/2010/04/play-by-play-data.html, however, I had to do significant ",
           "data cleaning to create my own data set from it.  I have not provided the cleaning code.  ",
           "A description of Win Probability can be found ",
           "at http://www.advancedfootballanalytics.com/index.php/home/stats/stats-explained/win-probability-and-wpa.",
           "Also, if you really know football - sorry, my model isn't very good!  I intend to work more on ",
           "cross-validation and on developing a more accurate model in the future.  The GLM is a vanilla binomial model",
           "on time, field position, score difference, down and distance, and as such doesn't completely capture ",
           "what we suspect should be true - i.e. Seattle was at least 90% likely to score and win in the setup state. ",
           "I provide this model only because it sufficiently addresses the assignment.  Thanks for trying it!"),
        h5("The Git with the code is at https://github.com/TopQuirk67/DataProductsProjectShiny ."
        ),
        
        
        fluidRow(
                h4("Down and Distance"),
                column(4,
                       sliderInput("Down",label=h5("Down"),min = 1, max = 4, value = 2, step= 1)), 
                
                column(4,
                       numericInput("Dist",label=h5("Distance (yards for first down, 1-99)"), 
                                    min = 1, max = 99, value=1, step = 1)
                       ),
                column(4,
                       h5("You entered:"),
                       h5(verbatimTextOutput("downdist"))
                       )
        ),
        
        fluidRow(
                h4("Field Position"),
                column(4,
                       radioButtons("SideFld", 
                                    label = h5("Side of Field"),
                                    choices= list("Defense" = 0, "Offense" = 1),
                                    selected = 0)
                       ),
                column(4,
                       numericInput("YdLine",label=h5("Yardline (1-50)"), 
                                    min = 1, max = 50, value=1, step = 1)
                       ),
                column(4,
                       h5("You entered:"),
                       h5(verbatimTextOutput("ydtogo")),
                       h5("Yards to Opposing Goal Line")
                       )
                
        ),
        
        fluidRow(
                h4("Score"),
                column(4,
                       numericInput("OffScore",label=h5("Points, Offense:"), 
                                    min=0, max=74, value=24, step=1)
                ),
                
                column(4,
                       numericInput("DefScore",label=h5("Points, Defense:"), 
                                    min=0, max=74, value=28, step=1)
                ),
                
                column(4,
                       h5("You entered:"),
                       h5(verbatimTextOutput("scorediff")),
                       h5("Point Differential")
                )
                
        ),
        
        fluidRow(
                h4("Game Time"),
                column(4,
                       sliderInput("Qtr",label=h5("Quarter"),min = 1, max = 4, value = 4, step= 1)
                ),
                
                column(2,
                       numericInput("Minute",label=h5("Minutes (0-15):"), 
                                    min=0, max=15, value=0, step=1)
                ),
                column(2,
                       numericInput("Second",label=h5("Seconds (0-60):"), 
                                    min=0, max=60, value=26, step=1)
                ),
                
                column(4,
                       h5("You entered:"),
                       h5(verbatimTextOutput("secleft")),
                       h5("Seconds Left in the Game")
                )
                
        ),
#        hr(),
        fluidRow(
                h3("Output:"),
                column(6,
                       h4("Binomial GLM Model Win Probability:"),
                       verbatimTextOutput("winprob")
                ),
                column(6,
                       h4("Cross-Validation Reserved for Future Implementation:"),
                       verbatimTextOutput("crossval")
                )
        )
                
))
