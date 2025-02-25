import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Transaction implements Serializable {
    private String cardNumber;
    private String type;
    private double amount;
    private LocalDateTime timestamp;

    public Transaction(String cardNumber, String type, double amount) {
        this.cardNumber = cardNumber;
        this.type = type;
        this.amount = amount;
        this.timestamp = LocalDateTime.now();
    }

    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yy HH:mm:ss");
        return timestamp.format(formatter) + " | " + cardNumber + " | " + type + " | $" + amount;
    }
}
