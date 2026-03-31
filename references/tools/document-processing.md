# Document Processing Tools

**SkillHub Skills**: `pdf-text-extractor`, `document-pro`, `parser`

---

## PDF Text Extraction (pdf-text-extractor)

**零依赖** - 开箱即用

```bash
# Extract text from PDF
node ~/.agents/skills/pdf-text-extractor/scripts/extract.js "document.pdf"

# OCR for scanned documents
node ~/.agents/skills/pdf-text-extractor/scripts/extract.js "scanned.pdf" --ocr

# Batch processing
node ~/.agents/skills/pdf-text-extractor/scripts/batch.js "*.pdf"
```

**Features**:
- Embedded text extraction
- OCR for scanned documents
- Batch processing
- Multiple languages support

---

## Office Documents (document-pro)

**依赖**: `pip3 install pdfplumber PyPDF2 python-docx python-pptx openpyxl`

```python
# PDF tables
import pdfplumber
with pdfplumber.open("doc.pdf") as pdf:
    for page in pdf.pages:
        tables = page.extract_tables()

# Word documents
from docx import Document
doc = Document("doc.docx")
for para in doc.paragraphs:
    print(para.text)

# Excel files
import openpyxl
wb = openpyxl.load_workbook("data.xlsx")
ws = wb.active
for row in ws.iter_rows():
    print([cell.value for cell in row])
```

---

## Data Parsing (parser)

**依赖**: `jq` (brew install jq) 或 `python3`

```bash
# JSON
~/.agents/skills/parser/scripts/script.sh json < file.json

# CSV (with column extraction)
~/.agents/skills/parser/scripts/script.sh csv < file.csv

# XML (with XPath)
~/.agents/skills/parser/scripts/script.sh xml < file.xml

# YAML
~/.agents/skills/parser/scripts/script.sh yaml < file.yaml
```
