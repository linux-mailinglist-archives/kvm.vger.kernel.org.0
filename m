Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84712A430
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 22:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfLXVS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 16:18:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:47007 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfLXVS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 16:18:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2019 13:18:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,353,1571727600"; 
   d="scan'208";a="367422018"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga004.jf.intel.com with ESMTP; 24 Dec 2019 13:18:28 -0800
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.30]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.58]) with mapi id 14.03.0439.000;
 Tue, 24 Dec 2019 13:18:27 -0800
From:   "Andersen, John S" <john.s.andersen@intel.com>
To:     "luto@kernel.org" <luto@kernel.org>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@alien8.de" <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND RFC 2/2] X86: Use KVM CR pin MSRs
Thread-Topic: [RESEND RFC 2/2] X86: Use KVM CR pin MSRs
Thread-Index: AQHVt2uKu6eHdNQTz0i3fUdfaU+1QqfH33CAgAJ3m4A=
Date:   Tue, 24 Dec 2019 21:18:27 +0000
Message-ID: <19f3a3f98d259accf67a6c22c112bfa8f11513d4.camel@intel.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
         <20191220192701.23415-3-john.s.andersen@intel.com>
         <CALCETrV1nOpc3mqyXTXOzw-8Aa3zFpGi1cY7oc_2pz2-JVyH8Q@mail.gmail.com>
In-Reply-To: <CALCETrV1nOpc3mqyXTXOzw-8Aa3zFpGi1cY7oc_2pz2-JVyH8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD3D47AD34E9254197DE09827F1AF43B@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDE5LTEyLTIyIGF0IDIzOjM5IC0wODAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+IE9uIEZyaSwgRGVjIDIwLCAyMDE5IGF0IDExOjI3IEFNIEpvaG4gQW5kZXJzZW4NCj4gPGpv
aG4ucy5hbmRlcnNlbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IFN0cmVuZ3RoZW4gZXhpc3Rpbmcg
Y29udHJvbCByZWdpc3RlciBwaW5uaW5nIHdoZW4gcnVubmluZw0KPiA+IHBhcmF2aXJ0dWFsaXpl
ZCB1bmRlciBLVk0uIENoZWNrIHdoaWNoIGJpdHMgS1ZNIHN1cHBvcnRzIHBpbm5pbmcNCj4gPiBm
b3INCj4gPiBlYWNoIGNvbnRyb2wgcmVnaXN0ZXIgYW5kIG9ubHkgcGluIHN1cHBvcnRlZCBiaXRz
IHdoaWNoIGFyZSBhbHJlYWR5DQo+ID4gcGlubmVkIHZpYSB0aGUgZXhpc3RpbmcgbmF0aXZlIHBy
b3RlY3Rpb24uIFdyaXRlIHRvIEtWTSBDUjAgYW5kIENSNA0KPiA+IHBpbm5lZCBNU1JzIHRvIGVu
YWJsZSBwaW5uaW5nLg0KPiA+IA0KPiA+IEluaXRpYXRlIEtWTSBhc3Npc3RlZCBwaW5uaW5nIGRp
cmVjdGx5IGZvbGxvd2luZyB0aGUgc2V0dXAgb2YNCj4gPiBuYXRpdmUNCj4gPiBwaW5uaW5nIG9u
IGJvb3QgQ1BVLiBGb3Igbm9uLWJvb3QgQ1BVcyBpbml0aWF0ZSBwYXJhdmlydHVhbGl6ZWQNCj4g
PiBwaW5uaW5nDQo+ID4gb24gQ1BVIGlkZW50aWZpY2F0aW9uLg0KPiA+IA0KPiA+IElkZW50aWZp
Y2F0aW9uIG9mIG5vbi1ib290IENQVXMgdGFrZXMgcGxhY2UgYWZ0ZXIgdGhlIGJvb3QgQ1BVIGhh
cw0KPiA+IHNldHVwDQo+ID4gbmF0aXZlIENSIHBpbm5pbmcuIFRoZXJlZm9yZSwgbm9uLWJvb3Qg
Q1BVcyBhY2Nlc3MgcGlubmVkIGJpdHMNCj4gPiBzZXR1cCBieQ0KPiA+IHRoZSBib290IENQVSBh
bmQgcmVxdWVzdCB0aGF0IHRob3NlIGJlIHBpbm5lZC4gQWxsIENQVXMgcmVxdWVzdA0KPiA+IHBh
cmF2aXJ0dWFsaXplZCBwaW5uaW5nIG9mIHRoZSBzYW1lIGJpdHMgd2hpY2ggYXJlIGFscmVhZHkg
cGlubmVkDQo+ID4gbmF0aXZlbHkuDQo+ID4gDQo+ID4gR3Vlc3RzIHVzaW5nIHRoZSBrZXhlYyBz
eXN0ZW0gY2FsbCBjdXJyZW50bHkgZG8gbm90IHN1cHBvcnQNCj4gPiBwYXJhdmlydHVhbGl6ZWQg
Y29udHJvbCByZWdpc3RlciBwaW5uaW5nLiBUaGlzIGlzIGR1ZSB0byBlYXJseSBib290DQo+ID4g
Y29kZSB3cml0aW5nIGtub3duIGdvb2QgdmFsdWVzIHRvIGNvbnRyb2wgcmVnaXN0ZXJzLCB0aGVz
ZSB2YWx1ZXMNCj4gPiBkbw0KPiA+IG5vdCBjb250YWluIHRoZSBwcm90ZWN0ZWQgYml0cy4gVGhp
cyBpcyBkdWUgdG8gQ1BVIGZlYXR1cmUNCj4gPiBpZGVudGlmaWNhdGlvbiBiZWluZyBkb25lIGF0
IGEgbGF0ZXIgdGltZSwgd2hlbiB0aGUga2VybmVsIHByb3Blcmx5DQo+ID4gY2hlY2tzIGlmIGl0
IGNhbiBlbmFibGUgcHJvdGVjdGlvbnMuDQo+IA0KPiBJcyBoaWJlcm5hdGlvbiBzdXBwb3J0ZWQ/
ICBIb3cgYWJvdXQgc3VzcGVuZC10by1SQU0/DQo+IA0KDQpTb21ldGhpbmcgaXMgd3JpdGluZyB0
byBDUjQgZHVyaW5nIHJlc3VtZSB3aGljaCBpcyBicmVha2luZw0KaGliZXJuYXRpb24uIFVuZm9y
dHVuYXRlbHkgSSBoYWRuJ3QgYmVlbiBhYmxlIHRvIGdldCBteSBoaWJlcm5hdGlvbg0KdGVzdCB3
b3JraW5nIGJlZm9yZSBzZW5kaW5nIHRoaXMgb3V0LiBJIHdpbGwgaW52ZXN0aWdhdGUuDQoNCj4g
RldJVywgSSB0aGluayB0aGF0IGhhbmRsaW5nIHRoZXNlIGRldGFpbHMgdGhyb3VnaCBLY29uZmln
IGlzIHRoZQ0KPiB3cm9uZw0KPiBjaG9pY2UuICBEaXN0cmlidXRpb24ga2VybmVscyBzaG91bGQg
ZW5hYmxlIHRoaXMsIGFuZCB0aGV5J3JlIG5vdA0KPiBnb2luZyB0byB0dXJuIG9mZiBrZXhlYy4g
IEFyZ3VhYmx5IGtleGVjIHNob3VsZCBiZSBtYWRlIHRvIHdvcmsgLS0NCj4gdGhlcmUgaXMgbm8g
ZnVuZGFtZW50YWwgcmVhc29uIHRoYXQga2V4ZWMgc2hvdWxkIG5lZWQgdG8gZmlkZGxlIHdpdGgN
Cj4gQ1IwLldQLCBmb3IgZXhhbXBsZS4gIEJ1dCBhIGJvb3Qgb3B0aW9uIGNvdWxkIGFsc28gd29y
ayBhcyBhDQo+IHNob3J0LXRlcm0gb3B0aW9uLg0KDQpHaXZlbiB0aGUgc2l0dWF0aW9uIHdpdGgg
aGliZXJuYXRpb24uIEkgdGhpbmsgSSdsbCBpbXBsZW1lbnQgdGhlIGtleGVjDQpkaXNjb3Zlcnkg
TGlyYW4gc3VnZ2VzdGVkLCBhbmQgdGhlbiBpbnZlc3RpZ2F0ZSB0aGUgaGliZXJuYXRlIHNpdHVh
dGlvbg0KZnVydGhlci4NCg0KVGhhbmtzLA0KSm9obg0K
