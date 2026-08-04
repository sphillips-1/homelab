#!/usr/bin/env python3

import logging
import select
import time
from pathlib import Path

import yaml
from evdev import InputDevice


CONFIG_FILE = Path(__file__).parent / "config.yaml"


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

logger = logging.getLogger("touchscreen-power")


def load_config():
    with CONFIG_FILE.open("r") as file:
        return yaml.safe_load(file)


def set_brightness(path, value):
    try:
        with open(path, "w") as file:
            file.write(str(value))

        logger.info("Brightness changed to %s", value)

    except Exception:
        logger.exception("Failed setting brightness")


def main():
    config = load_config()

    device_path = config["device"]

    backlight = config["backlight"]

    brightness_path = backlight["path"]

    active_brightness = backlight["active"]
    dim_brightness = backlight["dim"]
    low_brightness = backlight["low"]

    dim_timeout = backlight["idle_dim_seconds"]
    low_timeout = backlight["idle_low_seconds"]

    logger.info("Starting touchscreen power manager")
    logger.info("Touch device: %s", device_path)
    logger.info("Backlight: %s", brightness_path)

    device = InputDevice(device_path)

    logger.info("Detected device: %s", device.name)

    set_brightness(
        brightness_path,
        active_brightness
    )

    last_activity = time.monotonic()
    current_brightness = active_brightness

    while True:
        readable, _, _ = select.select(
            [device],
            [],
            [],
            5
        )

        now = time.monotonic()

        if readable:
            for event in device.read():
                # Any touchscreen event counts as activity
                last_activity = now

                if current_brightness != active_brightness:
                    set_brightness(
                        brightness_path,
                        active_brightness
                    )

                    current_brightness = active_brightness

        idle_time = now - last_activity

        if (
            idle_time >= low_timeout
            and current_brightness != low_brightness
        ):
            set_brightness(
                brightness_path,
                low_brightness
            )

            current_brightness = low_brightness

        elif (
            idle_time >= dim_timeout
            and current_brightness != dim_brightness
        ):
            set_brightness(
                brightness_path,
                dim_brightness
            )

            current_brightness = dim_brightness


if __name__ == "__main__":
    main()