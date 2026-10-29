"""Genera iconos de launcher (default, dark, light) para Android, iOS y Flutter."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]

THEMES = {
    "default": {
        "background": (14, 116, 144, 255),
        "mark": (255, 255, 255, 255),
        "accent": (165, 243, 252, 255),
    },
    "dark": {
        "background": (15, 23, 42, 255),
        "mark": (196, 181, 253, 255),
        "accent": (99, 102, 241, 255),
    },
    "light": {
        "background": (241, 245, 249, 255),
        "mark": (15, 23, 42, 255),
        "accent": (14, 165, 233, 255),
    },
}

ANDROID_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

IOS_APP_ICON_SPECS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]


def _draw_mark(draw: ImageDraw.ImageDraw, size: int, mark: tuple[int, int, int, int], accent: tuple[int, int, int, int]) -> None:
    inset = size * 0.22
    bar_w = size * 0.14
    gap = size * 0.08

    left = inset
    top = inset
    right = size - inset
    bottom = size - inset

    draw.rounded_rectangle(
        (left, top, left + bar_w, bottom),
        radius=bar_w / 2,
        fill=mark,
    )
    draw.rounded_rectangle(
        (left, top, right - gap, top + bar_w),
        radius=bar_w / 2,
        fill=mark,
    )
    draw.rounded_rectangle(
        (left, (top + bottom - bar_w) / 2, right - gap * 1.4, (top + bottom + bar_w) / 2),
        radius=bar_w / 2,
        fill=accent,
    )


def make_icon(theme: str, size: int) -> Image.Image:
    colors = THEMES[theme]
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    radius = size * 0.22
    draw.rounded_rectangle((0, 0, size - 1, size - 1), radius=radius, fill=colors["background"])
    _draw_mark(draw, size, colors["mark"], colors["accent"])
    return image


def save(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, format="PNG")


def main() -> None:
    masters = {name: make_icon(name, 1024) for name in THEMES}

    for density, size in ANDROID_SIZES.items():
        folder = ROOT / "android" / "app" / "src" / "main" / "res" / density
        save(masters["default"].resize((size, size), Image.Resampling.LANCZOS), folder / "ic_launcher.png")
        save(masters["dark"].resize((size, size), Image.Resampling.LANCZOS), folder / "ic_launcher_dark.png")
        save(masters["light"].resize((size, size), Image.Resampling.LANCZOS), folder / "ic_launcher_light.png")

    ios_app_icon = ROOT / "ios" / "Runner" / "App Icon"
    for name, master in masters.items():
        save(master.resize((120, 120), Image.Resampling.LANCZOS), ios_app_icon / f"{name}@2x.png")
        save(master.resize((180, 180), Image.Resampling.LANCZOS), ios_app_icon / f"{name}@3x.png")

    appiconset = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    for filename, size in IOS_APP_ICON_SPECS:
        save(masters["default"].resize((size, size), Image.Resampling.LANCZOS), appiconset / filename)

    assets = ROOT / "assets" / "icons"
    for name, master in masters.items():
        save(master.resize((256, 256), Image.Resampling.LANCZOS), assets / f"{name}.png")

    print("Iconos generados.")


if __name__ == "__main__":
    main()
