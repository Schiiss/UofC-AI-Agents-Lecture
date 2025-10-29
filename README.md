# 🎬 UofC-AI-Agents-Lecture

Welcome to the **AI Agents Lecture**! This guide will walk you through each step to successfully complete the workshop.

---

## 🚀 Step 1: Log in to Databricks

1. Go to the [Databricks Free Edition sign-in page](https://docs.databricks.com/aws/en/getting-started/free-edition#sign-up-for-databricks-free-edition).
2. After signing in, you should see a homepage similar to the one below:

   ![Databricks Homepage](assets/databricks_free_edition_home_page.png)

---

## 📁 Step 2: Create a Git Folder

- Download the workshop content by creating a **Git folder** in Databricks.

  ![Create Git Folder](assets/create_git_folder.png)

---

## 🗂️ Step 3: Set Up Catalog, Schema, and Volume

Before working with the movie data, set up your workspace:

1. **Create a Catalog**  
   - Navigate to the **Catalog** tab.
   - Click **Create Catalog** and name it (e.g., `movies`).

     ![Create Catalog](assets/create_catalog.png)

2. **Create a Schema**  
   - Within your new catalog, click **Create Schema** and name it (e.g., `movies_db`).

     ![Create Schema](assets/create_schema.png)

3. **Create a Volume**  
   - Inside your schema, click **Create Volume** and name it (e.g., `pdfs`).
   - This is where you'll upload and store your movie PDFs.

     ![Create Volume](assets/create_volume.png)

---

## 🎥 Step 4: Download Movie PDFs from IMDb

1. Visit [IMDb](https://www.imdb.com/?ref_=tt_nv_home).
2. Use the search bar to find 4-5 of your favorite movies.

   ![Search IMDb](assets/search_imdb.png)

3. For each movie:
   - Press `Ctrl+P` to print the page.
   - Save it as a **PDF**.

     ![Save Movie as PDF](assets/save_movie_as_pdf.png)

---

## ⬆️ Step 5: Upload the Movies to Unity Catalog

- Go to your previously created volume.
- Click the **Upload** button and add your movie PDFs.

  ![Upload to Volume](assets/upload_to_volume.png)

---

## 🤖 Step 6: OCR the Movies

1. Navigate to `scripts/ocr_movies`.
2. Set the following configs:

   ![Upload to Volume](assets/ocr_script.png)

   - `destinationTableName`: `movies.movies_db.ocr`
   - `limit`: `100`
   - `partitionCount`: `4`
   - `sourceVolumePath`: `/Volumes/movies/movies_db/pdfs`

> **Note:**  
> This script reads files from storage, processes them (using AI for PDFs/images), and stores results in a new table. Errors are tracked, and all processed documents are combined for easy analysis.

3. Click **Run**:

   ![Run OCR Script](assets/run_ocr_script.png)

> ⏳ *Processing may take a few minutes. When finished, you'll have a table with extracted text from your movie PDFs.*

---

## 🔍 Step 7: Explore the OCR Table

1. Go to the **SQL Editor** tab and create a new query:

   ![Create OCR Table Query](assets/create_ocr_table_sql_query.png)

2. Use this prompt for AI:  
   > *"write me a SQL query that returns all rows in movies.movies_db.ocr"*

   ![AI Generated OCR Query](assets/ocr_sql_query_ai_assistant.png)

   The AI should generate:

   ```sql
   SELECT *
   FROM movies.movies_db.ocr
   ```

### 📝 Questions to Consider

- What does the data look like?
- Does the OCR content match the website?

---

## 🧠 Step 8: Extract Movie Metadata Using AI

- Create a new query and use this prompt for AI:  
  > *"using the ai_extract function to extract director, year_filmed, cast on the table movies.movies_db.ocr on the text column, create a column for each and write the output to movies.movies_db.movie_metadata"*

  ![AI Generated ai_extract query](assets/ai_extract_ai_assistant_prompt.png)

AI should write a query similar to this:

```sql
CREATE OR REPLACE TABLE movies.movies_db.movie_metadata AS
SELECT
  path,
  text,
  ai_extract(
    text,
    ARRAY('director', 'year_filmed', 'cast')
  ) AS extracted_entities,
  extracted_entities['director'] AS director,
  extracted_entities['year_filmed'] AS year_filmed,
  extracted_entities['cast'] AS cast
FROM movies.movies_db.ocr;
```
---

## 🗺️ Step 9: Explore the Metadata Table







