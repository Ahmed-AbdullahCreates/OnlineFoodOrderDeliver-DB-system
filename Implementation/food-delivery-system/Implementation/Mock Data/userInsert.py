import csv
import random
import hashlib
from faker import Faker
from datetime import datetime, timedelta

faker = Faker()
Faker.seed(0)# make sure that the same data is generated each time the script is run

def generate_users_data(num_rows):
    data = []
    for _ in range(num_rows):
        name = faker.name()
        username = faker.user_name()
        password_hash = hashlib.sha256(faker.password().encode()).hexdigest()
        city = faker.city()
        street = faker.street_name()
        apartment = faker.random_int(1, 50) if random.choice([True, False]) else None
        email = faker.email()
        created_at = faker.date_time_this_decade()
        updated_at = created_at + timedelta(days=random.randint(0, 30))
        is_deleted = random.choice([0, 1])
        last_login_time = faker.date_time_between(created_at, datetime.now())
        account_status = random.choice(['Active', 'Suspended', 'Blocked'])

        data.append([
            name, username, password_hash, city, street, apartment, email,
            created_at, updated_at, is_deleted, last_login_time, account_status
        ])
    return data
# Generate UserPhones data
def generate_userphones(num_rows, max_phones_per_user):
    data = []
    user_ids = list(range(1, num_rows + 1))  # Assuming UserIDs are sequential from 1 to num_rows

    for user_id in user_ids:
        num_phones = random.randint(1, max_phones_per_user)
        phone_numbers = set()
        while len(phone_numbers) < num_phones:
            phone_number = f"+{faker.random_int(1, 99)}{faker.msisdn()[:10]}"
            phone_numbers.add(phone_number)
        for phone in phone_numbers:
            data.append([phone, user_id])
    return data

# Generate data
num_users = 500 
max_phones_per_user = 3  
rows = generate_userphones(num_users, max_phones_per_user)

# Write to CSV
with open(r'D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\UsersPhones.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(["PhoneNumber", "UserID"])
    writer.writerows(rows)

# Generate Users data
rows = generate_users_data(50)

#Write to CSV for users 
with open(r'D:\Work\college\Semester V projects\Data base Project\Implementation\food-delivery-system\schema\Mock Data\Users2.csv', mode='w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow([
        "Name", "UserName", "PasswordHash", "City", "Street", "Apartment", "Email",
        "CreatedAt", "UpdatedAt", "IsDeleted", "LastLoginTime", "AccountStatus"
    ])
    writer.writerows(rows)
