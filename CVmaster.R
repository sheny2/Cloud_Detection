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
    
    
    
    if (classifier == "SVM")
    {
      SVM_model <- list()
      prediction <- list()
      for (i in 1:K) {
        dat_CV_train = dat %>% filter(fold_index != i)
        dat_CV_test = dat %>% filter(fold_index == i)
        SVM_model[[i]] = svm(dat_CV_train %>% dplyr::select(-train_label),
                             dat_CV_train$train_label)  
        prediction[[i]] = predict(SVM_model[[i]], dat_CV_test %>% dplyr::select(-train_label), 
                                  decision.values = TRUE)
      }
    }
    
    
    if (loss_fun == "Accuracy")
    {
      Accuracy <- matrix(NA, ncol = K + 1, nrow = 1)
      for (j in 1:K)
      {
        dat_CV_test = dat %>% filter(fold_index == j)
        Accuracy[1, j] = mean(prediction[[j]] == dat_CV_test$train_label)
      }
      Accuracy[1, K + 1] = mean(Accuracy[1, 1:K])
    }
    
    
    colnames(Accuracy) = c(1:K, "Average")
    
    prediction
    Accuracy
    
    return(Accuracy)
  }
