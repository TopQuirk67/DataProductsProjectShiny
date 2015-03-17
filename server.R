library(shiny)
load(file="pbpdata.RData")      # loads model a single time.  Model is stored in variable "fit"
                                # also loads "testset" the cross-validation data frame
downname <- c("First","Second","Third","Fourth")
names(downname)<-c("1","2","3","4")

shinyServer(
        function(input, output, session) {
                output$downdist <- renderText({
                        paste(downname[input$Down],"and",input$Dist)
                })
                output$ydtogo   <- renderText({as.character(
                        calc_yard_to_go(input$SideFld,input$YdLine)
                )})
                output$scorediff <- renderText({as.character(
                        input$OffScore-input$DefScore
                )})
                output$secleft <- renderText({as.character(
                        15*60*(4-input$Qtr) + 60*input$Minute + input$Second
                )})
                output$winprob <- renderText({
                        regtime <- 15*60*(4-input$Qtr) + 60*input$Minute + input$Second
                        ydline  <- calc_yard_to_go(input$SideFld,input$YdLine)
                        diff    <- input$OffScore-input$DefScore
                        this_wp <- wp(fit,input$Down,input$Dist,ydline,diff,regtime)
                        sprintf("%.4f +- %.4f",round(this_wp[1],4),round(this_wp[2],4))
                })
                output$crossval <- renderText({
                        sprintf("%4d / %4d = %6.4f +- %6.4f",0,0,0,0)
                })
        }
)

##### Restrictions via 
##### updateNumericInput()

calc_yard_to_go <- function(ch_side,num_yard) {
        if (ch_side=="0") {
                # defense side of field
                return(num_yard)
        } else if (ch_side=="1") {
                # offense side of field
                return(100-num_yard)
        }
}

wp <- function(fit,down,togo,ydline,diff,regtime) {
        df_input<-data.frame(down=factor(down,levels=c("1","2","3","4")),
                             togo=togo,ydline=ydline,diff=diff,regtime=regtime)
        wp_interval <- predict(fit,df_input,type="link",se.fit=TRUE)
        critval<-qnorm(0.975) # assume normality on the linear predictor
        upr1<-wp_interval$fit + (critval * wp_interval$se.fit)
        lwr1<-wp_interval$fit - (critval * wp_interval$se.fit)
        fit1 <- wp_interval$fit
        
        fit2 <- fit$family$linkinv(fit1)
        upr2 <- fit$family$linkinv(upr1)
        lwr2 <- fit$family$linkinv(lwr1)
        wp_output   <- c(predict(fit,df_input,type="response"),(upr2-lwr2)/2)
        
        return(wp_output)
}