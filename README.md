# UofC-AI-Agents-Lecture

Welcome to the AI Agents Lecture! This document will take you through the steps to successfully complete the workshop.

## Step 1: Login to Databricks

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
   Inside your schema, click "Create Volume" and name it (e.g., `movie_data`). This is where you'll upload and store your movie PDFs.

   ![Create Volume](assets/create_volume.png)



using the ai_extract function to extract director, year_filmed, cast on the table movies.movies_db.ocr on the text column, create a column for each and write the output to movies.movies_db.movie_metadata