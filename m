Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533226497A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfGJPYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 11:24:48 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:59416 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJPYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 11:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1562772286; x=1594308286;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding;
  bh=hCDSJoIzn7+OnMhCesXfn7eWMoKWO22jE5AzbeUjd0k=;
  b=PPPovfFzN+BeWWTuux8Qjg5YkuEe19S/AuUAFEuZUwwzgbhxH7xDZSUl
   IQbzIOeaM7gUsVZspSYx390ByJ1vhq5uJOjD7DPSZ2ltKmoKPlY3249QR
   Fm3F3Q7A09Ib8RfyiKPhPn2uqDwUyQ5DEzpqpDp03gPxgpbuVHZhZEozB
   I=;
X-IronPort-AV: E=Sophos;i="5.62,475,1554768000"; 
   d="scan'208";a="404370013"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Jul 2019 15:24:45 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 7EB97A213B;
        Wed, 10 Jul 2019 15:24:43 +0000 (UTC)
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 15:24:42 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB003.ant.amazon.com (10.43.166.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 15:24:42 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Wed, 10 Jul 2019 15:24:42 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: Re: KVM_SET_NESTED_STATE not yet stable
Thread-Topic: KVM_SET_NESTED_STATE not yet stable
Thread-Index: AQHVNc1qO9sWQbTBkk+QlpninRmHFqbD+5MA
Date:   Wed, 10 Jul 2019 15:24:41 +0000
Message-ID: <1562772280.18613.25.camel@amazon.de>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
In-Reply-To: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.98]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3844404CBA81664096299ECA6A9A1B55@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTA4IGF0IDIyOjM5ICswMjAwLCBKYW4gS2lzemthIHdyb3RlOg0KPiBI
aSBhbGwsDQo+IA0KPiBpdCBzZWVtcyB0aGUgIm5ldyIgS1ZNX1NFVF9ORVNURURfU1RBVEUgaW50
ZXJmYWNlIGhhcyBzb21lIHJlbWFpbmluZw0KPiByb2J1c3RuZXNzIGlzc3Vlcy4NCg0KSSB3b3Vs
ZCBiZSB2ZXJ5IGludGVyZXN0ZWQgdG8gbGVhcm4gYWJvdXQgYW55IG1vcmUgcm9idXN0bmVzcyBp
c3N1ZXMgdGhhdCB5b3XCoA0KYXJlIHNlZWluZy4NCg0KPiBUaGUgbW9zdCB1cmdlbnQgb25lOiBX
aXRoIHRoZSBoZWxwIG9mIGxhdGVzdCBRRU1VDQo+IG1hc3RlciB0aGF0IHVzZXMgdGhpcyBpbnRl
cmZhY2UsIHlvdSBjYW4gZWFzaWx5IGNyYXNoIHRoZSBob3N0LiBZb3UganVzdA0KPiBuZWVkIHRv
IHN0YXJ0IHFlbXUtc3lzdGVtLXg4NiAtZW5hYmxlLWt2bSBpbiBMMSBhbmQgdGhlbiBoYXJkLXJl
c2V0IEwxLg0KPiBUaGUgaG9zdCBDUFUgdGhhdCByYW4gdGhpcyB3aWxsIHN0YWxsLCB0aGUgc3lz
dGVtIHdpbGwgZnJlZXplIHNvb24uDQoNCkp1c3QgdG8gY29uZmlybSwgeW91IHN0YXJ0IGFuIEwy
IGd1ZXN0IHVzaW5nIHFlbXUgaW5zaWRlIGFuIEwxLWd1ZXN0IGFuZCB0aGVuwqANCmhhcmQtcmVz
ZXQgdGhlIEwxIGd1ZXN0Pw0KDQpBcmUgeW91IHJ1bm5pbmcgYW55IHNwZWNpYWwgd29ya2xvYWQg
aW4gTDIgb3IgTDEgd2hlbiB5b3UgcmVzZXQ/IEFsc28gaG93wqANCmV4YWN0bHkgYXJlIHlvdSBk
b2luZyB0aGlzICJoYXJkIHJlc2V0Ij8NCg0KKHNvcnJ5IGp1c3QgdHJpZWQgdGhpcyBpbiBteSBz
ZXR1cCBhbmQgSSBkaWQgbm90IHNlZSBhbnkgcHJvYmxlbSBidXQgbXkgc2V0dXANCsKgaXMgc2xp
Z2h0bHkgZGlmZmVyZW50LCBzbyBqdXN0IHJ1bGluZyBvdXQgb2J2aW91cyBzdHVmZikuDQoNCj4g
DQo+IEkndmUgYWxzbyBzZWVuIGEgcGF0dGVybiB3aXRoIG15IEphaWxob3VzZSB0ZXN0IFZNIHdo
ZXJlIEkgc2VlbXMgdG8gZ2V0DQo+IHN0dWNrIGluIGEgbG9vcCBiZXR3ZWVuIEwxIGFuZCBMMjoN
Cj4gDQo+ICBxZW11LXN5c3RlbS14ODYtNjY2MCAgWzAwN10gICAzOTguNjkxNDAxOiBrdm1fbmVz
dGVkX3ZtZXhpdDogICAgcmlwIDdmYTllZTUyMjRlNCByZWFzb24gSU9fSU5TVFJVQ1RJT04gaW5m
bzEgNTY1ODAwMGIgaW5mbzIgMCBpbnRfaW5mbyAwIGludF9pbmZvX2VyciAwDQo+ICBxZW11LXN5
c3RlbS14ODYtNjY2MCAgWzAwN10gICAzOTguNjkxNDAyOiBrdm1fZnB1OiAgICAgICAgICAgICAg
dW5sb2FkDQo+ICBxZW11LXN5c3RlbS14ODYtNjY2MCAgWzAwN10gICAzOTguNjkxNDAzOiBrdm1f
dXNlcnNwYWNlX2V4aXQ6ICAgcmVhc29uIEtWTV9FWElUX0lPICgyKQ0KPiAgcWVtdS1zeXN0ZW0t
eDg2LTY2NjAgIFswMDddICAgMzk4LjY5MTQ0MDoga3ZtX2ZwdTogICAgICAgICAgICAgIGxvYWQN
Cj4gIHFlbXUtc3lzdGVtLXg4Ni02NjYwICBbMDA3XSAgIDM5OC42OTE0NDE6IGt2bV9waW86ICAg
ICAgICAgICAgICBwaW9fcmVhZCBhdCAweDU2NTggc2l6ZSA0IGNvdW50IDEgdmFsIDB4NCANCj4g
IHFlbXUtc3lzdGVtLXg4Ni02NjYwICBbMDA3XSAgIDM5OC42OTE0NDM6IGt2bV9tbXVfZ2V0X3Bh
Z2U6ICAgICBleGlzdGluZyBzcCBnZm4gM2EyMmUgMS80IHEzIGRpcmVjdCAtLXggIXBnZSAhbnhl
IHJvb3QgNiBzeW5jDQo+ICBxZW11LXN5c3RlbS14ODYtNjY2MCAgWzAwN10gICAzOTguNjkxNDQ0
OiBrdm1fZW50cnk6ICAgICAgICAgICAgdmNwdSAzDQo+ICBxZW11LXN5c3RlbS14ODYtNjY2MCAg
WzAwN10gICAzOTguNjkxNDc1OiBrdm1fZXhpdDogICAgICAgICAgICAgcmVhc29uIElPX0lOU1RS
VUNUSU9OIHJpcCAweDdmYTllZTUyMjRlNCBpbmZvIDU2NTgwMDBiIDANCj4gIHFlbXUtc3lzdGVt
LXg4Ni02NjYwICBbMDA3XSAgIDM5OC42OTE0NzY6IGt2bV9uZXN0ZWRfdm1leGl0OiAgICByaXAg
N2ZhOWVlNTIyNGU0IHJlYXNvbiBJT19JTlNUUlVDVElPTiBpbmZvMSA1NjU4MDAwYiBpbmZvMiAw
IGludF9pbmZvIDAgaW50X2luZm9fZXJyIDANCj4gIHFlbXUtc3lzdGVtLXg4Ni02NjYwICBbMDA3
XSAgIDM5OC42OTE0Nzc6IGt2bV9mcHU6ICAgICAgICAgICAgICB1bmxvYWQNCj4gIHFlbXUtc3lz
dGVtLXg4Ni02NjYwICBbMDA3XSAgIDM5OC42OTE0Nzg6IGt2bV91c2Vyc3BhY2VfZXhpdDogICBy
ZWFzb24gS1ZNX0VYSVRfSU8gKDIpDQo+ICBxZW11LXN5c3RlbS14ODYtNjY2MCAgWzAwN10gICAz
OTguNjkxNTI2OiBrdm1fZnB1OiAgICAgICAgICAgICAgbG9hZA0KPiAgcWVtdS1zeXN0ZW0teDg2
LTY2NjAgIFswMDddICAgMzk4LjY5MTUyNzoga3ZtX3BpbzogICAgICAgICAgICAgIHBpb19yZWFk
IGF0IDB4NTY1OCBzaXplIDQgY291bnQgMSB2YWwgMHg0IA0KPiAgcWVtdS1zeXN0ZW0teDg2LTY2
NjAgIFswMDddICAgMzk4LjY5MTUyOToga3ZtX21tdV9nZXRfcGFnZTogICAgIGV4aXN0aW5nIHNw
IGdmbiAzYTIyZSAxLzQgcTMgZGlyZWN0IC0teCAhcGdlICFueGUgcm9vdCA2IHN5bmMNCj4gIHFl
bXUtc3lzdGVtLXg4Ni02NjYwICBbMDA3XSAgIDM5OC42OTE1MzA6IGt2bV9lbnRyeTogICAgICAg
ICAgICB2Y3B1IDMNCj4gIHFlbXUtc3lzdGVtLXg4Ni02NjYwICBbMDA3XSAgIDM5OC42OTE1MzM6
IGt2bV9leGl0OiAgICAgICAgICAgICByZWFzb24gSU9fSU5TVFJVQ1RJT04gcmlwIDB4N2ZhOWVl
NTIyNGU0IGluZm8gNTY1ODAwMGIgMA0KPiAgcWVtdS1zeXN0ZW0teDg2LTY2NjAgIFswMDddICAg
Mzk4LjY5MTUzNDoga3ZtX25lc3RlZF92bWV4aXQ6ICAgIHJpcCA3ZmE5ZWU1MjI0ZTQgcmVhc29u
IElPX0lOU1RSVUNUSU9OIGluZm8xIDU2NTgwMDBiIGluZm8yIDAgaW50X2luZm8gMCBpbnRfaW5m
b19lcnIgMA0KPiANCj4gVGhlc2UgaXNzdWVzIGRpc2FwcGVhciB3aGVuIGdvaW5nIGZyb20gZWJi
ZmVmMmYgYmFjayB0byA2Y2ZkNzYzOSAoYm90aA0KPiB3aXRoIGJ1aWxkIGZpeGVzKSBpbiBRRU1V
Lg0KDQpUaGlzIGlzIHRoZSBRRU1VIHRoYXQgeW91IGFyZSB1c2luZyBpbiBMMCB0byBsYXVuY2gg
YW4gTDEgZ3Vlc3QsIHJpZ2h0PyBvciBhcmXCoA0KeW91IHN0aWxsIHJlZmVycmluZyB0byB0aGUg
UUVNVSBtZW50aW9uZWQgYWJvdmU/DQoNCj4gSG9zdCBrZXJuZWxzIHRlc3RlZDogNS4xLjE2IChk
aXN0cm8pIGFuZCA1LjIgKHZhbmlsbGEpLg0KPiBKYW4NCj4gDQoKCgpBbWF6b24gRGV2ZWxvcG1l
bnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hh
ZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBSYWxmIEhlcmJyaWNoCkVpbmdldHJh
Z2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6
OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

