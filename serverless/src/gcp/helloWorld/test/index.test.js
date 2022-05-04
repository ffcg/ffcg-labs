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

function getSample() {
  const requestPromise = sinon
    .stub()
    .returns(new Promise(resolve => resolve('test')));
  const datastoreMock = sinon.stub().returns({
    createQuery: sinon.stub().returns({
      order: sinon.stub(),
    }),
    runQuery: sinon.stub().resolves(
      [[{
        key: {id: "mockedKeyId"},
        mockedKeyId: "mockedEntity"}]]
    ),
    KEY: "key"
  })
  const reqMock = {
    headers: {},
    query: {},
    get: function (header) {
      return this.headers[header];
    },
  };
  const corsPreflightReqMock = {
    method: 'OPTIONS',
  };
  const corsMainReqMock = {
    method: 'GET',
  };
  const resMock = {
    set: sinon.stub().returnsThis(),
    send: sinon.stub().returnsThis(),
    json: sinon.stub().returnsThis(),
    end: sinon.stub().returnsThis(),
    status: sinon.stub().returnsThis(),
    sendStatus: sinon.stub().returnsThis(),
  }

  return {
    program: proxyquire('../', {
      '@google-cloud/datastore': {Datastore: datastoreMock},
    }),
    mocks: {
      datastore: datastoreMock,
      req: reqMock,
      res: resMock,
      corsPreflightReq: corsPreflightReqMock,
      corsMainReq: corsMainReqMock,
    },
  };
}

it('should set cors headers on OPTIONS', async () => {
  const {program, mocks} = getSample();

  mocks.req.method = 'OPTIONS'

  await program.helloWorld(mocks.req, mocks.res);

  sinon.assert.calledWith(mocks.res.set, 'Access-Control-Allow-Methods', 'GET');
  sinon.assert.calledWith(mocks.res.set, 'Access-Control-Allow-Headers', 'Content-Type');
  sinon.assert.calledWith(mocks.res.set, 'Access-Control-Max-Age', '3600');
  sinon.assert.calledWith(mocks.res.sendStatus, 204);
});

it('should read kind image from datastore on GET', async () => {
  const {program, mocks} = getSample();

  await program.helloWorld(mocks.req, mocks.res);

  sinon.assert.calledWith(mocks.datastore().createQuery, "Image");
  sinon.assert.calledWith(mocks.res.status, 200);
  sinon.assert.calledWith(mocks.res.send, [{
    id: "mockedKeyId",
    image: { key: { id: "mockedKeyId" }, mockedKeyId: "mockedEntity" }
  }] );
});

