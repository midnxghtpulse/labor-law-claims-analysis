# labor law claims analysis

i wanted to build something with legal data - obrigado, clarinha - that was actually useful beyond just showing a few charts.

so this project started with a pretty simple question:

**if a labor claim contains x, what usually appears with it?**

from there, the idea grew into a small legal analytics project using public labor court data from brazil.

the data comes from the public datajud api, maintained by the conselho nacional de justiça (cnj), and the current version focuses on first-degree cases from trt5, the labor court of bahia.

right now, i'm using the data to explore recurring labor-law subjects, relationships between claims and the statistical profile of different labor courts.

---

## what i'm trying to answer

instead of throwing random charts at the dataset, i started with questions i could actually imagine someone in the legal field asking:

* which labor-law subjects appear the most?
* if a case has a certain subject, what usually appears with it?
* which claims tend to show up together?
* what does the statistical profile of a specific labor court look like?
* which themes appear unusually often or unusually rarely in a court compared with trt5 overall?
* which combinations of themes are especially common inside a specific court?

basically, i'm trying to turn a giant pile of procedural metadata into something easier to explore.

---

## project status

still building this one, but the main analysis structure is already working.

so far, i've:

* connected to the datajud api
* collected 10,000 first-degree trt5 cases
* cleaned and prepared the data with python
* normalized labor-law subjects
* created custom analytical themes
* measured subject frequency
* calculated claim co-occurrence
* calculated directional associations between themes
* loaded the processed dataset into postgresql
* built reusable sql queries for association and court-level analysis
* built a reusable association explorer in sql
* created court-level theme profiles
* compared individual courts with the trt5 baseline
* identified the most frequent theme combinations by court

next up:

* prepare the final views for power bi
* build the dashboard
* polish the final insights and documentation

---

## stack

`python` `pandas` `requests` `postgresql` `sql` `power bi`

---

## data source

the project uses public procedural metadata from the datajud api, provided by the conselho nacional de justiça.

the current development dataset contains 10,000 first-degree cases from trt5.

the full process-level datasets are generated locally instead of being stored in the repository.

to collect the data:

`python src/collect_data.py`

---

## the themes i'm looking at

for now, i selected ten themes that showed up often enough to be interesting:

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

these are analytical categories built from the procedural subjects available in datajud.

---

## what shows up the most?

among the 10,000 collected cases:

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

this is useful as context, but the part i find more interesting comes next.

---

## if i have x, what usually comes with it?

this is the feature that became the main idea behind the project.

say someone selects:

`moral damages`

instead of only showing how often moral damages appear, the analysis asks:

**what else tends to be present in those same cases?**

in the current dataset:

| associated theme | share of moral damages cases |
|---|---:|
| overtime | 44.85% |
| fgts | 44.35% |
| notice pay | 29.63% |
| severance payments | 25.83% |
| intraday work interval | 20.59% |
| unhealthy work conditions | 15.35% |
| indirect termination | 12.98% |
| recognition of employment relationship | 10.92% |
| hazardous work conditions | 7.36% |

so, for example:

**44.85% of the cases in this dataset that contain moral damages also contain overtime.**

some other associations i found interesting:

| starting theme | associated theme | association |
|---|---|---:|
| intraday work interval | overtime | 75.94% |
| notice pay | fgts | 69.32% |
| recognition of employment relationship | fgts | 56.73% |
| indirect termination | fgts | 46.90% |

this is where the project starts feeling less like a dashboard and more like an exploration tool.

---

## exploring combinations

i also wanted to see which themes appear together most often in absolute numbers.

some of the strongest combinations so far:

| theme 1 | theme 2 | cases |
|---|---|---:|
| fgts | notice pay | 1,593 |
| overtime | fgts | 1,101 |
| severance payments | fgts | 928 |
| overtime | notice pay | 795 |
| overtime | moral damages | 719 |
| moral damages | fgts | 711 |
| overtime | intraday work interval | 609 |

one thing i like about this part is that the direction matters.

for example:

`notice pay -> fgts`

is not the same question as:

`fgts -> notice pay`

because the percentage is calculated based on the starting theme.

---

## court dna

another feature i'm building is what i've been calling **court dna**.

the idea is to select a labor court and generate a statistical profile of the cases that appear there in the analyzed dataset.

the profile currently has three parts:

### theme incidence

for each court, i calculate how often each selected theme appears.

for example, in the current dataset:

`1ª vara do trabalho de vitória da conquista`

| theme | court | trt5 | difference |
|---|---:|---:|---:|
| fgts | 54.17% | 29.35% | +24.82 p.p. |
| notice pay | 34.17% | 22.98% | +11.19 p.p. |
| intraday work interval | 9.17% | 8.02% | +1.15 p.p. |
| moral damages | 15.00% | 16.03% | -1.03 p.p. |
| severance payments | 14.17% | 18.41% | -4.24 p.p. |
| overtime | 18.33% | 25.02% | -6.69 p.p. |

the `difference` column shows how many percentage points above or below the trt5 baseline that theme appears in the selected court.

### most common combinations

the analysis also automatically finds the most frequent pairs of themes inside each court.

for example, in the `1ª vara do trabalho de alagoinhas`:

| combination | cases | share of court cases |
|---|---:|---:|
| notice pay + fgts | 28 | 21.88% |
| fgts + overtime | 23 | 17.97% |
| fgts + severance payments | 20 | 15.63% |
| notice pay + severance payments | 18 | 14.06% |
| notice pay + overtime | 18 | 14.06% |

the interesting part here is that different courts can show noticeably different subject mixes and combinations, even when the analysis stays entirely at the level of procedural metadata.

### comparison with trt5

instead of just ranking courts by raw case volume, the project compares each court with the overall trt5 baseline.

that makes it easier to spot things like:

`fgts appears 24.82 percentage points above the trt5 baseline`

or:

`overtime appears 6.69 percentage points below the trt5 baseline`

for the selected court.

i think this makes the court profile much more useful than a simple list of counts.

---

## one important limit

this project is about **statistical patterns**, not legal conclusions.

if two themes frequently appear together, that does not mean both claims are legally applicable to a specific case.

the tool is not meant to say things like:

* this court is favorable to employees
* this judge usually rules a certain way
* this claim should be included
* this case has a certain chance of winning
* one court is "better" or "worse" for a specific party

that would be way beyond what this data can responsibly support.

a better way to read the results is:

**“these subjects frequently appear together in the analyzed procedural data.”**

or, in the case of court dna:

**“this theme appears more or less frequently in the analyzed cases from this court compared with the trt5 baseline.”**

that's it.

---

## how the pipeline works

the project currently has both a python layer and a sql layer.

### python

the python side:

1. collects public process metadata from datajud
2. extracts the fields i actually care about
3. cleans and normalizes subject names
4. creates binary theme indicators
5. counts subject frequency
6. measures co-occurrence between themes
7. calculates directional associations

### postgresql + sql

the processed dataset is then loaded into postgresql.

the sql layer:

1. validates the imported dataset
2. reshapes the theme columns into a reusable long-format view
3. builds the association explorer
4. calculates theme incidence by court
5. compares each court with the trt5 baseline
6. automatically finds the most frequent theme combinations by court

for example:

if 100 cases contain `notice pay` and 70 of them also contain `fgts`:

`notice pay -> fgts = 70%`

simple idea, but surprisingly useful once you start comparing a lot of themes.

---

## project structure

labor-law-claims-analysis/

data/
- README.md
- top_subjects.csv
- theme_associations.csv
- theme_cooccurrence.csv

images/
- README.md

sql/
- database_setup.sql
- first_analysis.sql
- association_explorer.sql
- court_dna.sql

src/
- analyze_associations.py
- analyze_cooccurrence.py
- analyze_subjects.py
- collect_data.py
- prepare_data.py

README.md

---

## scripts

### `collect_data.py`

talks to the datajud api and collects the process metadata.

### `prepare_data.py`

cleans the subjects and creates the analytical theme columns.

### `analyze_subjects.py`

finds the most frequent procedural subjects.

### `analyze_cooccurrence.py`

checks how often two themes appear in the same case.

### `analyze_associations.py`

answers the question:

**given theme x, how often does theme y appear too?**

---

## sql

### `database_setup.sql`

creates the main `labor_claims` table used to store the processed dataset.

### `first_analysis.sql`

contains the initial sql validation, exploratory queries and early versions of the association and court-level analyses.


### `association_explorer.sql`

contains the reusable sql logic behind:

**if i have x, what usually comes with it?**

### `court_dna.sql`

contains the court-level analysis, including:

* theme incidence by court
* comparison with the trt5 baseline
* percentage-point differences
* most common theme combinations by court

---

## where this is going

the final version should have three main views:

### overview

what themes appear the most and what the dataset looks like.

### association explorer

pick a theme and see what usually comes with it.

### court dna

pick a labor court and explore:

* its most frequent themes
* how those themes compare with trt5 overall
* the themes that stand out the most
* its most frequent combinations of claims

---

## next steps

* create reusable sql views for power bi
* connect power bi to postgresql
* build the overview page
* build the association explorer
* build the court dna page
* refine the final insights and documentation

---

## disclaimer!

i'm not trying to predict court decisions with this project!

i just think there is a lot of useful information hidden in procedural metadata, and i wanted to see how much of it i could make easier to explore.

statistical incidence does not mean legal applicability, and differences between courts should not be interpreted as judicial bias, likelihood of success or legal advice.
