# creditcard_fraud_analysis
Fraud Analysis of Credit Card transactions

Assignment for Looking for Suspicious Transactions

Data Modelling, Data Engineering, Data Analysis for suspicious fraud transactions

#
#


## <b>Data Analysis Report</b>

#

<b>Question:</b> How can you isolate (or group) the transactions of each cardholder?

<b>Answer:</b> Query of the view "cardholder_transaction" will provide the list of transactions grouped for each of the cardholder.

#

<b>Question:</b> Count the transactions that are less than $2.00 per cardholder.

<b>Answer:</b> Query of the view "transaction_lessthan$2" will provide the count of  transactions that are less than $2.00 per cardholder.

#

<b>Question:</b> Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.

<b>Answer:</b> Yes there are quite a good evidence to say that a credit card for a card holder has been hacked. The card holders who have too many transactions of less than $2.00 on their credit card, are potentially been hacked. For e.g. following credit cards for various card holders might be potentially hacked.
* Megan Price's Credit Card 376027549341849 have 13 less than $2.00 transaction
* Danielle Green's Credit Card 584226564303 have 12 less than $2.00 transaction
* Brandon Pineda's Credit Card 180098539019105 have 11 less than $2.00 transaction
* Malik Carlson's Credit Card 344119623920892 have 11 less than $2.00 transaction
* Peter Mckay's Credit Card 4743204091443101526 have 10 less than $2.00 transaction
* Sean Taylor's Credit Card 3516952396080247 have 10 less than $2.00 transaction

#

<b>Question:</b> What are the top 100 highest transactions made between 7:00 am and 9:00 am?

<b>Answer:</b> Query of the view "transaction_bw7and9" with limit of top 100 will provide the list of top 100 highest transactions made between 7:00 am and 9:00 am.

#
<b>Question:</b> Do you see any anomalous transactions that could be fraudulent?

<b>Answer:</b> Yes there are anomalous transactions in some credit cards. If there are many small transacations in a credit card then they are could be fraudulent.

#

<b>Question:</b>Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?

<b>Answer:</b> Here assuming that transaction less than $2.00 could be fraudulent. Total number of such possible fraudulent transactions between 7 am to 9 am are 30. Total number of such possible fraudulent transactions for the rest of day are 320. This is almost 8.6% of such possible farudulent transacations happened during this 2 hrs of time frame between 7 am and 9 am. Hence, concluding that yes there are a higher number of fraudulent transactions could have been made during this time frame versus the rest of the day.

#

<b>Question:</b> If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.

<b>Answer:</b> Fraudulent transactions happen through out the day. But early morning card holders generally do not shop at any merchants of small amount less than $2.00.  Hence, small transacations made during this time frame of 7 am and 9 am might get unnoticed by the card holder.

#

<b>Question:</b> What are the top 5 merchants prone to being hacked using small transactions?

<b>Answer:</b> Assuming that small transactions are the ones which are less than  $2.00 , following merchants are the top 5 merchants prone to being hacked using small transacations:- Dan-Murray, Henderson and Sons, Hess and Finley Scott, Pugh-Williams, Lewis and Rangel Bond. 













