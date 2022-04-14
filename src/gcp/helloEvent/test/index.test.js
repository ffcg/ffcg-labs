/**
 * Copyright 2018, Google LLC.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const proxyquire = require('proxyquire').noCallThru();
const sinon = require('sinon');

const mockedKey = ["mockedKind", "mockedName"]

function getSample() {
  const datastoreMock = sinon.stub().returns({
    key: sinon.stub().returns(mockedKey),
    upsert: sinon.stub()
  })

  return {
    program: proxyquire('../', {
      '@google-cloud/datastore': {Datastore: datastoreMock},
    }),
    mocks: {
      datastore: datastoreMock,
    },
  };
}

it('should insert pubsub message into datastore', async () => {
  const {program, mocks} = getSample();

  const expectedData = {
    "kind": "storage#object",
    "id": "prefix-serverless-labs-328806-upload-bucket/file.txt/1635079916677007",
    "selfLink": "https://www.googleapis.com/storage/v1/b/serverless-labs-328806-upload-bucket/o/file.txt",
    "name": "file.txt",
    "bucket": "prefix-serverless-labs-328806-upload-bucket",
    "generation": "1635079916677007",
    "metageneration": "1",
    "contentType": "text/plain",
    "timeCreated": "2021-10-24T12:51:56.755Z",
    "updated": "2021-10-24T12:51:56.755Z",
    "storageClass": "STANDARD",
    "timeStorageClassUpdated": "2021-10-24T12:51:56.755Z",
    "size": "57",
    "md5Hash": "hXDoTtCpY//ABGgciC396A==",
    "mediaLink": "https://www.googleapis.com/download/storage/v1/b/prefix-serverless-labs-328806-upload-bucket/o/file.txt?generation=1635079916677007&alt=media",
    "crc32c": "VL6FPQ==",
    "etag": "CI/P86yL4/MCEAE="
  };

  const pubsubData = {
    data: Buffer.from(JSON.stringify(expectedData)).toString('base64'),
    attributes: {prefix: "prefix"},
  };

  await program.helloEvent(pubsubData, null);

  sinon.assert.calledWith(mocks.datastore().key, ["text", "prefix-file.txt"]);
  sinon.assert.calledWith(mocks.datastore().upsert, { data: expectedData, key: mockedKey});
});
