#  Place Feed Feature

## BDD Specs

### Story: Customer requests to see the feed

### Narrative #1

        As an online customer
        I want the app to automatically load the place feed around my location
        So I can always enjoy the places around my location

### Scenarios (Acceptance criteria)

        Given the customer has connectivity and location is authorized
        When the customer requests to see the feed
        Then the app should display the latest feed from remote
            And replace the cache with the new feed
            
        Given the customer has connectivity and location is not authorize
        When the customer requests to see the feed
        Then the app should display an error message

### Narrative #2
    
        As an offline customer
        I want the app to show the latest saved version of my place feed
        So I can always enjoy places
        
### Scenarios (Acceptance criteria)

        Given the customer doesn't have connectivity
        When the customer requests to see the feed
        Then the app should display the latest feed saved
        
        Given the customer doesn't have connectivity
        And the cache is empty
        When the customer requests to see the feed
        Then the app should display an error message
