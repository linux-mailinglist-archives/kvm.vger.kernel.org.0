Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F41F4846A9
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiADRHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:07:04 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:5065 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiADRGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641316016; x=1672852016;
  h=from:to:subject:date:message-id:mime-version;
  bh=JLgasmB4JEll+piGyIAP2saA+DSCXtiAMUwg3bCgMoE=;
  b=Ekt4vrA2CT/fmHWg1H2DiPVZtvWB8/HWArWzcgIpzZwhL2Dw8VPtiZ+F
   cwfNqPXkc1kIn1GnA5ia5yAc41x2ZzATgh8IuFnJdN7Xksb4d976l1xlG
   c1iLbZFZm1SkB4GdsLW6MiDVti58RSnZDWFKbKZh4Jl0bmRfwycaeuxr7
   4=;
X-Amazon-filename: 0001-x86-hyperv-improve-naming-of-stimer-functions.patch
X-IronPort-AV: E=Sophos;i="5.88,261,1635206400"; 
   d="scan'208,223";a="166254886"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 04 Jan 2022 17:06:44 +0000
Received: from EX13D43EUB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com (Postfix) with ESMTPS id D47E6C08D0
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 17:06:42 +0000 (UTC)
Received: from EX13D43EUB002.ant.amazon.com (10.43.166.8) by
 EX13D43EUB002.ant.amazon.com (10.43.166.8) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 17:06:42 +0000
Received: from EX13D43EUB002.ant.amazon.com ([10.43.166.8]) by
 EX13D43EUB002.ant.amazon.com ([10.43.166.8]) with mapi id 15.00.1497.026;
 Tue, 4 Jan 2022 17:06:42 +0000
From:   "Kaya, Metin" <metikaya@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 1/1] x86/hyperv: improve naming of stimer
 functions
Thread-Topic: [kvm-unit-tests PATCH 1/1] x86/hyperv: improve naming of stimer
 functions
Thread-Index: AQHYAY1fgFOstRVXaEyKySnKCZPCNQ==
Date:   Tue, 4 Jan 2022 17:06:41 +0000
Message-ID: <1641316001743.98051@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.203]
Content-Type: multipart/mixed; boundary="_002_164131600174398051amazoncom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_164131600174398051amazoncom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

- synic_supported() is renamed to hv_synic_supported().=0A=
- stimer_supported() is renamed to hv_stimer_supported().=

--_002_164131600174398051amazoncom_
Content-Type: text/x-patch;
	name="0001-x86-hyperv-improve-naming-of-stimer-functions.patch"
Content-Description: 0001-x86-hyperv-improve-naming-of-stimer-functions.patch
Content-Disposition: attachment;
	filename="0001-x86-hyperv-improve-naming-of-stimer-functions.patch";
	size=2387; creation-date="Tue, 04 Jan 2022 17:05:30 GMT";
	modification-date="Tue, 04 Jan 2022 17:05:30 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5ZDVmZjI2M2YyNTQ0NGQyMDc5NzQxMzVkYWE2MDg0MzAwYmNmMjg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgpEYXRl
OiBUdWUsIDQgSmFuIDIwMjIgMTc6MDI6MDQgKzAwMDAKU3ViamVjdDogW2t2bS11bml0LXRlc3Rz
IFBBVENIIDMvM10geDg2L2h5cGVydjogaW1wcm92ZSBuYW1pbmcgb2Ygc3RpbWVyCiBmdW5jdGlv
bnMKCi0gc3luaWNfc3VwcG9ydGVkKCkgaXMgcmVuYW1lZCB0byBodl9zeW5pY19zdXBwb3J0ZWQo
KS4KLSBzdGltZXJfc3VwcG9ydGVkKCkgaXMgcmVuYW1lZCB0byBodl9zdGltZXJfc3VwcG9ydGVk
KCkuCgpTaWduZWQtb2ZmLWJ5OiBNZXRpbiBLYXlhIDxtZXRpa2F5YUBhbWF6b24uY29tPgotLS0K
IHg4Ni9oeXBlcnYuaCAgICAgICAgICAgICB8IDQgKystLQogeDg2L2h5cGVydl9jb25uZWN0aW9u
cy5jIHwgMiArLQogeDg2L2h5cGVydl9zdGltZXIuYyAgICAgIHwgNCArKy0tCiB4ODYvaHlwZXJ2
X3N5bmljLmMgICAgICAgfCAyICstCiA0IGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwg
NiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS94ODYvaHlwZXJ2LmggYi94ODYvaHlwZXJ2LmgK
aW5kZXggYmMxNjVjMy4uM2UxNzIzZSAxMDA2NDQKLS0tIGEveDg2L2h5cGVydi5oCisrKyBiL3g4
Ni9oeXBlcnYuaApAQCAtMTgzLDEyICsxODMsMTIgQEAgc3RydWN0IGh2X2lucHV0X3Bvc3RfbWVz
c2FnZSB7CiAJdTY0IHBheWxvYWRbSFZfTUVTU0FHRV9QQVlMT0FEX1FXT1JEX0NPVU5UXTsKIH07
CiAKLXN0YXRpYyBpbmxpbmUgYm9vbCBzeW5pY19zdXBwb3J0ZWQodm9pZCkKK3N0YXRpYyBpbmxp
bmUgYm9vbCBodl9zeW5pY19zdXBwb3J0ZWQodm9pZCkKIHsKICAgIHJldHVybiBjcHVpZChIWVBF
UlZfQ1BVSURfRkVBVFVSRVMpLmEgJiBIVl9YNjRfTVNSX1NZTklDX0FWQUlMQUJMRTsKIH0KIAot
c3RhdGljIGlubGluZSBib29sIHN0aW1lcl9zdXBwb3J0ZWQodm9pZCkKK3N0YXRpYyBpbmxpbmUg
Ym9vbCBodl9zdGltZXJfc3VwcG9ydGVkKHZvaWQpCiB7CiAgICAgcmV0dXJuIGNwdWlkKEhZUEVS
Vl9DUFVJRF9GRUFUVVJFUykuYSAmIEhWX1g2NF9NU1JfU1lOVElNRVJfQVZBSUxBQkxFOwogfQpk
aWZmIC0tZ2l0IGEveDg2L2h5cGVydl9jb25uZWN0aW9ucy5jIGIveDg2L2h5cGVydl9jb25uZWN0
aW9ucy5jCmluZGV4IDZlOGFjMzIuLjA0OWZkNzggMTAwNjQ0Ci0tLSBhL3g4Ni9oeXBlcnZfY29u
bmVjdGlvbnMuYworKysgYi94ODYvaHlwZXJ2X2Nvbm5lY3Rpb25zLmMKQEAgLTI2Niw3ICsyNjYs
NyBAQCBpbnQgbWFpbihpbnQgYWMsIGNoYXIgKiphdikKIHsKIAlpbnQgbmNwdXMsIG5jcHVzX29r
LCBpOwogCi0JaWYgKCFzeW5pY19zdXBwb3J0ZWQoKSkgeworCWlmICghaHZfc3luaWNfc3VwcG9y
dGVkKCkpIHsKIAkJcmVwb3J0X3NraXAoIkh5cGVyLVYgU3luSUMgaXMgbm90IHN1cHBvcnRlZCIp
OwogCQlnb3RvIHN1bW1hcnk7CiAJfQpkaWZmIC0tZ2l0IGEveDg2L2h5cGVydl9zdGltZXIuYyBi
L3g4Ni9oeXBlcnZfc3RpbWVyLmMKaW5kZXggN2I3Yzk4NS4uYmFhMzEzZiAxMDA2NDQKLS0tIGEv
eDg2L2h5cGVydl9zdGltZXIuYworKysgYi94ODYvaHlwZXJ2X3N0aW1lci5jCkBAIC0zNTIsMTIg
KzM1MiwxMiBAQCBzdGF0aWMgdm9pZCBzdGltZXJfdGVzdF9hbGwodm9pZCkKIGludCBtYWluKGlu
dCBhYywgY2hhciAqKmF2KQogewogCi0gICAgaWYgKCFzeW5pY19zdXBwb3J0ZWQoKSkgeworICAg
IGlmICghaHZfc3luaWNfc3VwcG9ydGVkKCkpIHsKICAgICAgICAgcmVwb3J0X3Bhc3MoIkh5cGVy
LVYgU3luSUMgaXMgbm90IHN1cHBvcnRlZCIpOwogICAgICAgICBnb3RvIGRvbmU7CiAgICAgfQog
Ci0gICAgaWYgKCFzdGltZXJfc3VwcG9ydGVkKCkpIHsKKyAgICBpZiAoIWh2X3N0aW1lcl9zdXBw
b3J0ZWQoKSkgewogICAgICAgICByZXBvcnRfcGFzcygiSHlwZXItViBTeW5JQyB0aW1lcnMgYXJl
IG5vdCBzdXBwb3J0ZWQiKTsKICAgICAgICAgZ290byBkb25lOwogICAgIH0KZGlmZiAtLWdpdCBh
L3g4Ni9oeXBlcnZfc3luaWMuYyBiL3g4Ni9oeXBlcnZfc3luaWMuYwppbmRleCA1Y2E1OTNjLi5k
YzE3OTc4IDEwMDY0NAotLS0gYS94ODYvaHlwZXJ2X3N5bmljLmMKKysrIGIveDg2L2h5cGVydl9z
eW5pYy5jCkBAIC0xNDIsNyArMTQyLDcgQEAgc3RhdGljIHZvaWQgc3luaWNfdGVzdF9jbGVhbnVw
KHZvaWQgKmN0eCkKIGludCBtYWluKGludCBhYywgY2hhciAqKmF2KQogewogCi0gICAgaWYgKHN5
bmljX3N1cHBvcnRlZCgpKSB7CisgICAgaWYgKGh2X3N5bmljX3N1cHBvcnRlZCgpKSB7CiAgICAg
ICAgIGludCBuY3B1cywgaTsKICAgICAgICAgYm9vbCBvazsKIAotLSAKMi4zMi4wCgo=

--_002_164131600174398051amazoncom_--
