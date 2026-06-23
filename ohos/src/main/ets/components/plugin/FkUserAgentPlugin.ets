import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';
import { hilog } from '@kit.PerformanceAnalysisKit';
import common from '@ohos.app.ability.common';
import deviceInfo from '@ohos.deviceInfo';

const DOMAIN = 0x0001;
const TAG = 'FkUserAgentPlugin';

/** FkUserAgentPlugin **/
export default class FkUserAgentPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private webEngineInitialized: boolean = false;

  constructor() {
  }

  getUniqueClassName(): string {
    return "FkUserAgentPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "fk_user_agent");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getProperties") {
      this.getProperties(result)
    } else {
      result.notImplemented()
    }
  }

  /**
   * 初始化 ArkWeb 引擎，以便通过静态方法 getDefaultUserAgent() 获取真实 User-Agent。
   * 全局只需调用一次。
   */
  private initWebEngine() {
    if (this.webEngineInitialized) {
      return;
    }
    try {
      webview.WebviewController.initializeWebEngine();
      this.webEngineInitialized = true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `initializeWebEngine failed: ${(error as BusinessError).message}`);
    }
  }

  /**
   * 通过 ArkWeb 静态方法获取系统默认 Web User-Agent。
   * getDefaultUserAgent() 从 API version 14 开始支持，无需绑定 Web 组件。
   * 如果调用失败则返回空字符串。
   */
  private getWebViewUserAgent(): string {
    this.initWebEngine();
    try {
      return webview.WebviewController.getDefaultUserAgent();
    } catch (error) {
      hilog.error(DOMAIN, TAG, `getDefaultUserAgent failed: ${(error as BusinessError).message}`);
      return '';
    }
  }

  getProperties(result: MethodResult) {
    // deviceInfo 提供的设备信息（无需权限）
    const deviceType = deviceInfo.deviceType; //设备类型，如 phone/tablet/2in1
    const systemName = deviceInfo.distributionOSName; //发行版系统名称，如 OpenHarmony
    const systemVersion = deviceInfo.distributionOSVersion; //发行版系统版本号，如 5.0.0
    const deviceBrand = deviceInfo.brand; //设备品牌
    const systemModel = deviceInfo.productModel; //认证型号
    const osFullName = deviceInfo.osFullName; //系统完整名称，如 OpenHarmony-6.0.2.130

    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then((bundleInfo) => {
        const packageName = bundleInfo.name;
        const shortPackageName = packageName.substring(packageName.lastIndexOf(".") + 1);
        const applicationVersion = bundleInfo.versionName; //应用版本名
        const buildNumber = bundleInfo.versionCode.toString(); //应用版本号
        let applicationName = "";

        try {
          const context = getContext(this) as common.UIAbilityContext
          applicationName = context.resourceManager.getStringSync(bundleInfo.appInfo.labelId); //应用名称
        } catch (error) {
          hilog.error(DOMAIN, TAG, 'getStringSync failed');
        }

        // 系统名称/系统版本 (设备类型; 设备品牌 认证型号; 系统完整名称)
        const userAgent = `${systemName}/${systemVersion} (${deviceType}; ${deviceBrand} ${systemModel}; ${osFullName})`;
        const packageUserAgent = `${shortPackageName}/${applicationVersion}.${buildNumber} ${userAgent}`;

        // 通过 ArkWeb API 获取真实的 WebView User-Agent
        const webViewUserAgent = this.getWebViewUserAgent();

        const properties: Record<string, ESObject> = {
          "systemName": "OpenHarmony",
          "systemVersion": systemVersion,
          "packageName": packageName,
          "shortPackageName": shortPackageName,
          "applicationName": applicationName,
          "applicationVersion": applicationVersion,
          "applicationBuildNumber": buildNumber,
          "packageUserAgent": packageUserAgent,
          "userAgent": userAgent,
          "webViewUserAgent": webViewUserAgent,
        };
        result.success(properties)
      })
      .catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG, `get bundleInfo failed, error is ${error}`);
        result.error("BUNDLE_INFO_ERROR", "Failed to get bundle info", error.message);
      })
  }
}
