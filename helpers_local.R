## my helpers for saving locally ---------

saveDataMain <- function(data) {
  data <- as.data.frame(t(data))
  if (exists("responses_main")) {
    responses_main <<- rbind(responses_main, data)
  } else {
    responses_main <<- data
  }
}

saveDataType <- function(data, type) {
  responses_type = paste("responses_", type, sep = "")
  data <- as.data.frame(t(data))
  if (exists(responses_type)) {
    eval(call("<<-", as.name(responses_type), eval(call("rbind", as.name(responses_type), data))))
  } else {
    eval(call("<<-", as.name(responses_type), data))
  }
}

loadDataMain <- function() {
  if (exists("responses_main")) {
    responses_main
  }
}

loadDataType <- function(type) {
  responses_type = paste("responses_", type, sep = "")
  if (exists(responses_type)) {
    as.name(responses_type)
  }
}