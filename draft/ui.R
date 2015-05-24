shinyUI(
    # set up a fiuid page
    fluidPage(
        # bootstrap theme
        theme = "bootstrap.css"
        
        # the first row only includes the navigation bar
        , fluidRow(
            # navigation bar
            navbarPage(
                title = "How long can I live? :("
                , tabPanel("Life Expectancy")
                , tabPanel("Coming Soon")
                )
            )
        
        , hr()
        
        # the second row only includes two columns, one for input bar, the other for output tabs
        , fluidRow(
            # input bar
            column(
                width = 3
                , title = "input bar"
                
                # a radio button for gender
                , radioButtons(
                    inputId = "input_gender"
                    , label = "My Gender"
                    , choices = c("Female", "Male")
                    , selected = "Female"
                    , inline = T
                    )
                # a date input for DoB
                , sliderInput(
                    inputId = "input_age"
                    , label = "My Age"
                    , min = 0
                    , max = 97
                    , value = 19
                    )
                
                # a select input for height (cm)
                , selectInput(
                    inputId = "input_height"
                    , label = "My Height"
                    , choices = paste(rep(100:250, 1), "cm")
                    , selected = "170 cm"
                    )
                
                # a select input for weight
                , selectInput(
                    inputId = "input_weight"
                    , label = "My Weight"
                    , choices = paste(rep(30:200, 1), "kg")
                    , selected = "60 kg"
                )
                
                , hr()
                
                # a select input for exercise hours per week
                , sliderInput(
                    inputId = "input_exercise_hr_per_w"
                    , label = "Hours of Excercise"
                    , min = 0
                    , max = 84
                    , value = 0
                    )
                
                # a select input for walking per week
                , sliderInput(
                    inputId = "input_walking_per_w"
                    , label = "No. of Brisk Walks of 30 mins"
                    , min = 0
                    , max = 84
                    , value = 0
                )
                
                # a select input for cigarette per week
                , sliderInput(
                    inputId = "input_cigarette_per_w"
                    , label = "No. of Cigarettes"
                    , min = 0
                    , max = 140
                    , value = 0
                )
                
                # a select input for driving mileage per year
                , sliderInput(
                    inputId = "input_mileage_per_year"
                    , label = "Kilometres of driving"
                    , min = 0
                    , max = 50000
                    , step = 5000
                    , value = 0
                )
            )
            
            , column(
                width = 9
                , title = "output tabs"
                
                , verbatimTextOutput("output_yrs_left")
                
                # a tab set panel
                , tabsetPanel(
                    selected = "Plot"
                    
                    # a tab panel for plot
                    , tabPanel(
                        title = "Plot"
                        , plotOutput("Plot", width = "100%", height = "560px")
                    )
                    
                    # a tab panel for description
                    , tabPanel(
                        title = "Table"
                        , dataTableOutput("Table")
                        )
                    
                    # a tab panel for life table
                    , tabPanel(
                        title = "Help (Documentation)"
                        , helpText("Documentation - How long can I live")
                        , helpText("Version: 1.0")
                        , helpText("Author: Noah Xiao")
                        , helpText("LinkedIn: au.linkedin.com/in/mengnoahxiao")
                        , helpText("GitHub: noahhhhhh")
                        , helpText("1. Background")
                        , helpText("This “How long can I live” app is served as an interactive tool which helps you to understand what is the statistical life expectancy at your age and how likely you would die within this year. Also, you can use several sliders (exercise, walk, cigarette consumption, and driving mileage) to see what would be changed if you decide to change your life style.")
                        , helpText("This app still has a lot to improve, happy to discuss and welcome your feedback :)")
                        , helpText("2. Guide")
                        , helpText("There are three main sections in the app, namely the parameters in the left panel, the text result in the right upper panel, and two plots in the right lower panel.")
                        , helpText("2.1 Parameters")
                        , helpText("You can use checkbox, dropdown list as well as slider bars to input your related personal information (also, you can input whatever you like). Whenever a change has been made in the parameters, you will see the corresponding change in the text result section as well as the plots section.")
                        , helpText("2.2 Text Result")
                        , helpText("It is straightforwardly telling your how long can you live and how much chance you will die this year, statistically. It changes with the change in the parameters.")
                        , helpText("2.3 Plots (Tab section)")
                        , helpText("Three tabs are shown: Plot tab, Table tab, and Help (Documentation) Tab (this is me)")
                        , helpText("2.3.1 Plot Tab")
                        , helpText("Two plots are presented: The top plot shows how many years left for you from your current age and till 99 years old (hope you are within the range). The bottom plot shows the morality rate, how much chance you will die this year. Also, it starts from your current age and till 99 years old.")
                        , helpText("2.3.2 Table Tab")
                        , helpText("It provides you with theoretical life table based on your age, gender, and BMI (height and weight). Feel free to navigate and search by yourself.")
                        , helpText("2.3.3 Help (Documentation)")
                        , helpText("Yes, this is me. Nothing much to introduce :)")
                        , helpText("3. Significance")
                        , helpText("This work-in-progress app introduces a good concept which helps people realise how much time left in their life. It also conveys an important message is that, you can increase your life span by changing your life style. More exercise, more walks, less cigarettes and less driving will help you get a better and longer life. ")
                        , helpText("Happy to discuss and hope you can help me improve this tiny funny cute app :)")
                        )
                    )
                )
                
            )
        )
)
        