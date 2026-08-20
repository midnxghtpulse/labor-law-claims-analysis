# labor law claims analysis!

this project analyzes public labor court data from brazil to identify recurring legal subjects and patterns in labor litigation (obrigado pela ideia, clarinha!)

the data is collected from the public datajud api, maintained by the conselho nacional de justiça (cnj), with an initial focus on first-degree cases from trt5, the labor court of bahia.

the goal is to explore questions such as:

* which labor-law subjects appear most frequently?
* which claims tend to appear together in the same case?
* how common are topics such as overtime, moral damages, unhealthy work conditions and indirect termination?
* which subjects are strongly associated with fgts, notice pay and severance-related claims?

---

## project status

this project is currently in development.

so far, the pipeline includes:

* data collection from the datajud api
* extraction of 10,000 first-degree trt5 cases
* data cleaning and preparation with python
* classification of selected labor-law themes
* subject frequency analysis
* co-occurrence and association analysis

the next steps are to load the processed data into postgresql, perform sql analysis and build a power bi dashboard.

---

## tech stack

`python` `pandas` `requests` `postgresql` `sql` `power bi`

---

## data source

the project uses public metadata from the datajud api, provided by the conselho nacional de justiça.

the current dataset contains 10,000 first-degree cases from trt5.

the raw dataset is generated locally through:

`python src/collect_data.py`

the generated process-level csv files are not stored in this repository.

---

## themes analyzed

the current analysis focuses on the following subjects:

* overtime
* moral damages
* unhealthy work conditions
* hazardous work conditions
* recognition of employment relationship
* indirect termination
* severance payments
* fgts
* notice pay
* intraday work interval

---

## initial findings

among the 10,000 collected cases, some of the most frequent selected themes were:

| theme | cases |
|---|---:|
| fgts | 2,935 |
| overtime | 2,502 |
| notice pay | 2,298 |
| severance payments | 1,841 |
| moral damages | 1,603 |
| unhealthy work conditions | 818 |
| intraday work interval | 802 |
| recognition of employment relationship | 684 |
| indirect termination | 661 |
| hazardous work conditions | 347 |

these values represent the custom theme classification used in the project, which may group multiple related procedural subjects under the same category.

---

## claims often appear together

one of the main goals of the project is to go beyond individual frequencies and explore which subjects tend to appear in the same case.

some of the strongest combinations found so far include:

| theme 1 | theme 2 | cases |
|---|---|---:|
| fgts | notice pay | 1,593 |
| overtime | fgts | 1,101 |
| severance payments | fgts | 928 |
| overtime | notice pay | 795 |
| overtime | moral damages | 719 |
| moral damages | fgts | 711 |
| overtime | intraday work interval | 609 |

some associations are especially noticeable.

for example, around **75.9% of cases involving intraday work interval also include overtime**, while approximately **69.3% of cases involving notice pay also include fgts**.

---

## project structure

labor-law-claims-analysis/
├── data/
│   ├── README.md
│   ├── top_subjects.csv
│   ├── theme_associations.csv
│   └── theme_cooccurrence.csv
├── images/
│   └── README.md
├── sql/
│   └── first_analysis.sql
├── src/
│   ├── analyze_associations.py
│   ├── analyze_cooccurrence.py
│   ├── analyze_subjects.py
│   ├── collect_data.py
│   └── prepare_data.py
└── README.md

---

## python pipeline

### collect data

`src/collect_data.py`

collects process metadata from the datajud api and saves the local dataset.

### prepare data

`src/prepare_data.py`

normalizes the subject descriptions and creates binary columns for the selected labor-law themes.

### analyze subjects

`src/analyze_subjects.py`

counts the most frequent procedural subjects in the collected cases.

### analyze co-occurrence

`src/analyze_cooccurrence.py`

measures how often two selected themes appear in the same case.

### analyze associations

`src/analyze_associations.py`

calculates the percentage of cases involving one theme that also include another theme.

---

## next steps

* create the postgresql database
* load the processed dataset into sql
* analyze filing trends over time
* explore differences between judging bodies and municipalities
* build a power bi dashboard
* document the final business and legal-data insights

---

this project is focused on patterns in public procedural metadata and does not attempt to evaluate the legal merits or outcome of individual cases.
