Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4512A40B
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 20:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfLXToi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 14:44:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:63816 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfLXToi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 14:44:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2019 11:44:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,352,1571727600"; 
   d="scan'208";a="391951287"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga005.jf.intel.com with ESMTP; 24 Dec 2019 11:44:37 -0800
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Dec 2019 11:44:37 -0800
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.30]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.240]) with mapi id 14.03.0439.000;
 Tue, 24 Dec 2019 11:44:36 -0800
From:   "Andersen, John S" <john.s.andersen@intel.com>
To:     "liran.alon@oracle.com" <liran.alon@oracle.com>
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
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
Thread-Topic: [RESEND RFC 0/2] Paravirtualized Control Register pinning
Thread-Index: AQHVt2uK2a8jsyPFKUGPuWHWZO4ZBqfIV12AgAHldQA=
Date:   Tue, 24 Dec 2019 19:44:36 +0000
Message-ID: <73950aff51bdf908f75ffa5e5cb629fc1d4ebbb6.camel@intel.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
         <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
In-Reply-To: <1EBCD42E-9109-47A1-B959-6363A509D48D@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.42]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D12B104FD2B4D0428E3040CAFD2B0F03@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTEyLTIzIGF0IDE2OjQ4ICswMjAwLCBMaXJhbiBBbG9uIHdyb3RlOg0KPiA+
IE9uIDIwIERlYyAyMDE5LCBhdCAyMToyNiwgSm9obiBBbmRlcnNlbiA8am9obi5zLmFuZGVyc2Vu
QGludGVsLmNvbT4NCj4gPiB3cm90ZToNCj4gPiANCj4gPiBQaW5uaW5nIGlzIG5vdCBhY3RpdmUg
d2hlbiBydW5uaW5nIGluIFNNTS4gRW50ZXJpbmcgU01NIGRpc2FibGVzDQo+ID4gcGlubmVkDQo+
ID4gYml0cywgd3JpdGVzIHRvIGNvbnRyb2wgcmVnaXN0ZXJzIHdpdGhpbiBTTU0gd291bGQgdGhl
cmVmb3JlDQo+ID4gdHJpZ2dlcg0KPiA+IGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdHMgaWYgcGlu
bmluZyB3YXMgZW5mb3JjZWQuDQo+IA0KPiBGb3IgY29tcGF0aWJpbGl0eSByZWFzb25zLCBpdOKA
mXMgcmVhc29uYWJsZSB0aGF0IHBpbm5pbmcgd29u4oCZdCBiZQ0KPiBhY3RpdmUgd2hlbiBydW5u
aW5nIGluIFNNTS4NCj4gSG93ZXZlciwgSSBkbyB0aGluayB3ZSBzaG91bGQgbm90IGFsbG93IHZT
TU0gY29kZSB0byBjaGFuZ2UgcGlubmVkDQo+IHZhbHVlcyB3aGVuIHJldHVybmluZyBiYWNrIGZy
b20gU01NLg0KPiBUaGlzIHdvdWxkIHByZXZlbnQgYSB2dWxuZXJhYmxlIHZTTUkgaGFuZGxlciBm
cm9tIG1vZGlmeWluZyB2U01NDQo+IHN0YXRlLWFyZWEgdG8gbW9kaWZ5IENSNCB3aGVuIHJ1bm5p
bmcgb3V0c2lkZSBvZiB2U01NLg0KPiBJIGJlbGlldmUgaW4gdGhpcyBjYXNlIGl04oCZcyBsZWdp
dCB0byBqdXN0IGZvcmNpYmx5IHJlc3RvcmUgb3JpZ2luYWwNCj4gQ1IwL0NSNCBwaW5uZWQgdmFs
dWVzLiBJZ25vcmluZyB2U01NIGNoYW5nZXMuDQo+IA0KDQpJbiBlbV9yc20gY291bGQgd2UganVz
dCBPUiB3aXRoIHRoZSB2YWx1ZSBvZiB0aGUgUElOTkVEIE1TUnMgcmlnaHQNCmJlZm9yZSB0aGUg
ZmluYWwgcmV0dXJuPw0KDQo+ID4gVGhlIGd1ZXN0IG1heSBuZXZlciByZWFkIHBpbm5lZCBiaXRz
LiBJZiBhbiBhdHRhY2tlciB3ZXJlIHRvIHJlYWQNCj4gPiB0aGUNCj4gPiBDUiBwaW5uZWQgTVNS
cywgdGhleSBtaWdodCBkZWNpZGUgdG8gcHJlZm9ybSBhbm90aGVyIGF0dGFjayB3aGljaA0KPiA+
IHdvdWxkDQo+ID4gbm90IGNhdXNlIGEgZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0Lg0KPiANCj4g
SSBkaXNhZ3JlZSB3aXRoIHRoaXMgc3RhdGVtZW50Lg0KPiBBbiBhdHRhY2tlciBrbm93cyB3aGF0
IGlzIHRoZSBzeXN0ZW0gaXQgaXMgYXR0YWNraW5nIGFuZCBjYW4gZGVkdWNlDQo+IGJ5IHRoYXQg
d2hpY2ggYml0cyBpdCBwaW5uZWTigKYNCj4gVGhlcmVmb3JlLCBwcm90ZWN0aW5nIGZyb20gZ3Vl
c3QgcmVhZGluZyB0aGVzZSBpcyBub3QgaW1wb3J0YW50IGF0DQo+IGFsbC4NCj4gDQoNClN1cmUs
IEknbGwgbWFrZSBpdCByZWFkYWJsZS4NCg0KPiA+IFNob3VsZCB1c2Vyc3BhY2UgZXhwb3NlIHRo
ZSBDUiBwaW5pbmcgQ1BVSUQgZmVhdHVyZSBiaXQsIGl0IG11c3QNCj4gPiB6ZXJvIENSDQo+ID4g
cGlubmVkIE1TUnMgb24gcmVib290LiBJZiBpdCBkb2VzIG5vdCwgaXQgcnVucyB0aGUgcmlzayBv
ZiBoYXZpbmcNCj4gPiB0aGUNCj4gPiBndWVzdCBlbmFibGUgcGlubmluZyBhbmQgc3Vic2VxdWVu
dGx5IGNhdXNlIGdlbmVyYWwgcHJvdGVjdGlvbg0KPiA+IGZhdWx0cyBvbg0KPiA+IG5leHQgYm9v
dCBkdWUgdG8gZWFybHkgYm9vdCBjb2RlIHNldHRpbmcgY29udHJvbCByZWdpc3RlcnMgdG8NCj4g
PiB2YWx1ZXMNCj4gPiB3aGljaCBkbyBub3QgY29udGFpbiB0aGUgcGlubmVkIGJpdHMuDQo+IA0K
PiBXaHkgcmVzZXQgQ1IgcGlubmVkIE1TUnMgYnkgdXNlcnNwYWNlIGluc3RlYWQgb2YgS1ZNIElO
SVQgaGFuZGxpbmc/DQo+IA0KPiA+IFdoZW4gcnVubmluZyB3aXRoIEtWTSBndWVzdCBzdXBwb3J0
IGFuZCBwYXJhdmlydHVhbGl6ZWQgQ1IgcGlubmluZw0KPiA+IGVuYWJsZWQsIHBhcmF2aXJ0dWFs
aXplZCBhbmQgZXhpc3RpbmcgcGlubmluZyBhcmUgc2V0dXAgYXQgdGhlIHNhbWUNCj4gPiBwb2lu
dCBvbiB0aGUgYm9vdCBDUFUuIE5vbi1ib290IENQVXMgc2V0dXAgcGlubmluZyB1cG9uDQo+ID4g
aWRlbnRpZmljYXRpb24uDQo+ID4gDQo+ID4gR3Vlc3RzIHVzaW5nIHRoZSBrZXhlYyBzeXN0ZW0g
Y2FsbCBjdXJyZW50bHkgZG8gbm90IHN1cHBvcnQNCj4gPiBwYXJhdmlydHVhbGl6ZWQgY29udHJv
bCByZWdpc3RlciBwaW5uaW5nLiBUaGlzIGlzIGR1ZSB0byBlYXJseSBib290DQo+ID4gY29kZSB3
cml0aW5nIGtub3duIGdvb2QgdmFsdWVzIHRvIGNvbnRyb2wgcmVnaXN0ZXJzLCB0aGVzZSB2YWx1
ZXMNCj4gPiBkbw0KPiA+IG5vdCBjb250YWluIHRoZSBwcm90ZWN0ZWQgYml0cy4gVGhpcyBpcyBk
dWUgdG8gQ1BVIGZlYXR1cmUNCj4gPiBpZGVudGlmaWNhdGlvbiBiZWluZyBkb25lIGF0IGEgbGF0
ZXIgdGltZSwgd2hlbiB0aGUga2VybmVsIHByb3Blcmx5DQo+ID4gY2hlY2tzIGlmIGl0IGNhbiBl
bmFibGUgcHJvdGVjdGlvbnMuDQo+ID4gDQo+ID4gTW9zdCBkaXN0cmlidXRpb25zIGVuYWJsZSBr
ZXhlYy4gSG93ZXZlciwga2V4ZWMgY291bGQgYmUgbWFkZSBib290DQo+ID4gdGltZQ0KPiA+IGRp
c2FibGVhYmxlLiBJbiB0aGlzIGNhc2UgaWYgYSB1c2VyIGhhcyBkaXNhYmxlZCBrZXhlYyBhdCBi
b290IHRpbWUNCj4gPiB0aGUgZ3Vlc3Qgd2lsbCByZXF1ZXN0IHRoYXQgcGFyYXZpcnR1YWxpemVk
IGNvbnRyb2wgcmVnaXN0ZXINCj4gPiBwaW5uaW5nDQo+ID4gYmUgZW5hYmxlZC4gVGhpcyB3b3Vs
ZCBleHBhbmQgdGhlIHVzZXJiYXNlIHRvIHVzZXJzIG9mIG1ham9yDQo+ID4gZGlzdHJpYnV0aW9u
cy4NCj4gPiANCj4gPiBQYXJhdmlydHVhbGl6ZWQgQ1IgcGlubmluZyB3aWxsIGxpa2VseSBiZSBp
bmNvbXBhdGlibGUgd2l0aCBrZXhlYw0KPiA+IGZvcg0KPiA+IHRoZSBmb3Jlc2VlYWJsZSBmdXR1
cmUuIEVhcmx5IGJvb3QgY29kZSBjb3VsZCBwb3NzaWJseSBiZSBjaGFuZ2VkDQo+ID4gdG8NCj4g
PiBub3QgY2xlYXIgcHJvdGVjdGVkIGJpdHMuIEhvd2V2ZXIsIGEga2VybmVsIHRoYXQgcmVxdWVz
dHMgQ1IgYml0cw0KPiA+IGJlDQo+ID4gcGlubmVkIGNhbid0IGtub3cgaWYgdGhlIGtlcm5lbCBp
dCdzIGtleGVjaW5nIGhhcyBiZWVuIHVwZGF0ZWQgdG8NCj4gPiBub3QNCj4gPiBjbGVhciBwcm90
ZWN0ZWQgYml0cy4gVGhpcyB3b3VsZCByZXN1bHQgaW4gdGhlIGtlcm5lbCBiZWluZyBrZXhlYydk
DQo+ID4gYWxtb3N0IGltbWVkaWF0ZWx5IHJlY2VpdmluZyBhIGdlbmVyYWwgcHJvdGVjdGlvbiBm
YXVsdC4NCj4gDQo+IEluc3RlYWQgb2YgZGlzYWJsaW5nIGtleGVjIGVudGlyZWx5LCBJIHRoaW5r
IGl0IG1ha2VzIG1vcmUgc2Vuc2UgdG8NCj4gaW52ZW50DQo+IHNvbWUgZ2VuZXJpYyBtZWNoYW5p
c20gaW4gd2hpY2ggbmV3IGtlcm5lbCBjYW4gZGVzY3JpYmUgdG8gb2xkIGtlcm5lbA0KPiBhIHNl
dCBvZiBmbGFncyB0aGF0IHNwZWNpZmllcyB3aGljaCBmZWF0dXJlcyBoYW5kLW92ZXIgaXQgc3Vw
cG9ydHMuDQo+IE9uZSBvZiB0aGVtDQo+IGJlaW5nIHBpbm5lZCBDUnMuDQo+IA0KPiBGb3IgZXhh
bXBsZSwgaXNu4oCZdCB0aGlzIGFsc28gcmVsZXZhbnQgZm9yIElPTU1VIERNQSBwcm90ZWN0aW9u
Pw0KPiBpLmUuIERvZXNu4oCZdCBvbGQga2VybmVsIG5lZWQgdG8ga25vdyBpZiBpdCBzaG91bGQg
ZGlzYWJsZSBvciBlbmFibGUNCj4gSU9NTVUgRE1BUg0KPiBiZWZvcmUga2V4ZWMgdG8gbmV3IGtl
cm5lbD8gU2ltaWxhciB0byBFREsyIElPTU1VIERNQSBwcm90ZWN0aW9uDQo+IGhhbmQtb3Zlcj8N
Cg0KR3JlYXQgaWRlYS4NCg0KTWFraW5nIGtleGVjIHdvcmsgd2lsbCByZXF1aXJlIGNoYW5nZXMg
dG8gdGhlc2UgZmlsZXMgYW5kIG1heWJlIG1vcmU6DQoNCmFyY2gveDg2L2Jvb3QvY29tcHJlc3Nl
ZC9oZWFkXzY0LlMNCmFyY2gveDg2L2tlcm5lbC9oZWFkXzY0LlMNCmFyY2gveDg2L2tlcm5lbC9y
ZWxvY2F0ZV9rZXJuZWxfNjQuUw0KDQpXaGljaCBteSBwcmV2aW91cyBhdHRlbXB0cyBzaG93ZWQg
ZGlmZmVyZW50IHJlc3VsdHMgd2hlbiBydW5uaW5nDQp2aXJ0dWFsaXplZCB2cy4gdW52aXJ0dWFs
aXplZC4gU3BlY2lmaWNpdHkgZGlmZmVyZW50IGJlaGF2aW9yIHdpdGggU01BUA0KYW5kIFVNSVAg
Yml0cy4NCg0KVGhpcyB3b3VsZCBiZSBhIGxvbmdlciBwcm9jZXNzIHRob3VnaC4gQXMgdmFsaWRh
dGluZyB0aGF0IGV2ZXJ5dGhpbmcNCnN0aWxsIHdvcmtzIGluIGJvdGggdGhlIFZNIGFuZCBvbiBw
aHlzaWNhbCBob3N0cyB3aWxsIGJlIHJlcXVpcmVkLiBBcw0KaXQgc3RhbmRzIHRoaXMgcGF0Y2hz
ZXQgY291bGQgcGljayB1cCBhIGZhaXJseSBsYXJnZSB1c2VyYmFzZSB2aWEgdGhlDQp2aXJ0dWFs
aXplZCBjb250YWluZXIgcHJvamVjdHMuIFNob3VsZCB3ZSBwdXJzdWUga2V4ZWMgaW4gdGhpcyBw
YXRjaHNldA0Kb3IgYSBsYXRlciBvbmU/DQoNClRoYW5rcywNCkpvaG4NCg==
