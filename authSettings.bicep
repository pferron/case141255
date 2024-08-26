param consumerGroupObjectId string
param apiClientObjectId string
param webAppName string 
var tenantId ='141f0f15-43fe-42df-b979-02251d5bc73c'


resource app 'Microsoft.Web/sites@2022-09-01' existing ={      
  name: webAppName  
}
resource stagingApp 'Microsoft.Web/sites/slots@2022-09-01' existing ={  
  name: '${webAppName}/staging-0'
}

resource appAuthSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'authsettingsV2'
  parent: app
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'Return401'
    }  
    identityProviders: {
      azureActiveDirectory: {
        enabled: true  
        login: {
          disableWWWAuthenticate: false
        }
        registration: {
          clientId: apiClientObjectId
          openIdIssuer: '${az.environment().authentication.loginEndpoint}${tenantId}'
        }
        validation: {
          defaultAuthorizationPolicy: {
            allowedPrincipals: {
              groups: [
                consumerGroupObjectId
              ]
            }
          }
        }
      }
    }
    login: {
       tokenStore: {
        enabled: true
        tokenRefreshExtensionHours: 72
      }
    }
    platform: {
      enabled: true
      runtimeVersion: '1.0.0'
    }
  }
}

resource stagingAppAuthSettings 'Microsoft.Web/sites/slots/config@2022-03-01' = {
  name: 'authsettingsV2'
  parent: stagingApp
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'Return401'
    }  
    identityProviders: {
      azureActiveDirectory: {
        enabled: true  
        login: {
          disableWWWAuthenticate: false          
        }
        registration: {
          clientId: apiClientObjectId      
          openIdIssuer: '${az.environment().authentication.loginEndpoint}${tenantId}'
        }
        validation: {
          defaultAuthorizationPolicy: {
            allowedPrincipals: {
              groups: [
                consumerGroupObjectId
              ]
            }
          }
        }
      }
    }
    login: {
       tokenStore: {
        enabled: true       
        tokenRefreshExtensionHours: 72
      }
    }
    platform: {    
      enabled: true
      runtimeVersion: '1.0.0'
    }
  }
}
