import ballerina/http;
import ballerinax/slack;

configurable string slackToken = ?;

final slack:ConnectionConfig slackConfig = {
    auth: {token: slackToken}
};

function initializeSlackClient() returns slack:Client | error {
    // Initialize Slack client
    slack:ConnectionConfig config = { auth: { token: slackToken } };
    return check new (config);
}

final slack:Client slackClient = check initializeSlackClient();

service /notification on new http:Listener(8080) {
    isolated resource function post sendNotification() returns string|error {
        slack:Message messageParams = {
            channelName: "gdki-grama-app-support",
            text: "Support is needed"
        };

        string postResponse = check slackClient->postMessage(messageParams);
        check slackClient->joinConversation("gdki-grama-app-support");
        return postResponse;
    }
}
