# Redmine PDF Thai Font

A tiny Redmine plugin that makes **Thai text show correctly in PDF export**
for users whose language is English (or any other language that uses a Latin PDF font).

[ภาษาไทยด้านล่าง](#ภาษาไทย)

## The problem

Redmine picks the PDF font from the **user's language** (`general_pdf_fontname` in the locale file):

| User language | PDF font | Has Thai glyphs? |
| --- | --- | --- |
| English, German, French, ... | `freesans` / `dejavusans` | ❌ No |
| Thai | `freeserif` | ✅ Yes |

So when a user with the English UI exports an issue, wiki page or issue list to PDF,
every Thai character is drawn as an empty box (□□□).

The usual workaround is to edit `lib/redmine/export/pdf.rb`, but that change is lost
on every Redmine upgrade (and on every new image if you run Redmine in Docker).

## What this plugin does

After Redmine creates a PDF document, the plugin switches the font to **FreeSerif**
(which ships with Redmine and contains Thai) when the user's PDF font has no Thai glyphs:

- `freesans`, `freemono`, `dejavusans`, `dejavusansmono` → `freeserif`
- Languages that already use another font are **not changed** — Thai keeps `freeserif`,
  Japanese / Chinese / Korean keep their CJK fonts (forcing FreeSerif would break their own characters).

No Redmine core files are modified, no settings, no database changes.

## Compatibility

- Redmine **4.2** or later (tested on Redmine **7.0.2**).
- Works in a normal installation and with the official `redmine` Docker image.

## Installation

```bash
cd /path/to/redmine/plugins
git clone https://github.com/<your-github-username>/redmine_pdf_thai_font.git
```

The folder name must be `redmine_pdf_thai_font`. Then restart Redmine, for example:

```bash
# Passenger / Apache
touch /path/to/redmine/tmp/restart.txt

# Docker (official image, plugins mounted at ./plugins)
docker-compose restart redmine
```

No database migration is needed. The plugin appears in *Administration → Plugins*.

## Uninstallation

Delete the `plugins/redmine_pdf_thai_font` folder and restart Redmine.

## Known limitation

FreeSerif has a problem drawing **bold** Thai, so Redmine itself removes bold when FreeSerif is used.
Text that is bold in a normal PDF (e.g. headings) is printed in regular weight.

## License

[MIT](LICENSE) © Tanachart Changcharoen

---

## ภาษาไทย

plugin ขนาดเล็กสำหรับ Redmine ที่ทำให้ **export PDF แล้วภาษาไทยแสดงถูกต้อง**
สำหรับ user ที่ตั้งภาษาเป็นอังกฤษ (หรือภาษาอื่นที่ใช้ font ละติน)

### ปัญหา

Redmine เลือก font ของ PDF ตาม**ภาษาของ user** — ภาษาอังกฤษใช้ `freesans` ซึ่ง**ไม่มีตัวอักษรไทย**
(มีเฉพาะ `freeserif` ที่ใช้กับภาษาไทย) ผลคือ export issue / wiki / รายการ issue เป็น PDF แล้ว
ภาษาไทยกลายเป็นสี่เหลี่ยม □□□

วิธีแก้เดิมคือแก้ไฟล์ `lib/redmine/export/pdf.rb` ซึ่งจะหายทุกครั้งที่อัปเกรด Redmine
(และทุกครั้งที่สร้าง container ใหม่ถ้าใช้ Docker)

### plugin นี้ทำอะไร

- ภาษาที่ใช้ font ไม่มีภาษาไทย (`freesans`, `freemono`, `dejavusans`, `dejavusansmono`) → เปลี่ยนเป็น `freeserif`
- ภาษาอื่นไม่เปลี่ยน — ภาษาไทยใช้ `freeserif` อยู่แล้ว, ญี่ปุ่น / จีน / เกาหลี ใช้ font ของภาษานั้นตามเดิม
- ไม่แก้ไฟล์ของ Redmine, ไม่มีหน้าตั้งค่า, ไม่แก้ฐานข้อมูล

### ติดตั้ง

```bash
cd /path/to/redmine/plugins
git clone https://github.com/<your-github-username>/redmine_pdf_thai_font.git
```

ชื่อโฟลเดอร์ต้องเป็น `redmine_pdf_thai_font` แล้ว restart Redmine (Docker: `docker-compose restart redmine`)
ไม่ต้องรัน migration

### ถอนการติดตั้ง

ลบโฟลเดอร์ `plugins/redmine_pdf_thai_font` แล้ว restart Redmine

### ข้อจำกัด

FreeSerif แสดงภาษาไทย**ตัวหนา**ไม่ถูกต้อง Redmine จึงตัดตัวหนาออกเมื่อใช้ FreeSerif
ข้อความที่ปกติเป็นตัวหนา (เช่นหัวข้อ) จะแสดงเป็นตัวปกติ
