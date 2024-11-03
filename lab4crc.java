import java.util.Scanner;
public class _04crc{
    public static int n;
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        _04crc crc = new _04crc();
        String copy,recv,code,zero = "0000000000000000";

        System.out.println("Enter the dataword: ");
        code=sc.nextLine();
        n=code.length();
        copy=code;
        code+=zero;
        code=crc.divide(code);
        System.out.println("The length of the Dataword: "+n);
        System.out.println("Data word: "+copy);

        copy = copy.substring(0,n)+code.substring(n);
        System.out.print("CRC = ");
        System.out.println(code.substring(n));

        System.out.println("Transmitted frame is: "+copy);

        System.out.println("Enter the received frame: ");
        recv=sc.nextLine();
        sc.close();

        if(zero.equals(crc.divide(recv).substring(n))){
            System.out.println("Code Bit received");
        }else{
            System.out.println("Received frame contains one or more corrupted bit");
        }

        
    }
    public String divide(String s){
        String div = "10001000000100001";
        int i,j;
        char x;
        for(i=0 ; i<n ;i++){
            x=s.charAt(i);
            for(j=0 ; j<17 ;j++){
                if(x == '1'){
                    if(s.charAt(i+j)!=div.charAt(j)){
                        s=s.substring(0, i+j)+"1"+s.substring(i+j+1);

                    }else{
                        s=s.substring(0, i+j)+"0"+s.substring(i+j+1);
                    }
                }
            }
        }
        return s;
    }
}