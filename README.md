This repo contains the components required to replace the Q&A feature from the M365 Search And Intelligence Admin center, retired April 2025.

## Components
The Prerequisites folder contains the following components:
- **Termstore pre-requisites**: Creating the Term Store Group "QnA" and the Term Set "QuestionAndAnswerCategory", and finally creats a Term "Dummy" in the Term Set "QuestionAndAnswerCategory".

- **Content type gallery**: Creating the required Site Colomns and content type "QuestionsAndAnswers" in the content type gallery.


Running the EnsurePrerequisites.ps1 will create the Term Store Group, Term Set and Term, and the Site Columns and Content Type in the content type gallery.

Run Deploy.ps1 to deploy the QnA solution. This will create the required list "QnA" in the site collection of your choice, and add the content type "QuestionsAndAnswers" to the list. It will also create a new view "QnA" for the list, and set it as the default view.

Add some test data to the list. This will trigger the search crawler to index the list content, and create the crawled and managed properties required for the QnA solution to work.

Once you can see the managed properties in the search schema in the SharePoint admin center, you should map these crawled properties to the RefinableDate/String as follows:
- RefinableDateXX -> ows_QnA_ValidFromDate
- RefinableDateYY -> ows_QnA_ValidToDate
- RefinableStringXX -> ows_taxId_QnA_QuestionAndAnswerCategory

Hit the Reindex button in the Site Collection settings (Search and offline availability) to trigger a reindexing. I recommend using either the [SP Editor browser extension](https://chromewebstore.google.com/detail/sp-editor/ecblfcmjnbbgaojblcpmjoamegpbodhd) or the [SharePoint Search Query Tool](https://github.com/pnp/PnP-Tools/blob/master/Solutions/SharePoint.Search.QueryTool/README.md) to check if the mapping has been completed successfully.

in my case the mapping looked like this:
- RefinableDate03 -> ows_QnA_ValidFromDate
- RefinableDate04 -> ows_QnA_ValidToDate
- RefinableString15 -> ows_taxId_QnA_QuestionAndAnswerCategory