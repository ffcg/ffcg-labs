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
  const bigQueryMock = sinon.stub().returns({
    dataset: sinon.stub().returns({
      table: sinon.stub().returns({
        load: sinon.stub().resolves([{
          id: "mockedJobId"
        }])
      })
    }),
  })
  const storageMock = sinon.stub().returns({
    bucket: sinon.stub().returns({
      file: sinon.stub().returns("mocked bucket file")
    })
  })

  return {
    program: proxyquire('../', {
      '@google-cloud/bigquery': {BigQuery: bigQueryMock},
      '@google-cloud/storage': {Storage: storageMock},
    }),
    mocks: {
      bigquery: bigQueryMock,
      storage: storageMock,
    },
  };
}

it('should insert csv file contents into bigquery', async () => {
  const {program, mocks} = getSample();

  const expectedData = {
    "kind": "storage#object",
    "id": "prefix-serverless-labs-328806-upload-bucket/requirements.csv/1635079916677007",
    "selfLink": "https://www.googleapis.com/storage/v1/b/prefix-serverless-labs-328806-upload-bucket/o/requirements.csv",
    "name": "requirements.csv",
    "bucket": "prefix-serverless-labs-328806-upload-bucket",
    "generation": "1635079916677007",
    "metageneration": "1",
    "contentType": "text/csv",
    "timeCreated": "2021-10-24T12:51:56.755Z",
    "updated": "2021-10-24T12:51:56.755Z",
    "storageClass": "STANDARD",
    "timeStorageClassUpdated": "2021-10-24T12:51:56.755Z",
    "size": "57",
    "md5Hash": "hXDoTtCpY//ABGgciC396A==",
    "mediaLink": "https://www.googleapis.com/download/storage/v1/b/prefix-serverless-labs-328806-upload-bucket/o/requirements.csv?generation=1635079916677007&alt=media",
    "crc32c": "VL6FPQ==",
    "etag": "CI/P86yL4/MCEAE="
  };

  const pubsubData = {
    data: Buffer.from(JSON.stringify(expectedData)).toString('base64'),
    attributes: {prefix: "prefix"},
  };

const expectedMetadata = {
  autodetect: true,
  location: "EU",
  skipLeadingRows: 1,
  sourceFormat: "CSV",
  writeDisposition: "WRITE_TRUNCATE"
}

  process.env.DATASET_ID

  with (process.env.DATASET_ID = "mocked dataset from  DATASET_ID")
  await program.helloIngest(pubsubData, null);

  sinon.assert.calledWith(mocks.storage().bucket, "prefix-serverless-labs-328806-upload-bucket");
  sinon.assert.calledWith(mocks.storage().bucket().file, "requirements.csv");
  sinon.assert.calledWith(mocks.bigquery().dataset, "mocked dataset from  DATASET_ID");
  sinon.assert.calledWith(mocks.bigquery().dataset().table, "requirements_csv");
  sinon.assert.calledWith(mocks.bigquery().dataset().table().load, "mocked bucket file", expectedMetadata);
});
