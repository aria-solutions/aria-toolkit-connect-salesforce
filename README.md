# Toolkit for Amazon Connect

This repository contains the Toolkit for Amazon Connect, an open source toolkit providing integration between [Amazon Connect](https://aws.amazon.com/connect/) and [Salesforce](https://www.salesforce.com).

# Requirements
- [Salesforce DX CLI](https://developer.salesforce.com/tools/sfdxcli)
- [Amazon Connect CTI Adapter](https://appexchange.salesforce.com/listingDetail?listingId=a0N3A00000EJH4yUAH) installed in your Salesforce org
- [AWS Quickstart](https://aws.amazon.com/quickstart/connect/aria/) by Aria Solutions

# Documentation
Detailed documentation can be found in the [Setup and User Guide](https://www.ariasolutions.com/toolkit-for-amazon-connect-setup-guide/).

# Deployment
The Toolkit for Amazon Connect is written as a Salesforce DX application, and can be deployed using the [Salesforce DX command line tool](https://developer.salesforce.com/tools/sfdxcli). See the Salesforce DX documentation for details.

## Convert the source
To deploy to a Salesforce org, the source must first be converted to metadata using sfdx.
```
sfdx force:source:convert -r force-app -d <metadata output directory>
```

## Deploy the metadata
Once the source has been converted it can be deployed to an org using sfdx.
```
sfdx force:mdapi:deploy -u <sfdx alias for your org> -d <metadata output directory>
```

# Quickstart
- Point your call center to your Amazon Connect instance
- Assign users to your call center
- Whitelist your Salesforce domain in Amazon Connect
- Set up your Amazon Connect Call Flows

Once in Salesforce, the phone will display a login button. This will open a new window where you will be able to log in with your Amazon Connect credentials. Once signed in, the Amazon Connect Contact Control Panel will appear in Salesforce.
For detailed instructions and further configuration please refer to the [Setup and User Guide](https://www.ariasolutions.com).

# Third Party Libraries
The Toolkit for Amazon Connect can be integrated with third party libraries to extend its capabilities. For example, Salesforce Einstein sentiment analysis can be performed using the following library: https://github.com/muenzpraeger/salesforce-einstein-platform-apex
