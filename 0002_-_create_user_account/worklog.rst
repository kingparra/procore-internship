* 13:59 PM EST - Moved ticket to in-progress. 
* 14:02 PM EST - Created a branch. Wrote terraform provider and iam_user code.
* 14:08 PM EST - Looked up how to create a iam group. Looked up how to retrive PowerUser managed policy arn. Looked up how to attach policy to group. Looked up how to allow console access to user.
* 14:18 PM EST - Coding.
* 14:24 PM EST - Wondering how I should send the password to Ricky -- If I had his PGP pubkey I could get the password output securely from terraform and send it directly on slack. For now I'll keep it in my password manager. Note that there is a password in the state file. Thankfully the backend is encrypted.
* fixed a typo

* 14:37 PM EST - Set up local env vars. Triggered a plan, looks good.
* 15:00 PM EST - Applied. Also moved state to s3 bucket.
