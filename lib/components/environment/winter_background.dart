import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class WinterBackground extends ParallaxComponent {
  WinterBackground();

  @override
  Future<void> onLoad() async {
    final image = game.images.fromCache('winter_background.png');

    parallax = Parallax(
      [
        ParallaxLayer(
          ParallaxImage(image),
        ),
      ],
      baseVelocity: Vector2(100, 0),
    );
    await super.onLoad();
  }
}
