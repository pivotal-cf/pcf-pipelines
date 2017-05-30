#!/bin/bash

# Copyright 2017-Present Pivotal Software, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eu

root=$PWD

product_file="$(ls -1 ${root}/pivnet-product/*.pivotal)"

mkdir -p "${root}/stemcell"

if [[ -n ${OPSMAN_CLIENT_ID} ]]; then
  CREDS="--client-id '${OPSMAN_CLIENT_ID}' --client-secret '${OPSMAN_CLIENT_SECRET}'"
else
  CREDS="--username '${OPSMAN_USERNAME}' --password '${OPSMAN_PASSWORD}'"
fi

stemcell-downloader \
  --iaas-type "${IAAS_TYPE}" \
  --product-file "${product_file}" \
  --product-name "${PRODUCT}" \
  --download-dir "${root}/stemcell"

stemcell="$(ls -1 "${root}"/stemcell/*.tgz)"

om-linux --target "https://${OPSMAN_URI}" \
  --skip-ssl-validation \
  ${CREDS} \
  upload-stemcell \
  --stemcell "${stemcell}"
