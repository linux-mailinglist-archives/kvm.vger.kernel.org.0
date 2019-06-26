Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E3C571BA
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFZT1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 15:27:41 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:8069 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZT1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 15:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1561577260; x=1593113260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=lkbk1SreqaQWD4wgjFtaRvmoSGGwedOqlja293CQfVs=;
  b=JNT5ekWNWn2GcvhDDuck0bZS9rKkfVObGREmWg0DqX87sZ6Jl+V/arYf
   P35B7egQ5uTDeN0IUnxKBRtB5Na2mT5pkDF1vMPRqYX/1+ElU/uPuW5Jo
   E/2rNGaiWgtDi8MwuuOkbT2l82Qr4oJUHARCvu3dVaJhmVerKK08Hg9lM
   I=;
X-IronPort-AV: E=Sophos;i="5.62,420,1554768000"; 
   d="scan'208";a="402538618"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 26 Jun 2019 19:27:38 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 53CE8A1E66;
        Wed, 26 Jun 2019 19:27:37 +0000 (UTC)
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Jun 2019 19:27:36 +0000
Received: from EX13D01EUB003.ant.amazon.com (10.43.166.248) by
 EX13D01EUB003.ant.amazon.com (10.43.166.248) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 26 Jun 2019 19:27:35 +0000
Received: from EX13D01EUB003.ant.amazon.com ([10.43.166.248]) by
 EX13D01EUB003.ant.amazon.com ([10.43.166.248]) with mapi id 15.00.1367.000;
 Wed, 26 Jun 2019 19:27:35 +0000
From:   "Raslan, KarimAllah" <karahmed@amazon.de>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: cputime takes cstate into consideration
Thread-Topic: cputime takes cstate into consideration
Thread-Index: AQHVLAPB6iUJbr9/fEyB9GgoQyBOoKatvSkAgABI2ICAABbjAIAAJXoAgAADBQCAAAQPAIAABxkAgAAB1gA=
Date:   Wed, 26 Jun 2019 19:27:35 +0000
Message-ID: <1561577254.25880.15.camel@amazon.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
         <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
         <20190626145413.GE6753@char.us.oracle.com>
         <20190626161608.GM3419@hirez.programming.kicks-ass.net>
         <20190626183016.GA16439@char.us.oracle.com>
         <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>
         <1561575336.25880.7.camel@amazon.de>
         <20190626192100.GP3419@hirez.programming.kicks-ass.net>
In-Reply-To: <20190626192100.GP3419@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.217]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A74719A25336AC49AA46E8CE5AD11C1B@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTI2IGF0IDIxOjIxICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBKdW4gMjYsIDIwMTkgYXQgMDY6NTU6MzZQTSArMDAwMCwgUmFzbGFuLCBLYXJp
bUFsbGFoIHdyb3RlOg0KPiANCj4gPiANCj4gPiBJZiB0aGUgaG9zdCBpcyBjb21wbGV0ZWx5IGlu
IG5vX2Z1bGxfaHogbW9kZSBhbmQgdGhlIHBDUFUgaXMgZGVkaWNhdGVkIHRvIGHCoA0KPiA+IHNp
bmdsZSB2Q1BVL3Rhc2sgKGFuZCB0aGUgZ3Vlc3QgaXMgMTAwJSBDUFUgYm91bmQgYW5kIG5ldmVy
IGV4aXRzKSwgeW91IHdvdWxkwqANCj4gPiBzdGlsbCBiZSB0aWNraW5nIGluIHRoZSBob3N0IG9u
Y2UgZXZlcnkgc2Vjb25kIGZvciBob3VzZWtlZXBpbmcsIHJpZ2h0PyBXb3VsZMKgDQo+ID4gbm90
IHVwZGF0aW5nIHRoZSBtd2FpdC10aW1lIG9uY2UgYSBzZWNvbmQgYmUgZW5vdWdoIGhlcmU/DQo+
IA0KPiBQZW9wbGUgYXJlIHRyeWluZyB2ZXJ5IGhhcmQgdG8gZ2V0IHJpZCBvZiB0aGF0IHJlbW5h
bnQgdGljay4gTGV0cyBub3QNCj4gYWRkIGRlcGVuZGVuY2llcyB0byBpdC4NCj4gDQo+IElNTyB0
aGlzIGlzIGEgcmVhbGx5IHN0dXBpZCBpc3N1ZSwgMTAwJSB0aW1lIGlzIGNvcnJlY3QgaWYgdGhl
IGd1ZXN0DQo+IGRvZXMgaWRsZSBpbiBwaW5uZWQgdmNwdSBtb2RlLg0KDQpPbmUgdXNlIGNhc2Ug
Zm9yIHByb3BlciBhY2NvdW50aW5nIChvYnZpb3VzbHkgZm9yIGEgc2xpZ2h0bHkgcmVsYXhlZCBk
ZWZpbml0aW9uwqANCm9yICpwcm9wZXIqKSBpcyAqZXh0ZXJuYWwqIG1vbml0b3Jpbmcgb2YgQ1BV
IHV0aWxpemF0aW9uIGZvciBzY2FsaW5nIGdyb3VwDQooaS5lLiBtb3JlIFZNcyB3aWxsIGJlIGxh
dW5jaGVkIHdoZW4geW91IHJlYWNoIGEgY2VydGFpbiBDUFUgdXRpbGl6YXRpb24pLg0KVGhlc2Ug
ZXh0ZXJuYWwgbW9uaXRvcmluZyB0b29scyBuZWVkcyB0byBhY2NvdW50IENQVSB1dGlsaXphdGlv
biBwcm9wZXJseS4KCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3Jh
dXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNj
aGxhZWdlciwgUmFsZiBIZXJicmljaApFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90
dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIz
NyA4NzkKCgo=

