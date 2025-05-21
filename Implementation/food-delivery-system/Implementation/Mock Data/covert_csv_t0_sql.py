import pandas as pd

# Define the function to generate SQL statements
def csv_to_sql(file_paths, output_sql_path):
    sql_statements = []
    
    for file_path, table_name in file_paths:
        df = pd.read_csv(file_path)
        for _, row in df.iterrows():
            # Create the columns and values strings
            columns = ', '.join(df.columns)
            values = ', '.join([
                f"'{str(value).replace('\'', '\'\'')}'" if isinstance(value, str)
                else 'NULL' if pd.isnull(value)
                else str(value)
                for value in row.values
            ])
            # Format the INSERT statement
            sql_statements.append(f"INSERT INTO {table_name} ({columns}) VALUES ({values});")
    
    # Write all statements to the output file
    with open(output_sql_path, 'w') as sql_file:
        sql_file.write('\n'.join(sql_statements))
    print(f"SQL file generated: {output_sql_path}")

# File paths to CSVs and corresponding table names
file_paths = [
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\restaurants_realistic.csv", 'Restaurants'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\restaurant_phones_realistic.csv", 'RestaurantPhones'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\cuisine_types_realistic.csv", 'CuisineTypes'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\menu_items_realistic.csv", 'MenuItems'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\orders_realistic.csv", 'Orders'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\order_details_realistic.csv", 'OrderDetails'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\payments_realistic.csv", 'Payments'),
    (r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\deliveries_realistic.csv", 'Deliveries'),
    #(r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\csv files\feedback_realistic.csv", 'Feedback')
]

# Set the output path for the .sql file
output_sql_path = r"D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\sqlInsertFiles\realistic_data.sql"

# Call the function
csv_to_sql(file_paths, output_sql_path)
