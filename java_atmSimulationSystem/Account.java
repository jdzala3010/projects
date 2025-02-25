import java.io.Serializable;

public class Account implements Serializable {
    private String cardNumber;
    private String encryptedPin;
    private double balance;

    public Account(String cardNumber, String pin, double balance) {
        this.cardNumber = cardNumber;
        this.encryptedPin = EncryptionUtil.encrypt(pin);
        this.balance = balance;
    }

    public String getCardNumber() { return cardNumber; }

    public boolean authenticate(String pin) {
        return EncryptionUtil.decrypt(encryptedPin).equals(pin);
    }

    public double getBalance() { return balance; }

    public void deposit(double amount) { balance += amount; }

    public boolean withdraw(double amount) {
        if (amount > balance) return false;
        balance -= amount;
        return true;
    }

    public String toString() {
        return "Card: " + cardNumber + ", Balance: $" + balance;
    }
}
