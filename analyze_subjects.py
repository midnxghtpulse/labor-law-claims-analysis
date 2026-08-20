import pandas as pd
from collections import Counter

df = pd.read_csv("data/trt5_processes_sample.csv")

all_subjects = []

for subjects in df["subjects"].dropna():
    for subject in subjects.split("|"):
        clean_subject = subject.strip()

        if clean_subject:
            all_subjects.append(clean_subject)

subject_counts = Counter(all_subjects)

top_subjects = pd.DataFrame(
    subject_counts.most_common(30),
    columns=["subject", "count"]
)

print(top_subjects.to_string(index=False))

top_subjects.to_csv(
    "data/top_subjects.csv",
    index=False,
    encoding="utf-8-sig"
)