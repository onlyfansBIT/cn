import java.util.LinkedList; 
import java.util.Queue; 
import java.util.Random; 
import java.util.Scanner; 
class SlidingWindowProtocol { 
private int windowSize; 
private int numFrames; 
    private Queue<Integer> window; 
 
    // Constructor to initialize the protocol 
    public SlidingWindowProtocol(int windowSize, int numFrames) { 
        this.windowSize = windowSize; 
        this.numFrames = numFrames; 
        this.window = new LinkedList<>(); 
    } 
 
    // Method to simulate the sending of frames using Go-Back-N 
    public void sendFrames() { 
        int currentFrame = 1; // Start with frame 1 
        Random random = new Random(); 
        while (currentFrame <= numFrames) { 
            // Send frames within the window size 
            while (window.size() < windowSize && currentFrame <= numFrames) { 
                System.out.println("Sending Frame " + currentFrame); 
                window.add(currentFrame); 
                currentFrame++; 
            } 
 
            // Simulate receiving an acknowledgment 
            if (!window.isEmpty()) { 
                int ackFrame = window.peek(); // Assume ACK for the first frame in the window 
                boolean isLost = random.nextBoolean(); // Simulate ACK loss randomly 
 
                if (isLost) { 
                    System.out.println("ACK for Frame " + ackFrame + " lost. Retransmitting window..."); 
                    retransmitWindow(); 
                } else { 
                    System.out.println("ACK received for Frame " + ackFrame); 
                    window.poll(); // Remove the acknowledged frame from the window 
                } 
            } 
        } 
 
        System.out.println("All frames sent successfully."); 
    } 
 
    // Method to retransmit all frames in the current window 
    private void retransmitWindow() { 
        for (int frame : window) { 
            System.out.println("Retransmitting Frame " + frame); 
        } 
    } 
 
    public static void main(String[] args) { 
        Scanner scanner = new Scanner(System.in); 
 
System.out.print("Enter the number of frames to be sent: "); 
int numFrames = scanner.nextInt(); 
System.out.print("Enter the window size: "); 
int windowSize = scanner.nextInt(); 
SlidingWindowProtocol protocol = new SlidingWindowProtocol(windowSize, numFrames); 
protocol.sendFrames(); 
} 
}