## implement the candidate elimination algorithm
## - each hypothesis in the hypothesis class is a conjunction of constraints
##   on attributes
## - domain_filename: filename of the domain file, each line starts with the
##   attribute name followed by possible values for the attribute
## - train_data_filename: filename of the training data
## - eval_data_filename: filename of the evaluation data
## - your algorithm should return the number of consistent hypotheses for
##   each instance in the evaluation data (list of integers with length equal
##   to the number of lines in the evaluation data file

## refer to david poole's online book:
##    http://www.cs.ubc.ca/~poole/aibook/html/ArtInt_193.html
## also covered in Tom Mitchell's machine learning book

## HINT: refer to functions readLines and strsplit for file/string processing
## HINT: refer to is.element for set processing
## HINT: implementing the algorithm in R is not easy. you should start early.


DEBUG <- F
# Prints the object if it is debugging mode
LOG = function(obj)
{
  if(DEBUG)
    print(obj)
}

# Reads a file with filename and Parses it
read = function(filename)
{
  strsplit(readLines(filename, warn=F), ' ')
}

PI <- -1
WILD <- 0

# Returns whether hypothesis x and y are same
'%==%' = function(x,y)
{
  stopifnot(length(x) == length(y))
  all(x == y)
}
# Returns whether hypothesis x is less than or equal to hypothesis y
'%<=%' = function(x,y)
{
  stopifnot(length(x) == length(y))
  all(sapply(1:length(x), function(idx)
  {
    if(y[idx] == WILD)
      T
    else if(y[idx] == x[idx])
      T
    else if(x[idx] == PI)
      T
    else
      F
  }))
}
# Returns whether hypothesis x is less than hypothesis y
'%<%' = function(x,y)
{
  x %<=% y && !(x %==% y)
}
# Returns new x which is more generalzed with y
'%++%' = function(x,y)
{
  stopifnot(length(x) == length(y))
  sapply(1:length(x), function(idx)
  {
    if(x[idx] == PI)
      y[idx]
    else if(x[idx] == y[idx])
      x[idx]
    else
      WILD
  })
}

# If G is empty, Make it not empty
check_G = function(G,domain)
{
  if(length(G)==0)
    G <- list(replicate(length(domain), PI))
  return(G)
}

# Generate G with hypothesis y
generate_G = function(x,y,domain)
{
  # Select the bad G
  x_selection <- sapply(x, function(xx) { y %<=% xx })
  for( xx in x[x_selection])
  # For the bad G
  {
    # Generate acceptable G from the bad G
    for(idx in 1:length(y))
    {
      if(xx[idx] != y[idx])
      {
        if(xx[idx] == WILD)
        {
          for(domain_idx in (1:length(domain[[1]]))[-y[idx]])
          {
            temp <- xx
            temp[idx] <- domain_idx
            if(!any(sapply(x, function(xx) { xx %==% temp })))
              x[[length(x)+1]] <- temp
          }
        }
        else
        {
          temp <- xx
          temp[idx] <- PI
          if(!any(sapply(x, function(xx) { xx %==% temp })))
            x[[length(x)+1]] <- temp
        }
      }
    }
  }
  # Merge the good G and new-generated G
  length(x_selection) <- length(x)
  x_selection[is.na(x_selection)] <- F
  x <- x[!x_selection]
}

# Returns all version spaces
all_vs_recur = function(domain,temp,idx)
{
  if(length(domain)<idx)
    return(list(temp))
  result <- list()
  for(i in c(PI,1:length(domain[[idx]]),WILD))
  {
    temp[idx] <- i
    result <- c(result, all_vs_recur(domain,temp,idx+1))
  }
  return(result)
}

# Returns version spaces between S and G
get_vs = function(S,G,domain)
{
  all_vs <- all_vs_recur(domain, replicate(length(domain), PI), 1)
  result <- all_vs[sapply(all_vs, function(vs) { S %<=% vs && any(sapply(G, function(g) { vs %<=% g })) })]
  return(result)
}

lab1 = function(domain_filename, train_data_filename, eval_data_filename)
{
  # Read files
  domain <- read(domain_filename)
  # Remove domain names
  domain <- lapply(domain, function(d) {d[-1]})
  train <- read(train_data_filename)
  eval <- read(eval_data_filename)

  # Transfer the train data from string value to index number
  for(train_idx in 1:length(train))
  {
    new_data <- double()
    for(data_idx in 1:length(domain))
    {
      for(domain_idx in 1:length(domain[[data_idx]]))
      {
        if(train[[train_idx]][data_idx] == domain[[data_idx]][domain_idx])
        {
          new_data <- c(new_data, domain_idx)
        }
      }
    }
    new_data <- c(new_data, as.double(as.logical(train[[train_idx]][length(domain)+1])))
    train[[train_idx]] <- new_data
  }

  # Transfer the eval data from string value to index number
  for(eval_idx in 1:length(eval))
  {
    new_data <- double()
    for(data_idx in 1:length(domain))
    {
      for(domain_idx in 1:length(domain[[data_idx]]))
      {
        if(eval[[eval_idx]][data_idx] == domain[[data_idx]][domain_idx])
        {
          new_data <- c(new_data, domain_idx)
        }
      }
    }
    eval[[eval_idx]] <- new_data
  }

  #LOG(domain)
  #LOG(train)
  #LOG(eval)

  # Check the data
  stopifnot(length(train) > 0)
  stopifnot(length(eval) > 0)
  stopifnot(length(domain) + 1 == length(train[[1]]))
  stopifnot(length(train[[1]]) == length(eval[[1]]) + 1)

  # Initialize S and G
  S <- replicate(length(domain), PI)
  G <- list(replicate(length(domain), WILD))

  for(d in train)
  # For each train data
  {
    #LOG('S')
    #LOG(S)
    #LOG('G')
    #LOG(G)

    data <- d[-length(d)]
    if(as.logical(d[length(d)]))
    # If the data is positive
    {
      # Remove G which doesn't contain data
      G <- G[sapply(G, function(g) { data %<=% g })]
      G <- check_G(G,domain)

      # Generalize S with data
      S <- S %++% data
    }
    else
    # If the data is negative
    {
      # Generate G with data
      G <- generate_G(G, data, domain)
      G <- check_G(G,domain)
      # Remove G which doesn't accept with S
      G <- G[sapply(G, function(g) { S %<=% g })]
      G <- check_G(G,domain)

      # Remove non-minimal G
      G <- G[sapply(G, function(g1) { !any(sapply(G, function(g2) { g1 %<% g2 })) })]
      G <- check_G(G,domain)
    }
  }

  # Get version spaces
  VS <- get_vs(S,G,domain)
  #LOG(VS)
  # Get number of hypotheses satisfying eval data in version spaces
  result <- lapply(eval, function(e)
  {
    t <- sapply(VS, function(vs) { e %<=% vs })
    if(length(t)<1)
      return(0)
    else
      return(sum(t))
  })

  LOG(S)
  LOG(G)

  # Return the result
  return(unlist(result))
}
