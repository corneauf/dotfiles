#!/usr/bin/env python3
import sys
from PIL import Image, ImageDraw, ImageFont
from screeninfo import get_monitors
import random
from typing import List
from pathlib import Path
from i3ipc import Connection, Event
from subprocess import run
import json

config_path = str(Path.home()) + "/.config/bg/config.json"

with open(config_path, "r") as f:
    config = json.load(f)


def draw_text(img: Image, phrases: List[str]):
    # TODO: Obtain font location from font name to simplify configuration file.
    font_path = config["font_location"]
    text = random.choice(phrases)
    fnt = ImageFont.truetype(font_path, 20)

    draw = ImageDraw.Draw(img)
    center = (img.width / 2, img.height / 2)
    draw.text(center, text, font=fnt, fill=255)


def draw_polygons(img: Image):
    draw = ImageDraw.Draw(img)

    possible_polygons = config["polygons"]
    n_sides = random.choice(possible_polygons)
    intensity_shifts = random.randint(*config["intensity_shifts"])
    intensity = 0
    center = (img.width / 2, img.height / 2)

    for i in reversed(range(1, intensity_shifts)):
        half_width = int(img.width)
        radius = (half_width / intensity_shifts) * i

        bounding_circle = (center, radius)

        draw.regular_polygon(bounding_circle, n_sides, fill=intensity)

        intensity += random.randint(*config["intensity_increments"])


def create_image() -> Image:
    monitor = get_monitors()[0]
    width = monitor.width
    height = monitor.height

    return Image.new("L", (width, height))


def main():
    background_path = config["background_location"] + "background.png"

    def workspace_event(i3, event):
        if event.change != "focus":
            return

        img = create_image()
        draw_polygons(img)
        draw_text(img, config["phrases"])

        img.save(background_path)
        run(["feh", "--bg-max", background_path])

    i3 = Connection()
    i3.on("workspace", workspace_event)
    i3.subscriptions = 0xFF
    i3.main()


if __name__ == "__main__":
    main()
