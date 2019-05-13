Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF50C1B54A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 13:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfEMLwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 07:52:23 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:28648 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbfEMLwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 07:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557748342; x=1589284342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=krMY5yk9clFrHqBJCTbRVKmzcK3LgVccUTn1WUKNphY=;
  b=HsAlv0YYZDmjDjA1wNA40AOjEg90Y1M14ipW3Hu926w6cwjoCmNhSWlS
   woTYsOBn2JL+LXqW4ZOlZ0XqCLlxcssCjjFYsZs8iDtMybM6v917YevAv
   FNxRKoxLOfbcBMGuQTQxteu/4jPi7n8WXP5B5IRWuVSTH4cUaB5GrvGrj
   A=;
X-IronPort-AV: E=Sophos;i="5.60,465,1549929600"; 
   d="scan'208";a="804338810"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 13 May 2019 11:51:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4DBpsat089659
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 13 May 2019 11:51:54 GMT
Received: from EX13D01EUB002.ant.amazon.com (10.43.166.113) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 13 May 2019 11:51:53 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB002.ant.amazon.com (10.43.166.113) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 13 May 2019 11:51:52 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Mon, 13 May 2019 11:51:52 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bsd@redhat.com" <bsd@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Thread-Topic: [PATCH] sched: introduce configurable delay before entering idle
Thread-Index: AQHVCX+kOqbh6EAmWky59yk7eoKiJqZo8YIA
Date:   Mon, 13 May 2019 11:51:52 +0000
Message-ID: <1557748312.17635.17.camel@amazon.de>
References: <20190507185647.GA29409@amt.cnet>
         <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
         <D655C66D-8C52-4CE3-A00B-697735CFA51D@oracle.com>
In-Reply-To: <D655C66D-8C52-4CE3-A00B-697735CFA51D@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.97]
Content-Type: text/plain; charset="utf-8"
Content-ID: <82961A04BB19914388C2C735412F180B@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTEzIGF0IDA3OjMxIC0wNDAwLCBLb25yYWQgUnplc3p1dGVrIFdpbGsg
d3JvdGU6DQo+IE9uIE1heSAxMywgMjAxOSA1OjIwOjM3IEFNIEVEVCwgV2FucGVuZyBMaSA8a2Vy
bmVsbHdwQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gV2VkLCA4IE1heSAyMDE5IGF0
IDAyOjU3LCBNYXJjZWxvIFRvc2F0dGkgPG10b3NhdHRpQHJlZGhhdC5jb20+DQo+ID4gd3JvdGU6
DQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBDZXJ0YWluIHdvcmtsb2FkcyBwZXJmb3Jt
IHBvb3JseSBvbiBLVk0gY29tcGFyZWQgdG8gYmFyZW1ldGFsDQo+ID4gPiBkdWUgdG8gYmFyZW1l
dGFsJ3MgYWJpbGl0eSB0byBwZXJmb3JtIG13YWl0IG9uIE5FRURfUkVTQ0hFRA0KPiA+ID4gYml0
IG9mIHRhc2sgZmxhZ3MgKHRoZXJlZm9yZSBza2lwcGluZyB0aGUgSVBJKS4NCj4gPiANCj4gPiBL
Vk0gc3VwcG9ydHMgZXhwb3NlIG13YWl0IHRvIHRoZSBndWVzdCwgaWYgaXQgY2FuIHNvbHZlIHRo
aXM/DQo+ID4gDQo+IA0KPiANCj4gVGhlcmUgaXMgYSBiaXQgb2YgcHJvYmxlbSB3aXRoIHRoYXQu
IFRoZSBob3N0IHdpbGwgc2VlIDEwMCUgQ1BVIHV0aWxpemF0aW9uIGV2ZW4gaWYgdGhlIGd1ZXN0
IGlzIGlkbGUgYW5kIHRha2luZyBsb25nIG5hcHMuLg0KPiANCj4gV2hpY2ggZGVwZW5kaW5nIG9u
IHlvdXIgZGFzaGJvYXJkIGNhbiBsb29rIGxpa2UgdGhlIG1hY2hpbmUgaXMgb24gZmlyZS4NCg0K
VGhpcyBjYW4gYWxzbyBiZSBmaXhlZC4gSSBoYXZlIGEgcGF0Y2ggdGhhdCBraW5kIG9mIGV4cG9z
ZSBwcm9wZXIgaW5mb3JtYXRpb27CoA0KYWJvdXQgdGhlICpyZWFsKiB1dGlsaXphdGlvbiBoZXJl
IGlmIHRoYXQgd291bGQgYmUgaGVscC4NCg0KPiANCj4gQ0NpbmcgQW5rdXIgYW5kIEJvcmlzDQo+
IA0KPiA+IA0KPiA+IFJlZ2FyZHMsDQo+ID4gV2FucGVuZyBMaQ0KPiA+IA0KPiA+ID4gDQo+ID4g
PiANCj4gPiA+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIGNvbmZpZ3VyYWJsZSBidXN5LXdhaXQg
ZGVsYXkgYmVmb3JlIGVudGVyaW5nDQo+ID4gdGhlDQo+ID4gPiANCj4gPiA+IGFyY2hpdGVjdHVy
ZSBkZWxheSByb3V0aW5lLCBhbGxvd2luZyB3YWtldXAgSVBJcyB0byBiZSBza2lwcGVkDQo+ID4g
PiAoaWYgdGhlIElQSSBoYXBwZW5zIGluIHRoYXQgd2luZG93KS4NCj4gPiA+IA0KPiA+ID4gVGhl
IHJlYWwtbGlmZSB3b3JrbG9hZCB3aGljaCB0aGlzIHBhdGNoIGltcHJvdmVzIHBlcmZvcm1hbmNl
DQo+ID4gPiBpcyBTQVAgSEFOQSAoYnkgNS0xMCUpIChmb3Igd2hpY2ggY2FzZSBzZXR0aW5nIGlk
bGVfc3BpbiB0byAzMA0KPiA+ID4gaXMgc3VmZmljaWVudCkuDQo+ID4gPiANCj4gPiA+IFRoaXMg
cGF0Y2ggaW1wcm92ZXMgdGhlIGF0dGFjaGVkIHNlcnZlci5weSBhbmQgY2xpZW50LnB5IGV4YW1w
bGUNCj4gPiA+IGFzIGZvbGxvd3M6DQo+ID4gPiANCj4gPiA+IEhvc3Q6ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgMzEuODE0MjMwMjAyMjMxNTU2DQo+ID4gPiBHdWVzdDogICAgICAgICAgICAg
ICAgICAgICAgICAgIDM4LjE3NzE4NzY1MTk5OTkzICAgICAgICg4MyAlKQ0KPiA+ID4gR3Vlc3Qs
IGlkbGVfc3Bpbj01MHVzOiAgICAgICAgICAzMy4zMTc3MDk4OTgwMDAwMDQgICAgICAoOTUgJSkN
Cj4gPiA+IEd1ZXN0LCBpZGxlX3NwaW49MjIwdXM6ICAgICAgICAgMzIuMjc4MjY1NTE0OTk5OTkg
ICAgICAgKDk4ICUpDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IE1hcmNlbG8gVG9zYXR0
aSA8bXRvc2F0dGlAcmVkaGF0LmNvbT4NCj4gPiA+IA0KPiA+ID4gLS0tDQo+ID4gPiAga2VybmVs
L3NjaGVkL2lkbGUuYyB8ICAgODYNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gPiA+IA0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA4NiBpbnNlcnRpb25z
KCspDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9rZXJuZWwvc2NoZWQvaWRsZS5jIGIva2Vy
bmVsL3NjaGVkL2lkbGUuYw0KPiA+ID4gaW5kZXggZjU1MTZiYWUwYzFiLi5iY2E3NjU2YTdlYTAg
MTAwNjQ0DQo+ID4gPiAtLS0gYS9rZXJuZWwvc2NoZWQvaWRsZS5jDQo+ID4gPiArKysgYi9rZXJu
ZWwvc2NoZWQvaWRsZS5jDQo+ID4gPiBAQCAtMjE2LDYgKzIxNiwyOSBAQCBzdGF0aWMgdm9pZCBj
cHVpZGxlX2lkbGVfY2FsbCh2b2lkKQ0KPiA+ID4gICAgICAgICByY3VfaWRsZV9leGl0KCk7DQo+
ID4gPiAgfQ0KPiA+ID4gDQo+ID4gPiArc3RhdGljIHVuc2lnbmVkIGludCBzcGluX2JlZm9yZV9p
ZGxlX3VzOw0KPiA+ID4gDQo+ID4gPiArc3RhdGljIHZvaWQgZG9fc3Bpbl9iZWZvcmVfaWRsZSh2
b2lkKQ0KPiA+ID4gK3sNCj4gPiA+ICsgICAgICAga3RpbWVfdCBub3csIGVuZF9zcGluOw0KPiA+
ID4gKw0KPiA+ID4gKyAgICAgICBub3cgPSBrdGltZV9nZXQoKTsNCj4gPiA+ICsgICAgICAgZW5k
X3NwaW4gPSBrdGltZV9hZGRfbnMobm93LCBzcGluX2JlZm9yZV9pZGxlX3VzKjEwMDApOw0KPiA+
ID4gKw0KPiA+ID4gKyAgICAgICByY3VfaWRsZV9lbnRlcigpOw0KPiA+ID4gKyAgICAgICBsb2Nh
bF9pcnFfZW5hYmxlKCk7DQo+ID4gPiArICAgICAgIHN0b3BfY3JpdGljYWxfdGltaW5ncygpOw0K
PiA+ID4gKw0KPiA+ID4gKyAgICAgICBkbyB7DQo+ID4gPiArICAgICAgICAgICAgICAgY3B1X3Jl
bGF4KCk7DQo+ID4gPiArICAgICAgICAgICAgICAgbm93ID0ga3RpbWVfZ2V0KCk7DQo+ID4gPiAr
ICAgICAgIH0gd2hpbGUgKCF0aWZfbmVlZF9yZXNjaGVkKCkgJiYga3RpbWVfYmVmb3JlKG5vdywg
ZW5kX3NwaW4pKTsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgc3RhcnRfY3JpdGljYWxfdGltaW5n
cygpOw0KPiA+ID4gKyAgICAgICByY3VfaWRsZV9leGl0KCk7DQo+ID4gPiArICAgICAgIGxvY2Fs
X2lycV9kaXNhYmxlKCk7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4gIC8qDQo+ID4gPiAgICog
R2VuZXJpYyBpZGxlIGxvb3AgaW1wbGVtZW50YXRpb24NCj4gPiA+ICAgKg0KPiA+ID4gQEAgLTI1
OSw2ICsyODIsOCBAQCBzdGF0aWMgdm9pZCBkb19pZGxlKHZvaWQpDQo+ID4gPiAgICAgICAgICAg
ICAgICAgICAgICAgICB0aWNrX25vaHpfaWRsZV9yZXN0YXJ0X3RpY2soKTsNCj4gPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgIGNwdV9pZGxlX3BvbGwoKTsNCj4gPiA+ICAgICAgICAgICAgICAg
ICB9IGVsc2Ugew0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHNwaW5fYmVmb3Jl
X2lkbGVfdXMpDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRvX3NwaW5f
YmVmb3JlX2lkbGUoKTsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGNwdWlkbGVfaWRs
ZV9jYWxsKCk7DQo+ID4gPiAgICAgICAgICAgICAgICAgfQ0KPiA+ID4gICAgICAgICAgICAgICAg
IGFyY2hfY3B1X2lkbGVfZXhpdCgpOw0KPiA+ID4gQEAgLTQ2NSwzICs0OTAsNjQgQEAgY29uc3Qg
c3RydWN0IHNjaGVkX2NsYXNzIGlkbGVfc2NoZWRfY2xhc3MgPSB7DQo+ID4gPiAgICAgICAgIC5z
d2l0Y2hlZF90byAgICAgICAgICAgID0gc3dpdGNoZWRfdG9faWRsZSwNCj4gPiA+ICAgICAgICAg
LnVwZGF0ZV9jdXJyICAgICAgICAgICAgPSB1cGRhdGVfY3Vycl9pZGxlLA0KPiA+ID4gIH07DQo+
ID4gPiArDQo+ID4gPiArDQo+ID4gPiArc3RhdGljIHNzaXplX3Qgc3RvcmVfaWRsZV9zcGluKHN0
cnVjdCBrb2JqZWN0ICprb2JqLA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHN0cnVjdCBrb2JqX2F0dHJpYnV0ZSAqYXR0ciwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBjb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkNCj4gPiA+ICt7DQo+ID4g
PiArICAgICAgIHVuc2lnbmVkIGludCB2YWw7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIGlmIChr
c3RydG91aW50KGJ1ZiwgMTAsICZ2YWwpIDwgMCkNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1
cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgaWYgKHZhbCA+IFVTRUNfUEVSX1NF
QykNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+
ICsgICAgICAgc3Bpbl9iZWZvcmVfaWRsZV91cyA9IHZhbDsNCj4gPiA+ICsgICAgICAgcmV0dXJu
IGNvdW50Ow0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+ICtzdGF0aWMgc3NpemVfdCBzaG93X2lk
bGVfc3BpbihzdHJ1Y3Qga29iamVjdCAqa29iaiwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCBrb2JqX2F0dHJpYnV0ZSAqYXR0ciwNCj4gPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGNoYXIgKmJ1ZikNCj4gPiA+ICt7DQo+ID4gPiArICAgICAgIHNz
aXplX3QgcmV0Ow0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICByZXQgPSBzcHJpbnRmKGJ1ZiwgIiVk
XG4iLCBzcGluX2JlZm9yZV9pZGxlX3VzKTsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgcmV0dXJu
IHJldDsNCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiArc3RhdGljIHN0cnVjdCBrb2JqX2F0dHJp
YnV0ZSBpZGxlX3NwaW5fYXR0ciA9DQo+ID4gPiArICAgICAgIF9fQVRUUihpZGxlX3NwaW4sIDA2
NDQsIHNob3dfaWRsZV9zcGluLCBzdG9yZV9pZGxlX3NwaW4pOw0KPiA+ID4gKw0KPiA+ID4gK3N0
YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpzY2hlZF9hdHRyc1tdID0gew0KPiA+ID4gKyAgICAgICAm
aWRsZV9zcGluX2F0dHIuYXR0ciwNCj4gPiA+ICsgICAgICAgTlVMTCwNCj4gPiA+ICt9Ow0KPiA+
ID4gKw0KPiA+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwIHNjaGVkX2F0
dHJfZ3JvdXAgPSB7DQo+ID4gPiArICAgICAgIC5hdHRycyA9IHNjaGVkX2F0dHJzLA0KPiA+ID4g
K307DQo+ID4gPiArDQo+ID4gPiArc3RhdGljIHN0cnVjdCBrb2JqZWN0ICpzY2hlZF9rb2JqOw0K
PiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBpbnQgX19pbml0IHNjaGVkX3N5c2ZzX2luaXQodm9pZCkN
Cj4gPiA+ICt7DQo+ID4gPiArICAgICAgIGludCBlcnJvcjsNCj4gPiA+ICsNCj4gPiA+ICsgICAg
ICAgc2NoZWRfa29iaiA9IGtvYmplY3RfY3JlYXRlX2FuZF9hZGQoInNjaGVkIiwga2VybmVsX2tv
YmopOw0KPiA+ID4gKyAgICAgICBpZiAoIXNjaGVkX2tvYmopDQo+ID4gPiArICAgICAgICAgICAg
ICAgcmV0dXJuIC1FTk9NRU07DQo+ID4gPiArDQo+ID4gPiArICAgICAgIGVycm9yID0gc3lzZnNf
Y3JlYXRlX2dyb3VwKHNjaGVkX2tvYmosICZzY2hlZF9hdHRyX2dyb3VwKTsNCj4gPiA+ICsgICAg
ICAgaWYgKGVycm9yKQ0KPiA+ID4gKyAgICAgICAgICAgICAgIGdvdG8gZXJyOw0KPiA+ID4gKyAg
ICAgICByZXR1cm4gMDsNCj4gPiA+ICsNCj4gPiA+ICtlcnI6DQo+ID4gPiArICAgICAgIGtvYmpl
Y3RfcHV0KHNjaGVkX2tvYmopOw0KPiA+ID4gKyAgICAgICByZXR1cm4gZXJyb3I7DQo+ID4gPiAr
fQ0KPiA+ID4gK3Bvc3Rjb3JlX2luaXRjYWxsKHNjaGVkX3N5c2ZzX2luaXQpOw0KPiANCgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3
IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJlcjogQ2hyaXN0aWFuIFNjaGxhZWdlciwgUmFsZiBIZXJi
cmljaApVc3QtSUQ6IERFIDI4OSAyMzcgODc5CkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENo
YXJsb3R0ZW5idXJnIEhSQiAxNDkxNzMgQgoK

