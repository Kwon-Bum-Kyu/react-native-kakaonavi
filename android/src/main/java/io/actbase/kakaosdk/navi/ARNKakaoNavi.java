package io.actbase.kakaosdk.navi;

import androidx.annotation.NonNull;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.kakao.sdk.common.KakaoSdk;
import com.kakao.sdk.navi.NaviClient;
import com.kakao.sdk.navi.model.CoordType;
import com.kakao.sdk.navi.model.Location;
import com.kakao.sdk.navi.model.NaviOption;
import com.kakao.sdk.navi.model.RpOption;
import com.kakao.sdk.navi.model.VehicleType;
import java.util.ArrayList;
import java.util.List;

public class ARNKakaoNavi extends ReactContextBaseJavaModule {

    private ReactApplicationContext context;

    public ARNKakaoNavi(ReactApplicationContext context) {
        super(context);
        this.context = context;
//        KakaoSdk.init(this.context, "appKey");
    }

    @NonNull
    @Override
    public String getName() {
        return "ARNKakaoNavi";
    }

    public VehicleType getVehicleType(final int vehicleType) {
        switch (vehicleType) {
            case 2:
                return VehicleType.SECOND;
            case 3:
                return VehicleType.THIRD;
            case 4:
                return VehicleType.FOURTH;
            case 5:
                return VehicleType.FIFTH;
            case 6:
                return VehicleType.SIXTH;
            case 7:
                return VehicleType.TWO_WHEEL;
            default:
                return VehicleType.FIRST;
        }
    }

    public RpOption getRpOption(final int rpOption) {
        switch (rpOption) {
            case 2:
                return RpOption.FREE;
            case 3:
                return RpOption.SHORTEST;
            case 4:
                return RpOption.NO_AUTO;
            case 5:
                return RpOption.WIDE;
            case 6:
                return RpOption.HIGHWAY;
            case 8:
                return RpOption.NORMAL;
            case 100:
                return RpOption.RECOMMENDED;
            default:
                return RpOption.FAST;
        }
    }

    @ReactMethod
    public void isInstalled(final Promise promise) {
        if (NaviClient.getInstance().isKakaoNaviInstalled(context)) {
            promise.resolve(true);
        } else {
            promise.resolve(false);
        }
    }

    @ReactMethod
    public void share(final ReadableMap location, final ReadableMap options,
                      final ReadableArray viaList, final Promise promise) {

        Location destination = new Location(
                location.getString("name"),
                location.getString("x"),
                location.getString("y")
        );

        NaviOption _options = new NaviOption(
                options.hasKey("coordType") ? CoordType.valueOf(options.getString("coordType")) : null,
                options.hasKey("vehicleType") ? getVehicleType(options.getInt("vehicleType")) : null,
                options.hasKey("rpOption") ? getRpOption(options.getInt("rpOption")) : null,
                options.hasKey("routeInfo") ? options.getBoolean("routeInfo") : null,
                options.hasKey("startX") ? options.getString("startX") : null,
                options.hasKey("startY") ? options.getString("startY") : null,
                options.hasKey("startAngle") ? options.getInt("startAngle") : null,
                options.hasKey("returnUri") ? options.getString("returnUri") : null
        );

        List<Location> _viaList = new ArrayList<>();
        for (int i = 0; i < viaList.size(); i++) {
            ReadableMap map = viaList.getMap(i);
            _viaList.add(new Location(
                    map.getString("name"),
                    location.getString("x"),
                    location.getString("y")
            ));
        }

        WritableMap map = Arguments.createMap();
        if (NaviClient.getInstance().isKakaoNaviInstalled(context)) {
            context
                    .startActivity(NaviClient.getInstance().shareDestinationIntent(destination, _options, _viaList));
            map.putBoolean("success", true);
            promise.resolve(map);
        } else {
            promise.resolve(map);
        }

    }

    @ReactMethod
    public void navigate(final ReadableMap location, final ReadableMap options,
                         final ReadableArray viaList, final Promise promise) {

        Location destination = new Location(
                location.getString("name"),
                location.getString("x"),
                location.getString("y")
        );

        NaviOption _options = new NaviOption(
                options.hasKey("coordType") ? CoordType.valueOf(options.getString("coordType")) : null,
                options.hasKey("vehicleType") ? getVehicleType(options.getInt("vehicleType")) : null,
                options.hasKey("rpOption") ? getRpOption(options.getInt("rpOption")) : null,
                options.hasKey("routeInfo") ? options.getBoolean("routeInfo") : null,
                options.hasKey("startX") ? options.getString("startX") : null,
                options.hasKey("startY") ? options.getString("startY") : null,
                options.hasKey("startAngle") ? options.getInt("startAngle") : null,
                options.hasKey("returnUri") ? options.getString("returnUri") : null
        );

        List<Location> _viaList = new ArrayList<>();
        for (int i = 0; i < viaList.size(); i++) {
            ReadableMap map = viaList.getMap(i);
            _viaList.add(new Location(
                    map.getString("name"),
                    map.getString("x"),
                    map.getString("y")
            ));
        }

        WritableMap map = Arguments.createMap();
        map.putString("web_navigate_url", NaviClient.getInstance().navigateWebUrl(destination, _options, _viaList).toString());

        if (NaviClient.getInstance().isKakaoNaviInstalled(context)) {
            context
                    .startActivity(NaviClient.getInstance().navigateIntent(destination, _options, _viaList));
            map.putBoolean("success", true);
            promise.resolve(map);
        } else {
            promise.resolve(map);
        }
    }
}
