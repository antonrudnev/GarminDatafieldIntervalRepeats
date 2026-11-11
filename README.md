# Swim Interval Reps

**Swim Interval Reps** is a lightweight Garmin Connect IQ `SimpleDataField` built for swimmers to automatically count and display repeated interval sets in standard swim notation (such as `10x50`, `5x200`, or `2x800`) directly on your watch during pool sessions.

---

## ✨ Key Features

* **Automatic Rep & Distance Tracking:** Automatically tracks consecutive intervals of the same distance and increments the repetition counter on every lap (`onTimerLap`) or completed workout step (`onWorkoutStepComplete`).
* **Live Swim vs. Rest Display:**
  * **While Swimming (Active Interval):** Displays your real-time distance covered in the current interval.
  * **During Rest / Between Intervals:** When 2 or more consecutive intervals of the same distance are completed, cycles every 3 seconds between the formatted set notation (e.g., `10x50`) and the single-interval distance (or rep count, depending on your format string).
* **Customizable Set Formatting (`RepsValueFormat`):** Uses Monkey C string placeholders (`$1$` for repeat count, `$2$` for interval distance) so you can customize how sets are displayed (e.g., `$1$x$2$` → `10x50`).
* **Post-Lap Distance Sync (`UpdateLimit`):** Re-checks `elapsedDistance` for a configurable number of compute cycles after a lap button press to handle delayed pool-length distance updates accurately.
* **Optional Reset on Stop (`FieldReset`):** Choose whether the repeat counter resets to `0` when the activity timer is stopped (`onTimerStop`) or persists across pauses.
* **Broad Device Compatibility & Zero Permissions:** Supports Connect IQ API `3.1.0+` (including fēnix 6/7/8 and Forerunner 55 through 970) and requires zero external permissions.

---

## 📊 How It Works

1. **First Interval (`repeatCounter = 1`):** When you finish your first interval (e.g., `50m`), the field records `lastIntervalDistance = 50` and displays `50` during rest.
2. **Repeated Intervals (`repeatCounter > 1`):** Each subsequent interval matching `lastIntervalDistance` increments `repeatCounter` (`2`, `3`, ..., `10`).
3. **Rest Screen Alternation:** While resting (`elapsedDistance == currentTotalDistance`) with `repeatCounter > 1`, the display alternates on a 3-second cycle (`sec % 3 == 0`) between your formatted string (`$1$x$2$`, e.g., `10x50`) and the interval distance (`50`).
4. **New Set Distance:** As soon as you complete an interval of a different distance (e.g., switching from `50s` to `200s`), `lastIntervalDistance` updates to the new distance and `repeatCounter` automatically resets to `1`.

---

## 📱 Supported Devices

Requires **Connect IQ API Level 3.1.0** or higher:

* **fēnix 6 Series:** fēnix 6, 6S, 6 Pro, 6S Pro, 6X Pro
* **fēnix 7 Series:** fēnix 7, 7S, 7X, 7 Pro, 7S Pro, 7X Pro (including No Wi-Fi editions)
* **fēnix 8 & fēnix E Series:** fēnix 8 (43mm, 47mm), fēnix 8 Pro (47mm), fēnix 8 Solar (47mm, 51mm), fēnix E
* **Forerunner Series:** Forerunner 55, 70, 165 / 165 Music, 170 / 170 Music, 245 / 245 Music, 255 / 255S / 255 Music / 255S Music, 265 / 265S, 570 (42mm, 47mm), 645 / 645 Music, 745, 935, 945 / 945 LTE, 955, 965, 970

---

## ⚙️ Configuration & Settings

Customize **Swim Interval Reps** via the **Garmin Connect** app or **Garmin Express**:

### General Settings

| Property | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `DefaultTag` | Text (`alphaNumeric`) | Required, max 10 chars | Custom label displayed above the data field value. |

### Advanced Settings

| Property | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `RepsValueFormat` | Text (`alphaNumeric`) | Required, max 10 chars | Format template for repeated sets (`$1$` = reps, `$2$` = interval distance, e.g., `$1$x$2$`). If `$1$` is omitted, the alternating display shows `repeatCounter` instead of `lastIntervalDistance`. |
| `FieldReset` | Toggle (`boolean`) | — | When enabled, resets `repeatCounter` to `0` whenever the activity timer is stopped (`onTimerStop`). |
| `UpdateLimit` | Number (`numeric`) | `0` – `10` | Number of `compute()` ticks after a lap press to keep checking for updated `elapsedDistance` values. |

---

## 📲 Installation

1. Download **Swim Interval Reps** from the [Garmin Connect IQ Store](https://apps.garmin.com/apps/65a05247-b38a-45ec-933d-db794dcf4af8).
2. Sync your watch using **Garmin Connect** or **Garmin Express**.
3. On your Garmin device, open **Pool Swim** (or **Open Water**) → **Activity Settings** → **Data Screens**.
4. Choose a layout slot and assign **Connect IQ Fields** → **Swim Interval Reps**.

---

## 🛠️ Building from Source

### Prerequisites
* [Visual Studio Code](https://visualstudio.com) with the **Monkey C** extension.
* [Garmin Connect IQ SDK Manager](https://developer.garmin.com/connect-iq/sdk/) (SDK supporting API 3.1.0+) and a valid developer key.

### Build & Run
1. Clone the repository:
   ```bash
   git clone https://github.com
   cd GarminDatafieldIntervalRepeats
   ```
2. Open the folder in **VS Code**.
3. Press `F5` (or run **Monkey C: Build for Device** from the Command Palette) to launch the Connect IQ Simulator.

---

## 📂 Project Structure

```text
GarminDatafieldIntervalRepeats/
├── resources/        # App icons, strings, layouts, and settings XMLs
├── source/           # Monkey C (.mc) source code (IntervalRepsDataFieldView, etc.)
├── manifest.xml      # App metadata, API level (3.1.0), and target devices
└── monkey.jungle     # Build configuration and resource mapping
```

---

## 👤 Author

* **Anton Rudnev** (`@antonrudnev` / **endurolabs**)
* **Connect IQ Store:** [Swim Interval Reps](https://apps.garmin.com/apps/65a05247-b38a-45ec-933d-db794dcf4af8)
