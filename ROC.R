ROC <- function(classifier, train_feature, train_label,test_data, K = 1) {
    # if classifer not in given choice
    
    dat = cbind(train_feature, train_label)
    
    if (classifier == "Logistic")
    {

        glm_result = glm(paste("train_label ~ ", paste(names(
          train_feature
        ), collapse = "+"), sep = ""),
        data = dat,
        family = 'binomial')
        
        preds <- predict(glm_result, type = "response")
        
        t = pROC::coords(roc(train_label, preds), "best", transpose = FALSE)
        
        preds <- predict(glm_result, test_data, type = "response")
      
        roc_result = roc(test_data$Cloud01, preds, print.auc = T, plot = T, print.thres = t[[1]])
    }
    
    
    if (classifier == "LDA")
    {
        LDA_result = lda(as.formula(paste(
          "train_label ~ ", paste(names(train_feature), collapse = "+"), sep = ""
        )), data = dat)
        preds = predict(LDA_result, dat)$class
        roc_result <- roc(train_label, as.numeric(preds))
      }
      
    
    
    if (classifier == "QDA")
    {
      QDA_result = qda(as.formula(paste(
        "train_label ~ ", paste(names(train_feature), collapse = "+"), sep = ""
      )), data = dat)
      preds = predict(QDA_result, dat)$class
      roc_result <- roc(train_label, as.numeric(preds))
    }

    
    
    if (classifier == "NB")
    {
        NB_result = naiveBayes(as.formula(paste(
          "train_label ~ ", paste(names(train_feature), collapse = "+"), sep = ""
        )), data = dat)
        preds = predict(NB_result, dat)
        roc_result <- roc(train_label, as.numeric(preds))
      }
    
    
    
    if (classifier == "KNN")
    {
      KNN_result=knn(dat %>% dplyr::select(-train_label),
                     dat %>% dplyr::select(-train_label),
                          cl=dat$train_label,k=K,use.all=T)
      roc_result <- roc(train_label, as.numeric(KNN_result))
    }
    
  

    return(roc_result)
  }

