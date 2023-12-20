get_all_plans = function(secret_key) {
  res = GET(url = 'https://api.stripe.com/v1/plans',
            authenticate(user = secret_key,
                         password = ''))
  
  return(res)
}
plans_table = function(secret_key) {
  plans = get_all_plans(secret_key)
  plans_data = content(plans)$data
  
  if (is.null(plans_data)) {
    message('Plans data not found. Stripe API response message:',
            content(plans)$error$message)
  } else{
    table = lapply(plans_data, function(plan) {
      row = c(
        amount = plan$amount,
        currency = plan$currency,
        period = paste(plan$interval_count, plan$interval)
      )
      
      return(row)
      
    }) %>%
      Reduce(f = rbind) %>%
      data.frame(row.names = NULL)
    
    return(table)
    
  }
}
get_customer_by_email = function(email, secret_key) {
  res = GET(
    url = 'https://api.stripe.com/v1/customers',
    query = list(email = email),
    authenticate(user = secret_key,
                 password = '')
  )
  
  return(res)
}
get_customer_sub_by_id = function(secret_key, customer_id) { #get subscription information by customer id
  res_sub = GET(
    url = 'https://api.stripe.com/v1/subscriptions',
    query = list(customer = customer_id),
    authenticate(user = secret_key,
                 password = '')
  )
  return(res_sub)
}
user_has_plan_prod = function(email, secret_key) {
  
  res_cust = get_customer_by_email(email, secret_key)
  customer_id <- NA
  tryCatch({
    customer_id <- content(res_cust)$data[[1]]$id
  }, error = function(e) {
    # customer_id remains NA
  })
  if (is.na(customer_id)) {
    return(FALSE)
  } else {
    res_sub = get_customer_sub_by_id(customer_id, secret_key)
    #get status of subscription
    content_sub_st <- content(res_sub)$data[[1]]$status 
    #get product of subscription - used to hide certain parts in your app (this can also be price id if there is 1 product: content(res_sub)$data[[1]]$price$id, see https://stripe.com/docs/api/subscriptions/object)
    content_sub_prod <-content(res_sub)$data[[1]]$plan$product 
    #filter on status plus return product to use in your app
    if (content_sub_st == "active" || content_sub_st == "trialing") {
      return(list(has_plan = TRUE, content_sub_prod = content_sub_prod))
    } else {
      return(FALSE)
    }
  }
}