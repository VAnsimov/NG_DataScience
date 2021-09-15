import numpy
from sklearn.linear_model import LinearRegression

class VariablesService:
    
    def get_filled_averages_dataset(self, dataset, target_column, mode='mean'):
        '''
        To fill in the missing values we will use the standard ways

        Filling with value:
        'max', 'min', 'mode', 'median', 'mean'
        '''
        dataset = dataset.copy()
        loc_filter = dataset[dataset[target_column].isna()].index
    
        if mode == 'max':
            dataset.loc[loc_filter, target_column] = dataset[target_column].max()
        
        elif mode == 'min':
            dataset.loc[loc_filter, target_column] = dataset[target_column].min()
        
        elif mode == 'median':
            dataset.loc[loc_filter, target_column] = dataset[target_column].median()  
        
        elif mode == 'mode':
            dataset.loc[loc_filter, target_column] = dataset[target_column].mode()[0] 
        
        return dataset


    def get_filled_values_dataset(self, dataset, target_column, value):
        '''
        To fill in the missing values we will use the standard ways
        '''
        
        dataset = dataset.copy()
        loc_filter = dataset[dataset[target_column].isna()].index
        
        dataset.loc[loc_filter, target_column] = value
        
        return dataset
    
    def get_filled_indicator_dataset(self, dataset, target_column):
        '''
        To fill in the missing values we will use the standard ways
        '''
        dataset = dataset.copy()
        loc_filter = dataset[dataset[target_column].isna()].index
        
        dataset.loc[loc_filter, target_column] = 0
        dataset['ind_'+ str(target_column)] = 0
        dataset.loc[loc_filter, 'ind_' + str(target_column)] = 1
        
        return dataset

    def get_filled_linear_regression_dataset(self, dataset, target_column, columns=list()):
        '''
        To fill in the missing values we will use the standard ways
        '''
        
        dataset = dataset.copy()
        columns = columns.copy()
        loc_filter = dataset[dataset[target_column].isna()].index
        
        if len(columns) == 0:
            columns = list(dataset.select_dtypes([numpy.number]).columns) 
        
        try: columns.remove(target_column)
        except: pass
            
        train_dataset = dataset.dropna()  
        model = LinearRegression()
        model.fit(train_dataset[columns], train_dataset[target_column])
        
        predict_dataset = dataset[dataset[target_column].isna()]
        
        if len(predict_dataset[columns]) == 0:
            return dataset
        
        predict = model.predict(predict_dataset[columns])
        
        dataset.loc[loc_filter, target_column] = predict
        
        return dataset
        
    def get_columns_with_outlier_values(self, data):
        couluns = list()
        max_count = len(data)
    
        for column in data.columns:
            count = len(data[column].dropna())
        
            if count >= max_count:
                continue
            
            couluns.append(column)
        
        return couluns

    def get_columns_with_filled_values(self, data):
        filled_columns = list(data.columns)
        
        for column in self.get_columns_with_outlier_values(data=data):
            try: 
                filled_columns.remove(column)
            except: 
                pass
            
        return filled_columns