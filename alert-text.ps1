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


# another comment