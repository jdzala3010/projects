import java.util.Scanner;

public class ATMSystem {
    public static void main(String[] args) {
        ATM atm = new ATM();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\n--Welcome to the ATM System--");
            System.out.println("1. User Login");
            System.out.println("2. Admin Login");
            System.out.println("3. Exit");
            System.out.print("Select an option: ");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    atm.startATM();
                    break;
                case 2:
                    atm.adminLogin();
                    break;
                case 3:
                    System.out.println("Exiting ATM System. Goodbye!");
                    return;
                default:
                    System.out.println("Invalid Choice! Try Again.");
            }
        }
    }
}
