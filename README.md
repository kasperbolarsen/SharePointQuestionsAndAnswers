This repo contains the components required to replace the Q&A feature from the M365 Search And Intelligence Admin center, retired April 2025.

## Components
The Prerequisites folder contains the following components:
- **Termstore pre-requisites**: Creating the Term Store Group "QnA" and the Term Set "QuestionAndAnswerCategory", and finally creats a Term "Dummy" in the Term Set "QuestionAndAnswerCategory".

- **Content type gallery**: Creating the required Site Colomns and content type "QuestionsAndAnswers" in the content type gallery.


Running the EnsurePrerequisites.ps1 will create the Term Store Group, Term Set and Term, and the Site Columns and Content Type in the content type gallery.

