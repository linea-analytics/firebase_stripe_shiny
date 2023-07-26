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
user_has_plan = function(email, secret_key) {
  res = get_customer_by_email(email, secret_key)
  content = content(res)$data
  return(content %>% length() > 0)
}