# 📸 PiBoCa / **Pi** **Bo**dy **Ca**mera
A small camera project connected to Raspberry Pi using gPhoto2 and processed with GraphicsMagick, controlled from the iPhone app Shortcuts.

## Ongoing Development
This is a project that is under active development from time to time. The script is in a draft stage with comments and a to-do list of things to be done and/or optimized. Use of the script as it is now is at your own risk.

The code is currently a bit primitive due to limited knowledge of bash scripting, but the most important thing is that it works for its intended purpose. I would like to become more familiar with bash scripting and would be thankfully for pull requests with improvements.

## Purpose
This script is part of a project I am working on. The tool is part of my goal to lose weight, combined with activity, exercise, and diet, with advice and guidance from a doctor and nutritionist. Both to motivate myself to lose weight and learn more about bash scripting.

The motivation to create the tool is to document the process of taking a full-body picture of myself over a longer period of time. As a photographer and coder with OCD, the goal was to build a setup that can take a proper picture every time.

When taking a picture, you have the opportunity to adjust the position based on the previous picture you took earlier, before taking the picture.

Over a longer period of time, you will have a large number of images that show the process of weight loss. From here, only creativity sets limits with the use of the images.

### Future Plans:
I have ambitions for the script. A lot of time has gone into getting to know bash scripting, which is actually a small part of the idea behind the tool. The fun part of the tool isn't even the script yet.

- Import health data in clear text in txt, csv, or json.
    - Weight, BMI, body fat, muscle mass, bone mass, water in the body. With date/time and changes since last.
- Create a timelapse with `ffmpeg`, for the whole or limited period.
- Generate graphs with multiple points from health data.

### Setup
I used what I had available at home, and naturally chose for use and need.

### Hardware set up for the project:
- Raspberry Pi 3 Model B Plus Rev 1.3
    - Raspberry Pi OS > Bullseye (2021-10-30)
- Canon PowerShot G9
- AC power adapter
- USB cable

### Necessary programs to run the script:
- `gphoto2` > `2.5.27.1`
    - `libgphoto2` > `2.5.22`
- `GraphicsMagick` > `1.3.35` (2020-02-23)

### Further setup
For this setup, the focus is to make it as simple as possible to operate PiBoCa with iPhone to trigger the photo shoot, with the help of Shortcuts. Beyond this, you are free to make adjustments as needed.

- Wired or WiFi connection
- Camera tripod
- iOS app Shortcuts

---

This text was translated from Norwegian to English with the help of ChatGPT, which has become a tool to improve my scripting skills and drives the project forward.