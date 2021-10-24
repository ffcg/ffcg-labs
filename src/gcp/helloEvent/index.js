// [START functions_pubsub_subscribe]
/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {object} pubsubMessage The Cloud Pub/Sub Message object.
 * @param {string} pubsubMessage.data The "data" property of the Cloud Pub/Sub Message.
 */
 exports.helloEvent = pubsubMessage => {
  // Print out the data from Pub/Sub, to prove that it worked
  console.log(Buffer.from(pubsubMessage.data, 'base64').toString());
};
// [END functions_pubsub_subscribe]