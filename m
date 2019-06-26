Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C395711C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 20:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFZSzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 14:55:45 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:2685 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZSzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 14:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561575344; x=1593111344;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=UBIMP93OFTJuw1q6Mt7ocNPirSB3bhcxbLEE71LIddU=;
  b=LvgoXUrdACo5DbTTI/qIFgVuGkZRLzni4Rq1Uq0VReB2ilyPhbrrbbBe
   9PLxugcNXPpbFFZCzzbh+hs+WKRTPa5CarASM95SyP+9n3X1UaeRP4K7t
   752qYnCn1BV5/AjYwX1Zrx0cfnmr6xPeUf4JkUDPF8dbonokVekmTG1DL
   k=;
X-IronPort-AV: E=Sophos;i="5.62,420,1554768000"; 
   d="scan'208";a="772186343"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 26 Jun 2019 18:55:42 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 0A87E1418C3;
        Wed, 26 Jun 2019 18:55:38 +0000 (UTC)
Received: from EX13D01EUB001.ant.amazon.com (10.43.166.194) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Jun 2019 18:55:38 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB001.ant.amazon.com (10.43.166.194) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Jun 2019 18:55:37 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Wed, 26 Jun 2019 18:55:37 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: cputime takes cstate into consideration
Thread-Topic: cputime takes cstate into consideration
Thread-Index: AQHVLAPB6iUJbr9/fEyB9GgoQyBOoKatvSkAgABI2ICAABbjAIAAJXoAgAADBQCAAAQPAA==
Date:   Wed, 26 Jun 2019 18:55:36 +0000
Message-ID: <1561575336.25880.7.camel@amazon.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
         <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
         <20190626145413.GE6753@char.us.oracle.com>
         <20190626161608.GM3419@hirez.programming.kicks-ass.net>
         <20190626183016.GA16439@char.us.oracle.com>
         <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <30B6EEC9D401B147921369151BC1ECFE@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTI2IGF0IDIwOjQxICswMjAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
DQo+IE9uIFdlZCwgMjYgSnVuIDIwMTksIEtvbnJhZCBSemVzenV0ZWsgV2lsayB3cm90ZToNCj4g
PiANCj4gPiBPbiBXZWQsIEp1biAyNiwgMjAxOSBhdCAwNjoxNjowOFBNICswMjAwLCBQZXRlciBa
aWpsc3RyYSB3cm90ZToNCj4gPiA+IA0KPiA+ID4gT24gV2VkLCBKdW4gMjYsIDIwMTkgYXQgMTA6
NTQ6MTNBTSAtMDQwMCwgS29ucmFkIFJ6ZXN6dXRlayBXaWxrIHdyb3RlOg0KPiA+ID4gPiANCj4g
PiA+ID4gVGhlcmUgd2VyZSBzb21lIGlkZWFzIHRoYXQgQW5rdXIgKENDLWVkKSBtZW50aW9uZWQg
dG8gbWUgb2YgdXNpbmcgdGhlIHBlcmYNCj4gPiA+ID4gY291bnRlcnMgKGluIHRoZSBob3N0KSB0
byBzYW1wbGUgdGhlIGd1ZXN0IGFuZCBjb25zdHJ1Y3QgYSBiZXR0ZXINCj4gPiA+ID4gYWNjb3Vu
dGluZyBpZGVhIG9mIHdoYXQgdGhlIGd1ZXN0IGRvZXMuIFRoYXQgd2F5IHRoZSBkYXNoYm9hcmQN
Cj4gPiA+ID4gZnJvbSB0aGUgaG9zdCB3b3VsZCBub3Qgc2hvdyAxMDAlIENQVSB1dGlsaXphdGlv
bi4NCj4gPiA+IA0KPiA+ID4gQnV0IHRoZW4geW91IGdlbmVyYXRlIGV4dHJhIG5vaXNlIGFuZCB2
bWV4aXRzIG9uIHRob3NlIGNwdXMsIGp1c3QgdG8gZ2V0DQo+ID4gPiB0aGlzIGFjY291bnRpbmcg
c29ydGVkLCB3aGljaCBzb3VuZHMgbGlrZSBhIGJhZCB0cmFkZS4NCj4gPiANCj4gPiBDb25zaWRl
cmluZyB0aGF0IHRoZSBDUFVzIGFyZW4ndCBkb2luZyBhbnl0aGluZyBhbmQgaWYgeW91IGRvIHNh
eSB0aGUgDQo+ID4gSVBJcyAib25seSIgMTAwL3NlY29uZCAtIHRoYXQgd291bGQgYmUgc28gc21h
bGwgYnV0IGdpdmUgeW91IGEgYmlnIGJlbmVmaXQNCj4gPiBpbiBwcm9wZXJseSBhY2NvdW50aW5n
IHRoZSBndWVzdHMuDQo+IA0KPiBUaGUgaG9zdCBkb2Vzbid0IGtub3cgd2hhdCB0aGUgZ3Vlc3Qg
Q1BVcyBhcmUgZG9pbmcuIEFuZCBpZiB5b3UgaGF2ZSBhIGZ1bGwNCj4gemVybyBleGl0IHNldHVw
IGFuZCB0aGUgZ3Vlc3QgaXMgY29tcHV0aW5nIHN0dWZmIG9yIGRvaW5nIHRoYXQgbmV0d29yaw0K
PiBvZmZsb2FkaW5nIHRoaW5nIHRoZW4gdGhleSB3aWxsIG5vdGljZSB0aGUgMTAwL3Mgdm1leGl0
cyBhbmQgY29tcGxhaW4uDQoNCklmIHRoZSBob3N0IGlzIGNvbXBsZXRlbHkgaW4gbm9fZnVsbF9o
eiBtb2RlIGFuZCB0aGUgcENQVSBpcyBkZWRpY2F0ZWQgdG8gYcKgDQpzaW5nbGUgdkNQVS90YXNr
IChhbmQgdGhlIGd1ZXN0IGlzIDEwMCUgQ1BVIGJvdW5kIGFuZCBuZXZlciBleGl0cyksIHlvdSB3
b3VsZMKgDQpzdGlsbCBiZSB0aWNraW5nIGluIHRoZSBob3N0IG9uY2UgZXZlcnkgc2Vjb25kIGZv
ciBob3VzZWtlZXBpbmcsIHJpZ2h0PyBXb3VsZMKgDQpub3QgdXBkYXRpbmcgdGhlIG13YWl0LXRp
bWUgb25jZSBhIHNlY29uZCBiZSBlbm91Z2ggaGVyZT8NCg0KPiANCj4gPiANCj4gPiBCdXQgcGVy
aGFwcyB0aGVyZSBhcmUgb3RoZXIgd2F5cyB0b28gdG8gInNub29wIiBpZiBhIGd1ZXN0IGlzIHNp
dHRpbmcgb24NCj4gPiBhbiBNV0FJVD8NCj4gDQo+IE5vIGlkZWEuDQo+IA0KPiBUaGFua3MsDQo+
IA0KPiAJdGdseA0KPiANCj4gDQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkg
R21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJp
c3RpYW4gU2NobGFlZ2VyLCBSYWxmIEhlcmJyaWNoCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0
IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBE
RSAyODkgMjM3IDg3OQoKCg==

