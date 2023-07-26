# Saas with Shiny, Firebase, and Stripe
 
![thumbnail](./img/thumbnail.png)

This repo shows how to implement a subscription service (SaaS) with R **Shiny**, **Firebase**, and **Stripe**.

### Pre-requisites:
- Familiarity with [R](https://www.r-project.org/) & [Shiny](https://shiny.posit.co/)
- Some familiarity with [APIs](https://www.w3schools.com/js/js_api_intro.asp) & [HTTP](https://www.w3schools.com/whatis/whatis_http.asp)

### How does this work?
If you have an R Shiny app that you would like to sell as a service to customers, you can do so using Firebase and Stripe.
- [Firebase](https://firebase.google.com/) is a service (owned by Google) that helps manage **user authentication**.
    - Luckily, there is an existing R package that simplifies using Firebase in shiny. The package can be found [here](https://firebase.john-coene.com/).
- [Stripe](https://stripe.com/gb) is a payment process platform that can help manage **subscriptions**.
    - Stripe provides pre-built interfaces for managing payments as well as an API which is relatively easy to use.
- The `stripe_functions.R` file contains simple functions that leverage the Stripe API to compare your Firebase users to the list of those who paid for a subscription (your Stripe customers).


### What does app.R contain?
- [Firebase](https://firebase.google.com/) sign-in & sign-out (user accounts)
- [Stripe](https://stripe.com/gb) sing-up to plan & manage current plan (subscriptions)
- Conditional content 
    - Shown based on whether the user is signed in and has purchased a subscription.

The only edits needed for this to work are the identifying informations for the Firebase and Stripe APIs.

```
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
purchase_plan_1_url = 'https://buy.stripe.com/xxx'
purchase_plan_2_url = 'https://buy.stripe.com/xxx' # (optional)

# for help on this: https://stripe.com/docs/no-code/customer-portal
manage_plan_url = 'https://billing.stripe.com/p/login/xxx'

# other options (optional)
info_email = 'your_info@email.com'

```
### Recommendations
- If you are unfamiliar with Firebase, I would suggest trying to use it, without Stripe, to get use to how it works. Instructions for retrieving the Firebase details can be found [here](https://firebase.john-coene.com/guide/get-started/).

Instructions for retrieving the Stripe secret key and urls can be found [here](https://stripe.com/docs/keys) and [here](https://stripe.com/docs/payments/checkout).