#more changes

# another comment
#test comment
$properties = @{
    to         = 'xxxxxxxxxx@vtext.com'
    from       = 'testaddress@sending.com'
    body       = "test"
    subject    = "test"
    smtpserver = 'someserver'
    }

Send-MailMessage @properties 

#one more test comment
# another comment