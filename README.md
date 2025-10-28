# UofC-AI-Agents-Lecture

Welcome to the AI Agents Lecture! This document will guide you through the steps to successfully complete the workshop.

## Step 1: Log in to Databricks

Navigate to the [sign-in page](https://docs.databricks.com/aws/en/getting-started/free-edition#sign-up-for-databricks-free-edition) for Databricks Free Edition. After signing in, you should see something like this:

![Databricks Homepage](assets/databricks_free_edition_home_page.png)

## Step 2: Create a Git Folder

The next thing we need to do is download the content for the workshop. You can do this by creating a 'Git folder' in Databricks.

![Create Git Folder](assets/create_git_folder.png)

## Step 3: Set Up Catalog, Schema, and Volume

Before working with the movie data, you'll need to create a Unity Catalog, a schema within that catalog, and a volume to store your files.

1. **Create a Catalog:**  
   In Databricks, navigate to the 'Catalog' tab, click "Create Catalog", and name it (e.g., `movies`).

   ![Create Catalog](assets/create_catalog.png)

2. **Create a Schema:**  
   Within your new catalog, click "Create Schema" and name it (e.g., `movies_db`).

   ![Create Schema](assets/create_schema.png)

3. **Create a Volume:**  
   Inside your schema, click "Create Volume" and name it (e.g., `pdfs`). This is where you'll upload and store your movie PDFs.

   ![Create Volume](assets/create_volume.png)

## Step 4: Navigate to IMDb and download 4-5 movies

Navigate to [IMDb](https://www.imdb.com/?ref_=tt_nv_home) and download 4-5 of your favourite movies. You can do this by using the global search bar at the top of the page.

![Search IMDb](assets/search_imdb.png)

Once you have found a movie you like, press Ctrl+P on your keyboard and print the page to PDF:

![Save Movie as PDF](assets/save_movie_as_pdf.png)

## Step 5: Upload the movies to Unity Catalog

Next, we need to get the movies into a place where we can start leveraging AI. You can do this by navigating to the previously created volume and selecting the 'Upload' button:

![Upload to Volume](assets/upload_to_volume.png)

## Step 6: OCR the Movies

Navigate to the scripts/ocr_movies and ensure you have the following configs set:

![Upload to Volume](assets/ocr_script.png)

- destinationTableName: movies.movies_db.ocr
- limit: 100
- partitionCount: 4
- sourceVolumePath: /Volumes/movies/movies_db/pdfs

This script reads files from a specified storage location, processes them based on their file type, and stores the results in a new table. For supported document types (like PDFs and images), it uses AI to extract and parse their contents. For other files, it simply decodes the text. It also tracks any errors during parsing. The final table combines all processed documents, making it easier to analyze and search their contents for business insights.

Once you have set your configurations, select 'Run':

![Run OCR Script](assets/run_ocr_script.png)

This will take a few minutes to run, but at the end, you should get a new table with your movie PDFs' text extracted.

## Step 7: Explore the OCR table

Navigate to the 'SQL Editor' tab and create a new query:

![Create OCR Table Query](assets/create_ocr_table_sql_query.png)

Use the following prompt and click generate to have AI write the SQL code for you: 'write me a SQL query that returns all rows in movies.movies_db.ocr'

![AI Generated OCR Query](assets/ocr_sql_query_ai_assistant.png)

The AI should generate something similar to the below

```sql
SELECT *
FROM movies.movies_db.ocr
```

### Questions to consider

- What does the data look like?
- Does the OCR content match the website?

## Step 8: Extract metadata using AI

Similar to last time, create a new query and use the following prompt to have AI write the query for you: 'using the ai_extract function to extract director, year_filmed, cast on the table movies.movies_db.ocr on the text column, create a column for each and write the output to movies.movies_db.movie_metadata'










