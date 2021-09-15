from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

class EnumerationFeaturesClassifier:
    
    def __init__(self):
        pass
    
    # --- Public --- #
    
    def get_growth_columns(self, data, column_names, target_column_name, isPrintProcess=False):
        column_names = list(column_names.copy())
    
        try:
            column_names.remove(target_column_name)
        except:
            pass
    
        growth_columns = list()
        best_score = 0
    
        for _ in column_names:
            iteration_score = 0
            iteration_column = ''
        
            for column in column_names:
                if column in growth_columns: 
                    continue
                
                score = self._get_line_regression_score(
                    data=data, 
                    column_names=growth_columns + [column],
                    target_column_name=target_column_name)
            
                if score <= iteration_score:
                    continue
            
                iteration_score = score
                iteration_column = column
           
            if iteration_score <= best_score or len(iteration_column) == 0:
                break
            
            best_score = iteration_score
            growth_columns.append(iteration_column)
        
            if isPrintProcess:
                print('• score: {:.8f}, columns: {}\n'.format(iteration_score, growth_columns))
        
        return best_score, growth_columns
    
    def get_waning_columns(self, data, column_names, target_column_name, isPrintProcess=False):
        column_names = list(column_names.copy())
    
        try:
            column_names.remove(target_column_name)
        except:
            pass
    
        waning_columns = list(column_names.copy())
        best_score = 0
    
        for _ in column_names:
            iteration_score = 0
            iteration_columns = list()
        
            for column in column_names:
                if column not in waning_columns or len(waning_columns) <= 1: 
                    continue
                    
                current_columns = waning_columns.copy()
                current_columns.remove(column)
                
                score = self._get_line_regression_score(
                    data=data, 
                    column_names=current_columns,
                    target_column_name=target_column_name)
            
                if score <= iteration_score:
                    continue
            
                iteration_score = score
                iteration_columns = current_columns
           
            if iteration_score <= best_score or len(iteration_columns) == 0:
                break
            
            best_score = iteration_score
            waning_columns = iteration_columns
        
            if isPrintProcess:
                print('• score: {:.8f}, columns: {}\n'.format(iteration_score, waning_columns))
        
        return best_score, waning_columns
    
    def get_add_del_columns(self, data, column_names, target_column_name, max_iteration=100, isPrintProcess=False):
        best_score = 0
        isGrowth = True
        best_columns = column_names.copy()
        iteration = 0
        
        while True:
            if iteration >= max_iteration:
                break
                
            if isGrowth:
                if isPrintProcess:
                    print('--- ↑ ---')
                score, columns = self.get_growth_columns(
                    data=data, 
                    column_names=best_columns, 
                    target_column_name=target_column_name,
                    isPrintProcess=isPrintProcess)
                
                if score <= best_score:
                    break
                
                best_score = score
                best_columns = columns
                isGrowth = False
            else:
                if isPrintProcess:
                    print('--- ↓ ---')
                score, columns = self.get_waning_columns(
                    data=data, 
                    column_names=best_columns, 
                    target_column_name=target_column_name,
                    isPrintProcess=isPrintProcess)
                
                if score <= best_score:
                    break
                
                best_score = score
                best_columns = columns
                isGrowth = True
            iteration += 1
                
        return best_score, best_columns
    
    # --- Private --- #
    
    def _get_line_regression_score(self, data, column_names, target_column_name):
        x_train, x_test, y_train, y_test = self._split_data(data, column_names, target_column_name)
    
        linearRegression = LinearRegression()
        linearRegression.fit(x_train, y_train)
        
        return linearRegression.score(x_test, y_test)
    
    def _split_data(self, data, column_names, target_column_name):
        column_names = list(column_names.copy())
    
        try:
            column_names.remove(target_column_name)
        except:
            pass
    
        x_values = data[column_names]
        y_values = data[[target_column_name]]
    
        return train_test_split(
            x_values, 
            y_values, 
            train_size=0.75, 
            random_state=42)