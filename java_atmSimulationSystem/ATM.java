import java.io.*;
import java.util.*;

public class ATM {
    private static final String ACCOUNTS_FILE = "accounts.dat";
    private static final String TRANSACTIONS_FILE = "transactions.dat";
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = EncryptionUtil.encrypt("admin123");

    private Map<String, Account> accounts = new HashMap<>();
    private List<Transaction> transactions = new ArrayList<>();

    public ATM() {
        loadAccounts();
        loadTransactions();
    }


    private void saveAccounts() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(ACCOUNTS_FILE))) {
            oos.writeObject(accounts);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private void loadAccounts() {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(ACCOUNTS_FILE))) {
            accounts = (Map<String, Account>) ois.readObject();
        } catch (Exception e) {
            System.out.println("No existing accounts found.");
        }
    }


    private void saveTransactions() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(TRANSACTIONS_FILE))) {
            oos.writeObject(transactions);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    private void loadTransactions() {
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(TRANSACTIONS_FILE))) {
            transactions = (List<Transaction>) ois.readObject();
        } catch (Exception e) {
            System.out.println("No transactions found.");
        }
    }


    public void registerAccount(String cardNumber, String pin, double balance) {
        accounts.put(cardNumber, new Account(cardNumber, pin, balance));
        saveAccounts();
        System.out.println("Account created successfully!");
    }


    public void startATM() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("\n1. Register  2. Login  4. Exit");
        System.out.print("Choose: ");
        int choice = scanner.nextInt();
        switch (choice) {
            case 1:
                System.out.print("Enter New Card Number: ");
                String cardNumber = scanner.next();
                System.out.print("Enter PIN: ");
                String pin = scanner.next();
                System.out.print("Enter Initial Balance: ");
                double balance = scanner.nextDouble();
                registerAccount(cardNumber, pin, balance);
                break;
            case 2:
                System.out.print("Enter Card Number: ");
                String cardNumber1 = scanner.next();
                System.out.print("Enter PIN: ");
                String pin1 = scanner.next();

                Account account = accounts.get(cardNumber1);
                if (account != null && account.authenticate(pin1)) {
                    System.out.println("Login Successful!");
                    userMenu(account);
                } else {
                    System.out.println("Invalid Credentials!");
                }
        }
    }


    public void userMenu(Account account) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("\n1. Check Balance  2. Deposit  3. Withdraw  4. Transactions  5. Exit");
            System.out.print("Choose: ");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    System.out.println("Balance: $" + account.getBalance());
                    break;
                case 2:
                    System.out.print("Enter deposit amount: ");
                    double deposit = scanner.nextDouble();
                    account.deposit(deposit);
                    transactions.add(new Transaction(account.getCardNumber(), "Deposit", deposit));
                    saveAccounts();
                    saveTransactions();
                    System.out.println("Deposit Successful!");
                    break;
                case 3:
                    System.out.print("Enter withdrawal amount: ");
                    double withdraw = scanner.nextDouble();
                    if (account.withdraw(withdraw)) {
                        transactions.add(new Transaction(account.getCardNumber(), "Withdraw", withdraw));
                        saveAccounts();
                        saveTransactions();
                        System.out.println("Withdrawal Successful!");
                    } else {
                        System.out.println("Insufficient Balance!");
                    }
                    break;
                case 4:
                    System.out.println("\nTransaction History:");
                    transactions.stream()
                            .filter(t -> t.toString().contains(account.getCardNumber()))
                            .forEach(System.out::println);
                    break;
                case 5:
                    System.out.println("Logging Out...");
                    return;
                default:
                    System.out.println("Invalid Choice!");
            }
        }
    }


    public void adminLogin() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter Admin Username: ");
        String username = scanner.next();
        System.out.print("Enter Admin Password: ");
        String password = scanner.next();

        if (username.equals(ADMIN_USERNAME) && EncryptionUtil.decrypt(ADMIN_PASSWORD).equals(password)) {
            System.out.println("Admin Login Successful!");
            adminPanel();
        } else {
            System.out.println("Access Denied! Incorrect Credentials.");
        }
    }


    public void adminPanel() {
        System.out.println("\n--Admin Panel--");
        System.out.println("\n All Accounts:");
        accounts.values().forEach(System.out::println);

        System.out.println("\n All Transactions:");
        transactions.forEach(System.out::println);
    }
}
