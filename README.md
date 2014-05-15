#Dynamic Form

##Overview
Create a simple form with textfields base on the number provided. The core of the form is structured with **UITableView**. The fields that populate are custom rows with a **UITextField**. The count field and the memo field are in the table views **header view** and **footer view**

##How To Implement
1. In your view added a **UITableView** and add two **UIView** to the table view. These will be the tablviews footer and header.
2. Place a **UITextField** into both the header and footer view.
3. Connect the textfields with IBOutlets and name them accodingly.
4. Now added a IBAction binding to the counts textfield's **Editing Did End**.
5. Set both textfield's delegate to the view controller.
6. Add the following protocols to the view controller: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  
7. From here you can add a custom UITablViewCell and have it bind to the view controller.
8. Add observation for keyboard showing and hiding.
9. Then you can copy and paste anything paste the first pragma. Depending on what is needed you will not have to copy all of it. 
