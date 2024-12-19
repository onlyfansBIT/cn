import java.util.*;
import java.math.*;

public class RSA {
    static BigInteger p, q, e, d, n, phi;
    static int bitLength = 256;
    static Scanner S = new Scanner(System.in);
    static Random R = new Random();

    public static void main(String args[]) {
        p = BigInteger.probablePrime(bitLength, R);
        q = BigInteger.probablePrime(bitLength, R);
        n = p.multiply(q);
        phi = p.subtract(BigInteger.ONE).multiply(q.subtract(BigInteger.ONE));

        e = BigInteger.probablePrime(bitLength / 2, R);
        while (phi.gcd(e).compareTo(BigInteger.ONE) != 0 && e.compareTo(phi) < 0) {
            e = e.add(BigInteger.ONE);
        }

        d = e.modInverse(phi);

        System.out.print("Enter The Msg : ");
        String msg = S.nextLine();
        byte[] msgArr = msg.getBytes();

        System.out.println("Message Byte Array: " + display(msgArr));

        byte[] encrypted = encrypt(msgArr);
        System.out.println("Encrypted Byte Array: " + display(encrypted));

        byte[] decrypted = decrypt(encrypted);
        System.out.println("Decrypted Byte Array: " + display(decrypted));
        System.out.println("Received Message: " + new String(decrypted));
    }

    static byte[] encrypt(byte[] message) {
        return (new BigInteger(message).modPow(e, n)).toByteArray();
    }

    static byte[] decrypt(byte[] encryptedMessage) {
        return (new BigInteger(encryptedMessage).modPow(d, n)).toByteArray();
    }

    static String display(byte[] array) {
        StringBuilder s = new StringBuilder();
        for (byte b : array) {
            s.append(Byte.toString(b)).append(" ");
        }
        return s.toString().trim();
    }
} {
    
}
