# 🏦 ATM Simulation System  

## 🚀 A Console-Based ATM System Built Using Core Java  

### 📌 Features:
- 🔐 **User Authentication** (Card Number & PIN)
- 🛡 **Admin Authentication** (Username & Encrypted Password)
- 💰 **Balance Inquiry**
- 💵 **Deposit & Withdrawal**
- 📜 **Transaction History**
- 🗄 **Persistent Data Storage** (Using Java **Serialization**)
- 🔏 **Secure PIN & Password Encryption**
- 📊 **Admin Panel** (View All Accounts & Transactions)

---

## 🛠 Technologies Used:
- **Java Core Concepts** (OOP, Exception Handling, Collections)
- **File Handling** (Stores Accounts & Transactions in `.dat` files)
- **Serialization** (Saves and loads objects persistently)
- **Basic Encryption** (For secure password storage)

---

## 📂 Project Structure:
java_atmSimulationSystem/ 

                ├── ATMSystem.java # Entry point of the application
                ├── ATM.java # Main ATM logic 
                ├── Account.java # User account model 
                ├── Transaction.java # Transaction model
                ├── EncryptionUtil.java  # Basic encryption for passwords  
                │── accounts.dat # Stores user accounts (Serialized) 
                │── transactions.dat # Stores transaction history (Serialized) 
                │── README.md # Project Documentation


