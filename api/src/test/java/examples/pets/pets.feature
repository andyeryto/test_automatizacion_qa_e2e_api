Feature: Pets

  Background:
    * url 'https://petstore.swagger.io/v2/'
    * def dateUtils = Java.type('examples.pets.DateUtils')

  Scenario: Add a pet
    * def new_pet =
    """
    {
      "id": 0,
      "category": {
        "id": 99902001,
        "name": "Canine"
      },
      "name": "Chihuahua",
      "photoUrls": [
        "https://cdn.britannica.com/70/8170-050-82AE83CD/Chihuahua-smooth-coat.jpg"
      ],
      "tags": [
        {
          "id": 99903001,
          "name": "small"
        }
      ],
      "status": "available"
    }
    """
    # * new_pet.tags[0].name = dateUtils.getNowString()

    Given path 'pet/'
    And request new_pet
    When method post
    Then status 200

    * def petId = response
    * print 'Created pet id', petId.id
    * karate.write(petId, '/tmp/pet_new.json')

    * print 'Espera de 60 segundos...'
    * def sleep = function(secs){ java.lang.Thread.sleep(secs*1000) }
    * sleep(120)
    * print 'Se reestablece la prueba después de la espera.'

  Scenario: Search the pet created recently
    * def petData = karate.read('../../../tmp/pet_new.json')
    * def petId = karate.toString(petData.id)

    Given path 'pet/', petId
    When method get
    Then status 200
    And match karate.toString(response.id) == petId
    * karate.write(response, '/tmp/pet_search.json')

  Scenario: Update the pet name and the status to "sold"
    * def petData = karate.read('../../../tmp/pet_search.json')
    * print 'Pet id', petData.id
    * print 'Old pet name', petData.name
    * print 'Old pet status', petData.status

    * petData.name = "Chihuahua Pet Newer"
    * petData.status = "sold"

    Given path 'pet/'
    And request petData
    When method put
    Then status 200

    * def petDataUpdated = response
    * karate.write(petDataUpdated, '/tmp/pet_updated.json')
    * print 'New pet name', petDataUpdated.name
    * print 'New pet status', petDataUpdated.status

    * print 'Espera de 180 segundos...'
    * def sleep = function(secs){ java.lang.Thread.sleep(secs*1000) }
    * sleep(240)
    * print 'Se reestablece la prueba después de la espera.'

  Scenario: Search by status last pet modified recently
    * def petDataUpdated = karate.read('../../../tmp/pet_updated.json')
    * def petId = karate.toString(petDataUpdated.id)

    Given path 'pet/findByStatus'
    And param status = 'sold'
    When method get
    Then status 200

    * print 'petIdFound: ', petId
    * print 'Response: ', response

    * def matchItem = response.find(x => x.id == petId)
    * print 'Matching item:', matchItem
    * karate.write(matchItem, '/tmp/pet_findByStatus.json')

    * match karate.toString(matchItem.id) == petId

