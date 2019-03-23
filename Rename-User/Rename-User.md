---
external help file: Rename-User-help.xml
Module Name: Rename-User
online version:
schema: 2.0.0
---

# Rename-User

## SYNOPSIS
This cmdlet will change the name of a user in AD.

## SYNTAX

```
Rename-User [-OldFirstName] <String> [-OldLastName] <String> [-NewFirstName] <String> [-NewLastName] <String>
 [-EmployeeID] <String> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will change the username and email of an individual in AD.
The function find the user using a unique ID number, then check to see if the correct username was entered as an argument.
If both events return true then the name change is carried out.

## EXAMPLES

### EXAMPLE 1
This will find the user John Smith with the ID of 123456 and change the name to John Doe
```
Rename-User -OldFirstName John -OldLastName Smith -NewFirstName John -NewLastName Doe -EmployeeID 123456
```

## PARAMETERS

### -OldFirstName
This is the old first name of the user being acted upon.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OldLastName
This is the old last name of the user being acted upon.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewFirstName
This is the new first name of the user being acted upon.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewLastName
This is the new last name of the user being acted upon.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmployeeID
Enter Id number: xxxxxx

```yaml
Type: String
Parameter Sets: (All)
Aliases: StudentID, Id

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
