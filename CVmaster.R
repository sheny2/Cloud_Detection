CVmaster <-
  
  function(classifier, train_coord, train_feature, train_label, K, loss_fun) {
    # if classifer not in given choice
    
    fold_index = kmeans(train_coord, centers = K, nstart = 25)
    dat = cbind(train_feature, train_label)
    dat$fold_index = fold_index$cluster
    
    if (classifier == "Logistic")
    {
      glm_result <- list()
      prediction <- list()
      for (i in 1:K) {
        dat_CV_train = dat %>% filter(fold_index != i)
        dat_CV_test = dat %>% filter(fold_index == i)
        glm_result[[i]] = glm(paste("train_label ~ ", paste(names(
          train_feature
        ), collapse = "+"), sep = ""),
        data = dat_CV_train,
        family = 'binomial')
        prob = predict(glm_result[[i]], dat_CV_test, type = "response")
        prediction[[i]] = ifelse(prob > 0.5, 1,-1)
      }
      
    }
    
    
    if (classifier == "LDA")
    {
      LDA_model <- list()
      prediction <- list()
      for (i in 1:K) {
        dat_CV_train = dat %>% filter(fold_index != i)
        dat_CV_test = dat %>% filter(fold_index == i)
        LDA_model[[i]] = lda(as.formula(paste(
          "train_label ~ ", paste(names(train_feature), collapse = "+"), sep = ""
        )), data = dat_CV_train)
        prediction[[i]] = predict(LDA_model[[i]], dat_CV_test)$class
      }
      
    }
    
    
    if (classifier == "QDA")
    {
      QDA_model <- list()
      prediction <- list()
      for (i in 1:K) {
        dat_CV_train = dat %>% filter(fold_index != i)
        dat_CV_test = dat %>% filter(fold_index == i)
        QDA_model[[i]] = qda(as.formula(paste(
          "train_label ~ ", paste(names(train_feature), collapse = "+"), sep = ""
        )), data = dat_CV_train)
        prediction[[i]] = predict(QDA_model[[i]], dat_CV_test)$class
      }
    }
    
    
    if (classifier == "NB")
    {
      NB_model <- list()
      prediction <- list()
      for (i in 1:K) {
        dat_CV_train = dat %>% filter(fold_index != i)
        dat_CV_test = dat %>% filter(fold_index == i)
        NB_model[[i]] = naiveBayes(as.formula(paste(
          "train_label ~ ", paste(names(train_feature), collapse = "+"), sep = ""
        )), data = dat_CV_train)
        prediction[[i]] = predict(NB_model[[i]], dat_CV_test)
      }
    }
    
    
    if (classifier == "KNN")
    {
      KNN_model <- list()
      prediction <- list()
      for (i in 1:K) {
        dat_CV_train = dat %>% filter(fold_index != i)
        dat_CV_test = dat %>% filter(fold_index == i)
        prediction[[i]]=knn(dat_CV_train %>% dplyr::select(-train_label),
                          dat_CV_test %>% dplyr::select(-train_label),
                          cl=dat_CV_train$train_label,k=5,use.all=T)
        }
    }
    
    
    dat$Cloud01 <- factor(ifelse(dat$train_label == "-1", "0", dat$train_label))
    levels(dat$Cloud01) <- c("0", "1")
    
    if (classifier == "Boosting Tree")
    {
      # prediction <- list()
      prediction.list <- list()
      Eta=exp(-(0:7))
      depth = c(2:6)
      Accuracy = matrix(NA,10,K+1)
      for (j in 1:5){
        prediction.list[[j]]=list()
        for (i in 1:K) {
          dat_CV_train = dat %>% filter(fold_index != i)
          dat_CV_test = dat %>% filter(fold_index == i)
          boosting_model <- xgboost(
            data = as.matrix(dat_CV_train[, 1:ncol(train_feature)]),
            label = as.matrix(dat_CV_train$Cloud01),
            max.depth = depth[j],
            eta = 0.01,
            nthread = parallel::detectCores(),
            nrounds = 3,
            objective = "binary:logistic",
            verbose = 0
          )
          pred <- predict(boosting_model, as.matrix(dat_CV_test[,1:ncol(train_feature)]))
          prediction.list[[j]][[i]] <- as.numeric(pred > 0.5)
          Accuracy[j, i] = mean(prediction.list[[j]][[i]] == dat_CV_test$Cloud01)
        }
      }
      Accuracy[,K+1]=apply(Accuracy[,-(K+1)], FUN = mean, 1)
      prediction = prediction.list[[which.max(Accuracy[,K+1])]]
      
    }
    
    if (loss_fun == "Accuracy")
    {
      Accuracy <- matrix(NA, ncol = K + 1, nrow = 1)
      for (j in 1:K)
      {
        dat_CV_test = dat %>% filter(fold_index == j)
        Accuracy[1, j] = mean(prediction[[j]] == dat_CV_test$Cloud01)
      }
      Accuracy[1, K + 1] = mean(Accuracy[1, 1:K])
    }
    
    
    colnames(Accuracy) = c(paste("fold ", 1:K, sep = ""), "CV Average")
    
    return(Accuracy)
  }
