//Global scope may be reused between calls
const {Datastore} = require('@google-cloud/datastore');

// Creates a client
const datastore = new Datastore();

// [START functions_pubsub_subscribe]
/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {object} pubsubMessage The Cloud Pub/Sub Message object.
 * @param {string} pubsubMessage.data The "data" property of the Cloud Pub/Sub Message.
 * @param {string} pubsubMessage.attributes The "attribute" property of the Cloud Pub/Sub Message.
 */
exports.helloEvent = async pubsubMessage => {

  // The kind for the new entity
  data = JSON.parse(Buffer.from(pubsubMessage.data, 'base64'))
  attributes = pubsubMessage.attributes

  // The kind for the new entity
  const kind = `Image`;

  // The name/ID for the new entity
  const name = `${attributes.prefix}-${data.name}`;

  // The Cloud Datastore key for the new entity
  const imgageKey = datastore.key([kind, name]);

  // Prepares the new entity
  const image = {
    key: imgageKey,
    data: data
  };

  // Saves the entity
  await datastore.upsert(image);
  console.log(`Saving ${JSON.stringify(image)}`);
}
// [END functions_pubsub_subscribe]

/*
//Example message
{
  "kind": "storage#object",
  "id": "ja-serverless-labs-328806-upload-bucket/requirements.txt/1635079916677007",
  "selfLink": "https://www.googleapis.com/storage/v1/b/ja-serverless-labs-328806-upload-bucket/o/requirements.txt",
  "name": "requirements.txt",
  "bucket": "ja-serverless-labs-328806-upload-bucket",
  "generation": "1635079916677007",
  "metageneration": "1",
  "contentType": "text/plain",
  "timeCreated": "2021-10-24T12:51:56.755Z",
  "updated": "2021-10-24T12:51:56.755Z",
  "storageClass": "STANDARD",
  "timeStorageClassUpdated": "2021-10-24T12:51:56.755Z",
  "size": "57",
  "md5Hash": "hXDoTtCpY//ABGgciC396A==",
  "mediaLink": "https://www.googleapis.com/download/storage/v1/b/ja-serverless-labs-328806-upload-bucket/o/requirements.txt?generation=1635079916677007&alt=media",
  "crc32c": "VL6FPQ==",
  "etag": "CI/P86yL4/MCEAE="
}
*/