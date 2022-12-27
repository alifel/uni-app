import DCloudUTSFoundation;
import Lottie;
import Foundation;
import UIKit;
@objc(UTSSDKModulesTestComponentAnimationViewComponent)
@objcMembers
class AnimationViewComponent : UTSComponent<UIView> {
    private var path: String?;
    private var autoplay: Bool = false;
    private var loop: Bool = false;
    private var hidden: Bool = false;
    private var action: String?;
    private var animationView: LottieAnimationView? = nil;
    public override func created() {}
    public override func measure(_ size: UTSSize) -> UTSSize {
        return UTSSize(100, 100);
    }
    public override func NVBeforeLoad() {}
    public override func NVLoad() -> UIView {
        self.animationView = LottieAnimationView();
        self.animationView.loopMode = LottieLoopMode.playOnce;
        return self.animationView;
    }
    public override func NVLoaded() {
        if (self.loop) {
            self.animationView.loopMode = LottieLoopMode.loop;
        }
        self.animationView.isHidden = self.hidden;
        if (self.autoplay) {
            self.playAnimation();
        }
    }
    public override func NVLayouted() {}
    public override func NVBeforeUnload() {}
    public override func NVUnloaded() {}
    public override func unmounted() {}
    public func setRepeatMode(_ repeatMode: String) {
        if (repeatMode == "RESTART") {
            if (self.loop) {
                self.animationView.loopMode = LottieLoopMode.loop;
            }
             else {
                self.animationView.loopMode = LottieLoopMode.playOnce;
            }
        }
         else {
            if (repeatMode == "REVERSE") {
                if (self.loop) {
                    self.animationView.loopMode = LottieLoopMode.autoReverse;
                }
                 else {
                    self.animationView.loopMode = LottieLoopMode.repeatBackwards(1);
                }
            }
        }
    }
    public func playAnimation() {
        if (self.path == nil) {
            return;
        }
        var animationUrl: URL?;
        if (self.path!.hasPrefix("http")) {
            animationUrl = URL(string: self.path!);
        }
         else {
            var filePath = UTSiOS.getResourcePath(self.path!);
            animationUrl = URL(filePath: filePath);
        }
        if (animationUrl != nil) {
            LottieAnimation.loadedFrom(url: animationUrl!, closure: {
            (animation: LottieAnimation) in
            if (animation != nil) {
                self.animationView.animation = animation;
                self.animationView.play(completion: {
                (isFinish: Bool) in
                if (isFinish) {
                    self.fireEvent("bindended");
                }
                });
            }
            });
        }
    }
    public static func wx_export_method_0() -> String {
        return "setRepeatMode:";
    }
    public static func wx_export_method_1() -> String {
        return "playAnimation";
    }
    public override func __$$init() {
        self.__$$watch("path", {
        (newValue: String, oldValue: String) in
        self.path = newValue;
        if (self.autoplay) {
            self.playAnimation();
        }
        });
        self.__$$watch("loop", {
        (newValue: Bool, oldValue: Bool) in
        self.loop = newValue;
        if (self.loop) {
            self.animationView.loopMode = LottieLoopMode.loop;
        }
        });
        self.__$$watch("autoplay", {
        (newValue: Bool, oldValue: Bool) in
        self.autoplay = newValue;
        });
        self.__$$watch("action", {
        (newValue: String, oldValue: String) in
        var action = newValue;
        if (action == "play" || action == "pause" || action == "stop") {
            self.action = action;
            switch(action){
                case "play":
                    self.playAnimation();
                    break;
                case "pause":
                    self.animationView.pause();
                    break;
                case "stop":
                    self.animationView.stop();
                    break;
                default:
                    break;
            }
        }
        });
        self.__$$watch("hidden", {
        (newValue: Bool, oldValue: Bool) in
        self.hidden = newValue;
        self.animationView.isHidden = self.hidden;
        });
    }
}