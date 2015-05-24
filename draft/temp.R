shinyServer(
    
    function(input, output) {
        
        # calculate the age based on DoB
        age <- reactive(as.numeric(input$input_age))
        # calculate gender baesd on input_gender
        gender <- reactive(tolower(input$input_gender))
        # calculate the height based on input_height
        height <- reactive(as.numeric(gsub("[a-zA-z ]", "", input$input_height)))
        # calculate the weight based on input_weight
        weight <- reactive(as.numeric(gsub("[a-zA-z ]", "", input$input_weight)))
        # calculate the bmi based on height and weight
        bmi <- reactive(weight() / (height() / 100)^2)
        # calculate the indicator of bmi based on bmi
        ind_bmi <- reactive(if(bmi() >= 40){"over"} else if(bmi() <= 18.5){"short"} else {"normal"})
        # calculate the hrs of exercise per week
        exercise <- reactive(as.numeric(input$input_exercise_hr_per_w))
        # calculate the walks per week
        walk <- reactive(as.numeric(input$input_walking_per_w))
        # calculate the cigarette per week
        cigar <- reactive(as.numeric(input$input_cigarette_per_w))
        # calculate the driving mileage per week
        drive <- reactive(as.numeric(input$input_mileage_per_year))
        
        # get the data frame based on the input criteria
        df <- reactive(
            
            if (walk() >= 1.5 | exercise() > 3 | cigar() > 0 | drive() > 0){
                # setup some vectors about the change in related life parameters when sliders are changed
                # numebr of people surved at a certain age
                lx <- vector()
                lx[1] <- 100000
                # number of people alive between a certain age and age + 1
                Lx <- vector()
                # motality rate at a certain age
                mx <- vector()
                # life expectancy at a certain age
                ex <- vector()
                
                # a temp df based on the age, gender and bmi
                df_temp <- df_life[df_life$Age >= age() & df_life$gender == gender() & df_life$bmi == ind_bmi(), ]
                
                # a regression model based on the temp data, between mx and ex
                
                # model <- lm(mx ~ ex + log(ex) + I(ex^2) + I(ex^3) + I(ex^4) + I(ex^5), data = df_temp)
                
                if (walk() >= 1.5){
                    qx <- df_temp$qx * (1 - .44) ## reduce .44 death risk if walk over 1.5 times per week
                    for (i in 1:dim(df_temp)[1]){
                        lx[i + 1] <- trunc(lx[i] * (1 - qx[i]))
                        Lx[i] <- trunc(lx[i + 1] + lx[i] * qx[i] / 2)
                        mx[i] <- round(trunc(lx[i] * qx[i]) / Lx[i], 5)
                    }
                    i = 1
                    
                    for (j in 1:dim(df_temp)[1]){
                        ex[j] <- round(sum(Lx[j:dim(df_temp)[1]]) / lx[j], 1)
                    }
                    j = 1
                    
                    df_temp$mx <- mx
                    df_temp$ex <- ex
                }
                
                if (exercise() > 3){
                    if (exercise() < 35){
                        df_temp$ex <- round(df_temp$ex + ((exercise() * 4) / 365) * df_temp$ex, 1)
                        df_temp$mx <- if (round(predict(model, newdata = df_temp), 5) <= 0) {
                            df_temp$mx
                        }
                        else
                            round(predict(model, newdata = df_temp), 5) # a simple linear regression coefficient, this part needs improvement later
                    }
                    else
                        df_temp$ex <- round(df_temp$ex - ((exercise() * 4) / 365) * df_temp$ex, 1)
                    df_temp$mx <- if (round(predict(model, newdata = df_temp), 5) <= 0) {
                        df_temp$mx
                    }
                    else
                        round(predict(model, newdata = df_temp), 5) # a simple linear regression coefficient, this part needs improvement later
                }
                
                if (cigar() > 0){
                    df_temp$ex <- round(df_temp$ex - ((cigar()/7 * 3) / 365) * df_temp$ex, 1)
                    df_temp$mx <- if (round(predict(model, newdata = df_temp), 5) <= 0) {
                        df_temp$mx
                    }
                    else
                        round(predict(model, newdata = df_temp), 5) # a simple linear regression coefficient, this part needs improvement later
                }
                
                if (drive() > 0){
                    df_temp$ex <- round(df_temp$ex - ((drive()/1600 * 0.00001) / 365) * df_temp$ex, 1)
                    df_temp$mx <- if (round(predict(model, newdata = df_temp), 5) <= 0) {
                        df_temp$mx
                    }
                    else
                        round(predict(model, newdata = df_temp), 5) # a simple linear regression coefficient, this part needs improvement later
                    
                }
                df_temp
            }
            else
                df_life[df_life$Age >= age() & df_life$gender == gender() & df_life$bmi == ind_bmi(), ]
        )
        
        # get the life expectancy
        ex <- reactive(df()[df()$Age == age(), "ex"])
        
        # get the motality rate
        mx <- reactive(df()[df()$Age == age(), "mx"])
        
        # get the maximum motality rate in the data frame df
        max_mx <- reactive(max(df()[df()$Age >= age(), "mx"]))
        
        # get the max age in the data frame df
        max_age <- reactive(max(df()$Age) - 1)
        
        # output the years left
        output$output_yrs_left <- renderText({paste("Statistically, I can only live", ex(), "years and there is", round(mx() * 100, 2), "% of chance I will die this year. Pretty sad, isn't it? But the good thing is, this can be different if I change my life style (try playing with the slider bars)" )})
        
        # output the plot
        output$Plot <- renderPlot({            
            g_top <- ggplot(data = df(), aes(x = Age, y = ex))
            g_top <- g_top + geom_line(colour = "#74c3ea", size = 2)
            g_top <- g_top + geom_vline(xintercept = age(), colour = "grey")
            g_top <- g_top + geom_segment(data = df()[df()$Age == age(), ], aes(x = -Inf, y = ex, xend = Age, yend = ex), colour = "grey", linetype = "dashed")
            g_top <- g_top + geom_point(data = df()[df()$Age == age(), ], aes(x = Age, y = ex), colour = "yellow", alpha = .7, size = 7)
            g_top <- g_top + annotate("text", x = (99 + age()) / 2, y = ex() * 1.05, label = paste("Years left:", ex()), size = 4, colour = "#74c3ea")
            g_top <- g_top + scale_x_continuous(
                limits = c(trunc(age() / 10) * 10, 99)
                , breaks = seq(
                    from = trunc(
                        age() / 10) * 10
                    , to = max_age(), 5
                )
            )
            g_top <- g_top + theme_bw()
            g_top <- g_top + theme(
                axis.title.y = element_text(colour = "#74c3ea", face = "bold")
                , axis.text.y = element_text(colour = "#74c3ea")
                , axis.title.x = element_blank()
                , axis.text.x = element_blank()
                , axis.ticks.x = element_blank()
                , plot.margin = unit(c(1, 1, 0, 1), "lines")
            )
            g_top <- g_top + xlab("Age") + ylab("Years Left")
            
            g_bottom <- ggplot(data = df(), aes(x = Age, y = mx))
            g_bottom <- g_bottom + geom_bar(stat = "identity", fill = "salmon", size = 2, alpha = .8)
            g_bottom <- g_bottom + geom_vline(xintercept = age(), colour = "grey")
            g_bottom <- g_bottom + geom_segment(data = df()[df()$Age == age(), ], aes(x = -Inf, y = mx, xend = Age, yend = mx), colour = "grey", linetype = "dashed")
            g_bottom <- g_bottom + geom_point(data = df()[df()$Age == age(), ], aes(x = Age, y = mx), colour = "yellow", alpha = .7, size = 7)
            g_bottom <- g_bottom + annotate("text", x = (99 + age()) / 2, y = max_mx() / 1.05, label = paste("Probability of dying: ", round(mx() * 100, 2), "%"), size = 4, colour = "salmon")
            g_bottom <- g_bottom + scale_x_continuous(
                limits = c(trunc(age() / 10) * 10, 99)
                , breaks = seq(
                    from = trunc(age() / 10) * 10
                    , to = max_age(), 5
                )
            )
            g_bottom <- g_bottom + scale_y_continuous(
                labels = percent
            )
            g_bottom <- g_bottom + theme_bw()
            g_bottom <- g_bottom + theme(
                axis.title.y = element_text(colour = "salmon", face = "bold")
                , axis.text.y = element_text(colour = "salmon")
                , plot.margin = unit(c(0, 1, 1, 1), "lines")
            )
            g_bottom <- g_bottom + xlab("Age") + ylab("Motality Rate")
            
            grid.newpage()
            grid.draw(rbind(ggplotGrob(g_top), ggplotGrob(g_bottom), size = "last"))
            
        })
        
        # output the table
        output$Table <- renderDataTable({
            df()
        })
        
        
    }
)