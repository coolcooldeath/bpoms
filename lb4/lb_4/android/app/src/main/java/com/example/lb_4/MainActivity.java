package com.example.lb_4;

import androidx.annotation.NonNull;

import com.example.lwocryptocore.lcryptcore.CryptoCase;
import com.example.lwocryptocore.lcryptcore.LCryptCore;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.flutter.dev/android_hash";

    static
    {
        System.loadLibrary("cryptowrap");
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getHash")) {

                                String hash = getHash(call.argument("hash"));
                                if (!hash.equals("")) { result.success(hash); }
                                else {
                                    result.error("ERROR!",
                                            "Somethings wrong with hash!", null);
                                }
                            } else { result.notImplemented(); }
                        }
                );
    }

    private String getHash(String msgToHash) {

        String selectedAlgoritm = "sha256";
        byte[] arrBytesForDigest = new byte[(int) msgToHash.length()];
        arrBytesForDigest = msgToHash.getBytes();

        CryptoCase cryptoCaseDigest = (
                new LCryptCore()).
                CreateDigest(
                        selectedAlgoritm,
                        msgToHash.getBytes(),
                        arrBytesForDigest.length
                );

        return bytesToHex(cryptoCaseDigest.digest);
    }

    private final static char[] hexArray = "0123456789ABCDEF".toCharArray();

    public static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars).toLowerCase();
    }
}
