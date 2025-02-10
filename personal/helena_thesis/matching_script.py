import pandas as pd
from rapidfuzz import process, fuzz

# -------------------------------
# Step 1: Load the CSV Files
# -------------------------------
# Replace 'wb.csv' and 'convergence.csv' with your actual file names.
wb = pd.read_csv('wb.csv')
conv = pd.read_csv('convergence.csv')

# -------------------------------
# Step 2: Preprocess the Data
# -------------------------------
# Standardise the text columns by converting to lowercase and stripping whitespace.
wb['Project Name'] = wb['Project Name'].str.lower().str.strip()
conv['Name'] = conv['Name'].str.lower().str.strip()

# For later reference, it is useful to have an identifier for each row in conv.
# Reset the index but keep the original index as a column (named 'orig_index').
conv = conv.reset_index(drop=False).rename(columns={'index': 'orig_index'})

# -------------------------------
# Step 3: Region Context Check
# -------------------------------
# We assume the wb file has a region column called 'Region2'. If the convergence file
# also has a region column (named 'Region'), then we can filter candidate matches by region.
region_filter = 'Region' in conv.columns

# -------------------------------
# Step 4: Define the Fuzzy Matching Function
# -------------------------------
def get_all_matches(query, choices, score_cutoff=80):
    """
    Finds all matches for a given 'query' from a list of 'choices' using token_set_ratio.
    Returns a list of tuples: (matched string, score, index) for matches above the score_cutoff.
    """
    # process.extractBests returns all candidates above the threshold.
    matches = process.extractBests(query, choices, scorer=fuzz.token_set_ratio, score_cutoff=score_cutoff)
    return matches

# -------------------------------
# Step 5: Prepare the Candidate Names List
# -------------------------------
# We create a list of candidate project names from the convergence file.
conv_names = conv['Name'].tolist()

# -------------------------------
# Step 6: Iterate Over wb and Find All Matches
# -------------------------------
results = []

for wb_idx, wb_row in wb.iterrows():
    project_name = wb_row['Project Name']
    region = wb_row['Region2'] if 'Region2' in wb_row else None  # region from wb file

    # Determine the candidate subset based on region if applicable.
    if region_filter and pd.notna(region):
        # Filter the convergence file to only include rows matching the wb region.
        conv_subset = conv[conv['Region'] == region].reset_index(drop=True)
        candidate_names = conv_subset['Name'].tolist()
        # Use the fuzzy matching function to find all candidates above the threshold.
        matches = get_all_matches(project_name, candidate_names, score_cutoff=80)

        if matches:
            # There might be more than one candidate match (many-to-one).
            for match in matches:
                matched_name, score, match_idx = match
                # Retrieve the corresponding row from conv_subset to capture extra details.
                conv_row = conv_subset.iloc[match_idx]
                results.append({
                    'wb_index': wb_idx,
                    'Project Name': project_name,
                    'Region2': region,
                    'Matched Name': matched_name,
                    'Match Score': score,
                    'conv_orig_index': conv_row['orig_index']
                })
        else:
            # No candidate in the filtered convergence subset reached the cutoff.
            results.append({
                'wb_index': wb_idx,
                'Project Name': project_name,
                'Region2': region,
                'Matched Name': None,
                'Match Score': None,
                'conv_orig_index': None
            })
    else:
        # If region filtering is not applicable, use the full convergence file.
        matches = get_all_matches(project_name, conv_names, score_cutoff=80)

        if matches:
            for match in matches:
                matched_name, score, match_idx = match
                conv_row = conv.iloc[match_idx]
                results.append({
                    'wb_index': wb_idx,
                    'Project Name': project_name,
                    'Region2': region,
                    'Matched Name': matched_name,
                    'Match Score': score,
                    'conv_orig_index': conv_row['orig_index']
                })
        else:
            results.append({
                'wb_index': wb_idx,
                'Project Name': project_name,
                'Region2': region,
                'Matched Name': None,
                'Match Score': None,
                'conv_orig_index': None
            })

# -------------------------------
# Step 7: Convert Results to a DataFrame and Save
# -------------------------------
results_df = pd.DataFrame(results)

# Optionally, inspect the first few results.
print(results_df.head())

# Save the matching results to a CSV file.
results_df.to_csv('matched_projects_many_to_one.csv', index=False)