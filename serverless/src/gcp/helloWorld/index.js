//Global scope may be reused between calls
const {Datastore} = require('@google-cloud/datastore');

// Creates a client
const datastore = new Datastore();

exports.helloWorld = async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');

  if (req.method === 'OPTIONS') {
    // Send response to OPTIONS requests
    res.set('Access-Control-Allow-Methods', 'GET');
    res.set('Access-Control-Allow-Headers', 'Content-Type');
    res.set('Access-Control-Max-Age', '3600');
    res.sendStatus(204);
  } else {

    const query = datastore
      .createQuery("Image")
      .order('timeCreated', { //order also filters
        descending: true,
      })

    const [images] = await datastore.runQuery(query);
    let message = []
    for (const image of images) {
      const imageKey = image[datastore.KEY];
      message.push({
        id: imageKey.id,
        image: image
      })
    }
    console.log("message:", message)
    res.status(200).send(message);
  }
}
//exports.helloWorld()