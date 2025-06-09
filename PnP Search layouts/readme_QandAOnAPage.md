When you want to add a Q&A web part on a page, you can use the QandA_webpartOnAPage.ps1 script to deploy the Q&A web part on a page. The script will create a new page in the Site Pages library of the site collection of your choice, and add the required web parts to the page. The JSON files in the QandA_webpartOnAPage folder are used to configure the web part on the page.

You will have to enter the URL to where you are storing the QandA.html custom layout afterwards.

If you don't see any hits in the web part, you can try to remove the date clause in the query:

ContentType ="Questions and Answers" 
AND RefinableDate03<{today} AND RefinableDate04>{today}


