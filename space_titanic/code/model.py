import xgboost as xgb
import numpy as np
from sklearn.metrics import accuracy_score, roc_auc_score


from sklearn.model_selection import StratifiedKFold

# Initialize Optuna study



# Define the optimization function directly
def objective(trial, X_train, y_train):
    print(trial)
    params = {
        'objective': 'binary:logistic',
        'eval_metric': ['error', 'auc'],
        'tree_method': 'gpu_hist',
        #'enable_categorical': True,
        'device': 'cuda',
        'verbosity':0,
        
        # Parameters to optimize
        'max_depth': trial.suggest_int('max_depth', 3, 12),
        'eta': trial.suggest_float('eta', 0.01, 0.3, log=True),
        'subsample': trial.suggest_float('subsample', 0.3, 1.0),
        'colsample_bytree': trial.suggest_float('colsample_bytree', 0.3, 1.0),
        'min_child_weight': trial.suggest_int('min_child_weight', 1, 7),
        'lambda': trial.suggest_float('lambda', 1e-8, 1.0, log=True),
        'seed': 42
    }
    
    # Cross validation
    cv_scores = []
    kf = StratifiedKFold(n_splits=5, 
                         shuffle=True, 
                         random_state=42)
    
    for train_idx, val_idx in kf.split(X_train, y_train):
        X_fold_train, X_fold_val = X_train[train_idx], X_train[val_idx]
        y_fold_train, y_fold_val = y_train[train_idx], y_train[val_idx]
    
    # Create DMatrix for XGBoost
        dtrain = xgb.DMatrix(X_fold_train, label=y_fold_train)
        dval = xgb.DMatrix(X_fold_val, label=y_fold_val)
        
        # Train model
        model = xgb.train(
            params,
            dtrain,
            num_boost_round=5000,
            early_stopping_rounds=20,
            evals=[(dval, 'val')],
            verbose_eval=False
        )
        
        # Get validation score
        val_pred = model.predict(dval)
        score = roc_auc_score(y_fold_val, val_pred)
        cv_scores.append(score)
    
    return np.mean(cv_scores)

# Run optimization


