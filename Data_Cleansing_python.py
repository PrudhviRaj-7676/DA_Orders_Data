#read data from the file and handle null values
import pandas as pd
df = pd.read_csv('./orders.csv')
df = pd.read_csv('./orders.csv',na_values=['Not Available','unknown'])
df['Ship Mode'].unique()


#rename columns names to make data more acesses friendly ..make them lower case and replace space with underscore

df.columns=df.columns.str.lower()
df.columns=df.columns.str.replace(' ','_')
df.columns
df.head(5)


#derive and caliculate new columns for discount , sale price and profit, which would further help us in easy analysis of the data

df['discount']=df['discount_percent']*df['list_price']*0.01

df['sale_price']=df['list_price']-df['discount']
#df.head(5)

df['profit']=df['sale_price']-df['cost_price']
df.head(5)


#convert order date from object data type to datetime

df['order_date']=pd.to_datetime(df['order_date'],format="%Y-%m-%d")
df.dtypes

#drop cost price list price and discount percent columns

df.drop(columns=['list_price','cost_price','discount_percent'],inplace=True)



#Save the data into a new csv file which we can further load into Mysql workbench to create a DB for analysis.

df.to_csv('new_orders.csv')
