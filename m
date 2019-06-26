Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FCC57122
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 20:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFZS7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 14:59:31 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:15928 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZS7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 14:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561575570; x=1593111570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=CT6ElSc2GZ3wKXKC1lG5OYakWHL+cI1N18YJRLUfo44=;
  b=qZbBS4qlNvX9DF+8WpiLjCdNUGAs5JI4+EyrnTv13Y+y6VcpnPOPw0Rm
   qsKuWhAZe/4QL82dVC/IfCytnOsM35Ptntq6QSwZP0iruWqGigY/BQn4d
   Xox3xyYIWo3pRehInF8tQnPOYhoLjSU2T/HOAwd+kriOdsiN6T2vHRuNb
   g=;
X-IronPort-AV: E=Sophos;i="5.62,420,1554768000"; 
   d="scan'208";a="682321801"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Jun 2019 18:59:02 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-2c665b5d.us-east-1.amazon.com (Postfix) with ESMTPS id 195AFA1F6A;
        Wed, 26 Jun 2019 18:58:58 +0000 (UTC)
Received: from EX13D01EUB004.ant.amazon.com (10.43.166.180) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Jun 2019 18:58:58 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB004.ant.amazon.com (10.43.166.180) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Jun 2019 18:58:57 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Wed, 26 Jun 2019 18:58:57 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: cputime takes cstate into consideration
Thread-Topic: cputime takes cstate into consideration
Thread-Index: AQHVLAPB6iUJbr9/fEyB9GgoQyBOoKatvSkAgABI2ICAAERgAA==
Date:   Wed, 26 Jun 2019 18:58:57 +0000
Message-ID: <1561575536.25880.10.camel@amazon.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
         <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
         <20190626145413.GE6753@char.us.oracle.com>
In-Reply-To: <20190626145413.GE6753@char.us.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.107]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6054BA1676D0AB47AD5D503A03CE81D1@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTI2IGF0IDEwOjU0IC0wNDAwLCBLb25yYWQgUnplc3p1dGVrIFdpbGsg
d3JvdGU6DQo+IE9uIFdlZCwgSnVuIDI2LCAyMDE5IGF0IDEyOjMzOjMwUE0gKzAyMDAsIFRob21h
cyBHbGVpeG5lciB3cm90ZToNCj4gPiANCj4gPiBPbiBXZWQsIDI2IEp1biAyMDE5LCBXYW5wZW5n
IExpIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBBZnRlciBleHBvc2luZyBtd2FpdC9tb25pdG9yIGlu
dG8ga3ZtIGd1ZXN0LCB0aGUgZ3Vlc3QgY2FuIG1ha2UNCj4gPiA+IHBoeXNpY2FsIGNwdSBlbnRl
ciBkZWVwZXIgY3N0YXRlIHRocm91Z2ggbXdhaXQgaW5zdHJ1Y3Rpb24sIGhvd2V2ZXIsDQo+ID4g
PiB0aGUgdG9wIGNvbW1hbmQgb24gaG9zdCBzdGlsbCBvYnNlcnZlIDEwMCUgY3B1IHV0aWxpemF0
aW9uIHNpbmNlIHFlbXUNCj4gPiA+IHByb2Nlc3MgaXMgcnVubmluZyBldmVuIHRob3VnaCBndWVz
dCB3aG8gaGFzIHRoZSBwb3dlciBtYW5hZ2VtZW50DQo+ID4gPiBjYXBhYmlsaXR5IGV4ZWN1dGVz
IG13YWl0LiBBY3R1YWxseSB3ZSBjYW4gb2JzZXJ2ZSB0aGUgcGh5c2ljYWwgY3B1DQo+ID4gPiBo
YXMgYWxyZWFkeSBlbnRlciBkZWVwZXIgY3N0YXRlIGJ5IHBvd2VydG9wIG9uIGhvc3QuIENvdWxk
IHdlIHRha2UNCj4gPiA+IGNzdGF0ZSBpbnRvIGNvbnNpZGVyYXRpb24gd2hlbiBhY2NvdW50aW5n
IGNwdXRpbWUgZXRjPw0KPiA+IA0KPiA+IElmIE1XQUlUIGNhbiBiZSB1c2VkIGluc2lkZSB0aGUg
Z3Vlc3QgdGhlbiB0aGUgaG9zdCBjYW5ub3QgZGlzdGluZ3Vpc2gNCj4gPiBiZXR3ZWVuIGV4ZWN1
dGlvbiBhbmQgc3R1Y2sgaW4gbXdhaXQuDQo+ID4gDQo+ID4gSXQnZCBuZWVkIHRvIHBvbGwgdGhl
IHBvd2VyIG1vbml0b3JpbmcgTVNScyBvbiBldmVyeSBvY2Nhc2lvbiB3aGVyZSB0aGUNCj4gPiBh
Y2NvdW50aW5nIGhhcHBlbnMuDQo+ID4gDQo+ID4gVGhpcyBjb21wbGV0ZWx5IGZhbGxzIGFwYXJ0
IHdoZW4geW91IGhhdmUgemVybyBleGl0IGd1ZXN0LiAodGhpbmsNCj4gPiBOT0haX0ZVTEwpLiBU
aGVuIHlvdSdkIGhhdmUgdG8gYnJpbmcgdGhlIGd1ZXN0IG91dCB3aXRoIGFuIElQSSB0byBhY2Nl
c3MNCj4gPiB0aGUgcGVyIENQVSBNU1JzLg0KPiA+IA0KPiA+IEkgYXNzdW1lIGEgbG90IG9mIHBl
b3BsZSB3aWxsIGJlIGhhcHB5IGFib3V0IGFsbCB0aGF0IDopDQo+IA0KPiBUaGVyZSB3ZXJlIHNv
bWUgaWRlYXMgdGhhdCBBbmt1ciAoQ0MtZWQpIG1lbnRpb25lZCB0byBtZSBvZiB1c2luZyB0aGUg
cGVyZg0KPiBjb3VudGVycyAoaW4gdGhlIGhvc3QpIHRvIHNhbXBsZSB0aGUgZ3Vlc3QgYW5kIGNv
bnN0cnVjdCBhIGJldHRlcg0KPiBhY2NvdW50aW5nIGlkZWEgb2Ygd2hhdCB0aGUgZ3Vlc3QgZG9l
cy4gVGhhdCB3YXkgdGhlIGRhc2hib2FyZA0KPiBmcm9tIHRoZSBob3N0IHdvdWxkIG5vdCBzaG93
IDEwMCUgQ1BVIHV0aWxpemF0aW9uLg0KDQpZb3UgY2FuIGVpdGhlciB1c2UgdGhlIFVOSEFMVEVE
IGN5Y2xlcyBwZXJmLWNvdW50ZXIgb3IgeW91IGNhbiB1c2UgTVBFUkYvQVBFUkbCoA0KTVNScyBm
b3IgdGhhdC4gKHNvcnJ5IEkgZ290IGRpc3RyYWN0ZWQgYW5kIGZvcmdvdCB0byBzZW5kIHRoZSBw
YXRjaCkNCg0KPiANCj4gQnV0IHRoZSBwYXRjaGVzIHRoYXQgTWFyY2VsbyBwb3N0ZWQgKCIgY3B1
aWRsZS1oYWx0cG9sbCBkcml2ZXIiKSBpbiANCj4gInNvbHZlcyIgdGhlIHByb2JsZW0gZm9yIExp
bnV4LiBUaGF0IGlzIHRoZSBndWVzdCB3YW50cyBhd2Vzb21lIGxhdGVuY3kgYW5kDQo+IG9uZSB3
YXkgd2FzIHRvIGV4cG9zZSBNV0FJVCB0byB0aGUgZ3Vlc3QsIG9yIGp1c3QgdHdlYWsgdGhlIGd1
ZXN0IHRvIGRvIHRoZQ0KPiBpZGxpbmcgYSBiaXQgZGlmZmVyZW50Lg0KPiANCj4gTWFyY2VsbyBw
YXRjaGVzIGFyZSBhbGwgZ29vZCBmb3IgTGludXgsIGJ1dCBXaW5kb3dzIGlzIHN0aWxsIGFuIGlz
c3VlLg0KPiANCj4gQW5rdXIsIHdvdWxkIHlvdSBiZSBPSyBzaGFyaW5nIHNvbWUgb2YgeW91ciBp
ZGVhcz8NCj4gPiANCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gDQo+ID4gCXRnbHgNCj4gPiANCgoK
CkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEw
MTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIFJhbGYg
SGVyYnJpY2gKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIg
SFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

