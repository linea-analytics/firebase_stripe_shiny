# libraries         --------------------------------------------------------------------

library(httr)
library(firebase) # github
library(shiny)
library(tidyverse)

source('stripe_functions.R')

# set up            --------------------------------------------------------------------

# FIREBASE
# for help on this: https://firebase.john-coene.com/guide/get-started/
Sys.setenv(FIREBASE_API_KEY = "xxx")
Sys.setenv(FIREBASE_PROJECT_ID = "xxx")
Sys.setenv(FIREBASE_AUTH_DOMAIN = "xxx")
Sys.setenv(FIREBASE_APP_ID = "xxx")
Sys.setenv(FIREBASE_STORAGE_BUCKET = "xxx")

tos_url = 'www.your_tos_page.com'
privacy_url = 'www.your_privacy_policy_page.com' 


# STRIPE
# for help on this: https://stripe.com/docs/keys
Sys.setenv(STRIPE_SECRET_KEY = "xxx")

# for help on this: https://stripe.com/docs/payments/checkout
purchase_plan_1_url = 'xxx'
purchase_plan_2_url = 'xxx'

# for help on this: https://stripe.com/docs/no-code/customer-portal
manage_plan_url = 'xxx'

# other options (optional)
info_email = 'xxx@xxx.com'

# ui                ####
ui =fluidPage(
  
  # header
  reqSignin(uiOutput('user_name_ui')),
  reqSignin(actionButton(inputId = "signout",label = "sign out")),
  
  # content
  h1('test-app'),
  tabsetPanel(# tab_0          --------------------------------------------------------------------
              tabPanel(title = 'tab 0', 
                       div(
                         useFirebase(),
                         firebaseUIContainer(),
                         uiOutput('tab_0_ui')
                       )
                       ),
              # tab_1          --------------------------------------------------------------------
              tabPanel(title = 'tab 1', uiOutput("tab_1_ui")),
              # tab_2          --------------------------------------------------------------------
              tabPanel(title = 'tab 2', uiOutput("tab_2_ui"))
              )
)



# server            ------------------------------------------------------------------
server = function(input, output, session) {
  
  # account               ----
  
  # firebase login
  f = FirebaseUI$new("session")$
    set_providers(
      email = TRUE,
      google = TRUE
    )$
    set_tos_url(tos_url)$
    set_privacy_policy_url(privacy_url)$
    launch()
  
  # firebase signout button
  observeEvent(input$signout, {
    f$sign_out()
  })
  
  # firebase account email
  get_user_email = reactive({
    f$req_sign_in()
    user = f$get_signed_in()
    return(user$response$email)
  })
  output$user_name_ui = renderUI({
    h3(paste0('You are logged in as ',get_user_email()))
  })
  
  # stripe
  output$manage_plan_ui = renderUI({
    f$req_sign_in()
    
    user = f$get_signed_in() # get logged in user info
    has_plan = user_has_plan(email = user$response$email, secret_key = secret_key)
    
    if (has_plan) {
      a(
        class = 'manage_plan btn',
        href = paste0(
          manage_plan_url,
          '?prefilled_email=',
          user$response$email
        ),
        'manage plan',
        target = "_blank",
        rel = "noopener noreferrer"
      )
    }
  })
  
  # tab_0                 ----
  
  output$tab_0_ui = renderUI({
    f$req_sign_in()
    
    user = f$get_signed_in() # get logged in user info
    has_plan = user_has_plan(email = user$response$email, secret_key = secret_key)
    
    if (has_plan) {
      tagList(
        h1('You are in!'),
        uiOutput('manage_plan_ui')
      )
      
    } else{
      div(
        h2('Plans'),
        a(
          href = paste0(
            purchase_plan_1_url,
            '?prefilled_email=',
            user$response$email
          ),
          'purchase'
        ),
        br(),
        a(
          href = paste0(
            purchase_plan_2_url,
            '?prefilled_email=',
            user$response$email
          ),
          'purchase'
        ),
        p('For any query please reach out via ',
            a(href = paste0(
              'mailto:', info_email
            ), 'email.'))
      )
    }
    
  })
  
  # tab_1 & 2             ----
  output$tab_1_ui = renderUI({
    h1('This is tab 1.')
    # FREE CONTENT HERE
  })
  output$tab_2_ui = renderUI({
    f$req_sign_in()
    
    user = f$get_signed_in() # get logged in user info
    has_plan = user_has_plan(email = user$response$email, secret_key = secret_key)
    
    if (has_plan) {
      h1('Secret tab 2 content.')
      # PAID CONTENT HERE
    }else{
      h1('You need to purchase a plan to see this content.')
      # FREE CONTENT HERE
    }
  })
}

shinyApp(ui, server)
