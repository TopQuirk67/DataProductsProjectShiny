---
title       : American Football Win Percentage
subtitle    : A shiny app to estimate WP and its uncertainty from an in-game situation using a binomial GLM.
author      : Gareth Houk
job         : Football Analyst
logo        : FootballToolkitLogo.jpg
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : standalone    # {standalone, draft}
knit        : slidify::knit2slides
---

## What is Win Probability?

- Win Probability (WP) estimates the probability that the team on offense in an <A href="http://en.wikipedia.org/wiki/American_football">American Football</A> game will win the game based on the in-game situation.
- For example, a team that is very far ahead with very little time left would have a win probability close to 1.00, or 100%.
- As another example, at the beginning of the game, just after kickoff with the score tied at zero, each team has a 50% chance of winning (we don't attempt to use prior record, quality of team, or betting odds to handicap teams).
- The inputs to calculating WP are: 
  - <A href="http://football.about.com/cs/football101/a/bl_101downs.htm">Down and distance</A> 
  - Field position (distance from the line of scrimage to the goal line)
  - Score (i.e. offensive team points and defensive team points)
  - Game time remaining 
- A fuller reference on WP is at <A href="http://www.advancedfootballanalytics.com/index.php/home/stats/stats-explained/win-probability-and-wpa">Brian Burke's fabulous website</A>.

---

## Modeling Win Probability with a Binomial GLM

I chose a Binomial Generalized Linear Regression for this modeling project.  The idea is that winning 
is either a 1 or a 0, but the game situation should influence the binomial probability.  

I started with <A href="http://archive.advancedfootballanalytics.com/2010/04/play-by-play-data.html">CSV's</A> of all NFL plays from 2002-12 and, through a distinctly non-reproducible process, parsed every game to determine win/loss, and cleaned the data to develop a database of  386076 plays.  Randomly selecting 70% of this sample as the "train" set, I used the following code to create the model.  I have not made this database or code available.  


```r
glm(win~diff+regtime+ydline+down+togo,data=train,family="binomial")
```


This model is stored and accessed by my shiny app which takes user input, creates variables suitable for input to the model, and calculates both win probability and the standard error on WP.

Please try the App out.  It lives on 
<A href="https://topquirk67.shinyapps.io/DataProductsProjectShiny/">shiny.io</A>.

---

## Model Performance

So let's see how the model performs.  First we set in a game situation with a big lead (diff=21) at mid-field, first down and 10 with three minutes left in the game.  We find WP=0.987, a very high liklihood of winning, which makes sense.

Now let's try the other example we suggested, just after kickoff, so diff=0, 80 yards to the endzone, first down and 10, and 3650 seconds in the game.  We get WP=0.504, very close to the 50% we expect.

In general, the model behaves as you would expect. For example, as the score differential gets larger, WP increases.  As time gets smaller with a positive score differential, WP gets larger.  As field position gets closer to the endzone, WP increases.  

Play with 
<A href="https://topquirk67.shinyapps.io/DataProductsProjectShiny/">it</A>... 
it's fun!

---

## Future Plans for the Model

The model isn't perfect!  With the initial inputs for the 
<A href="https://www.youtube.com/watch?v=U7rPIg7ZNQ8">most critical play</A>
of Super Bowl XLIX (the defaults for App), only get WP of 
0.532, while 
<A href="http://wp.advancedfootballanalytics.com/winprobcalc1.php">Brian's WP Calculator</A> gives 88%,
and I think most football fans would agree that Seattle was very likely to score and win on that play.

I am planning to look into improvements in the WP calculation:
- Go back to the <A href="http://pubsonline.informs.org/doi/abs/10.1287/opre.19.2.541">original paper</A> to see how they did it
- More sophisticated modeling with nonlinearity on the inputs and possibly interaction terms between the inputs. 
- Adding responsible cross-validation via a nearest-neighbor test-sample search and simple binomial calculation of WP for the input in-game situation. In the App I have provided space for this but have yet to implement the code.

Thanks for reading!

