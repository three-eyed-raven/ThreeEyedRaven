## Character

Property Name | Type | Description
--------------|------|------------
name | `String` | Name of character
gender | `String` | Gender of character
culture | `String` | Culture of character
birthDate | `String` | Birth date of character
deathDate | `String` | Death date of character
allegiances | `[House]` | Array of houses character is loyal to
titles | `[String]` | Lists of character titles
aliases | `[String]` | List of character aliases and akas
mother | `Character` | Character's mother
father | `Character` | Character's father
spouse | `Character` | Character's spouse
playedBy | `String` | Actor's name 

## House

Property Name | Type | Description
--------------|------|------------
name | `String` | Name of house
region | `String` | Region that this house resides in
coatOfArms | `String` | a house's coat of arms text 
words | `String` | The words or saying of a given house
currentLord | `Character` | Current lord of a given house
heir | `Character` | The house's heir
swornMembers | `[Character]` | List of characters sworn to a given house
