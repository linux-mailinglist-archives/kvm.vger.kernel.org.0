Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCF3553F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 04:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFEC1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 22:27:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:64377 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfFEC1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 22:27:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 19:27:46 -0700
X-ExtLoop1: 1
Received: from pgsmsx104.gar.corp.intel.com ([10.221.44.91])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2019 19:27:44 -0700
Received: from pgsmsx112.gar.corp.intel.com ([169.254.3.55]) by
 PGSMSX104.gar.corp.intel.com ([169.254.3.63]) with mapi id 14.03.0415.000;
 Wed, 5 Jun 2019 10:27:43 +0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "junaids@google.com" <junaids@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
Thread-Topic: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
Thread-Index: AQHVAYvtFSKB7z3SMUSGq8P45jsnbqZsPb4AgB/FIoA=
Date:   Wed, 5 Jun 2019 02:27:21 +0000
Message-ID: <1559701571.9892.2.camel@intel.com>
References: <20190503084025.24549-1-kai.huang@linux.intel.com>
         <b3bca1c1-ed7d-6027-1e91-12b6a243c2c7@redhat.com>
In-Reply-To: <b3bca1c1-ed7d-6027-1e91-12b6a243c2c7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.180.153]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AADE519BCBD814A9EC0F1FF4074D66B@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTE1IGF0IDIzOjE2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwMy8wNS8xOSAxMDo0MCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IEN1cnJlbnRseSBLVk0g
c2V0cyA1IG1vc3Qgc2lnbmlmaWNhbnQgYml0cyBvZiBwaHlzaWNhbCBhZGRyZXNzIGJpdHMNCj4g
PiByZXBvcnRlZCBieSBDUFVJRCAoYm9vdF9jcHVfZGF0YS54ODZfcGh5c19iaXRzKSBmb3Igbm9u
cHJlc2VudCBvcg0KPiA+IHJlc2VydmVkIGJpdHMgU1BURSB0byBtaXRpZ2F0ZSBMMVRGIGF0dGFj
ayBmcm9tIGd1ZXN0IHdoZW4gdXNpbmcgc2hhZG93DQo+ID4gTU1VLiBIb3dldmVyIGZvciBzb21l
IHBhcnRpY3VsYXIgSW50ZWwgQ1BVcyB0aGUgcGh5c2ljYWwgYWRkcmVzcyBiaXRzDQo+ID4gb2Yg
aW50ZXJuYWwgY2FjaGUgaXMgZ3JlYXRlciB0aGFuIHBoeXNpY2FsIGFkZHJlc3MgYml0cyByZXBv
cnRlZCBieQ0KPiA+IENQVUlELg0KPiA+IA0KPiA+IFVzZSB0aGUga2VybmVsJ3MgZXhpc3Rpbmcg
Ym9vdF9jcHVfZGF0YS54ODZfY2FjaGVfYml0cyB0byBkZXRlcm1pbmUgdGhlDQo+ID4gZml2ZSBt
b3N0IHNpZ25pZmljYW50IGJpdHMuIERvaW5nIHNvIGltcHJvdmVzIEtWTSdzIEwxVEYgbWl0aWdh
dGlvbiBpbg0KPiA+IHRoZSB1bmxpa2VseSBzY2VuYXJpbyB0aGF0IHN5c3RlbSBSQU0gb3Zlcmxh
cHMgdGhlIGhpZ2ggb3JkZXIgYml0cyBvZg0KPiA+IHRoZSAicmVhbCIgcGh5c2ljYWwgYWRkcmVz
cyBzcGFjZSBhcyByZXBvcnRlZCBieSBDUFVJRC4gVGhpcyBhbGlnbnMgd2l0aA0KPiA+IHRoZSBr
ZXJuZWwncyB3YXJuaW5ncyByZWdhcmRpbmcgTDFURiBtaXRpZ2F0aW9uLCBlLmcuIGluIHRoZSBh
Ym92ZQ0KPiA+IHNjZW5hcmlvIHRoZSBrZXJuZWwgd29uJ3Qgd2FybiB0aGUgdXNlciBhYm91dCBs
YWNrIG9mIEwxVEYgbWl0aWdhdGlvbg0KPiA+IGlmIHg4Nl9jYWNoZV9iaXRzIGlzIGdyZWF0ZXIg
dGhhbiB4ODZfcGh5c19iaXRzLg0KPiA+IA0KPiA+IEFsc28gaW5pdGlhbGl6ZSBzaGFkb3dfbm9u
cHJlc2VudF9vcl9yc3ZkX21hc2sgZXhwbGljaXRseSB0byBtYWtlIGl0DQo+ID4gY29uc2lzdGVu
dCB3aXRoIG90aGVyICdzaGFkb3dfe3h4eH1fbWFzaycsIGFuZCBvcHBvcnR1bmlzdGljYWxseSBh
ZGQgYQ0KPiA+IFdBUk4gb25jZSBpZiBLVk0ncyBMMVRGIG1pdGlnYXRpb24gY2Fubm90IGJlIGFw
cGxpZWQgb24gYSBzeXN0ZW0gdGhhdA0KPiA+IGlzIG1hcmtlZCBhcyBiZWluZyBzdXNjZXB0aWJs
ZSB0byBMMVRGLg0KPiA+IA0KPiA+IFJldmlld2VkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGxpbnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiANCj4gPiBUaGlz
IHBhdGNoIHdhcyBzcGxpdHRlZCBmcm9tIG9sZCBwYXRjaCBJIHNlbnQgb3V0IGFyb3VuZCAyIHdl
ZWtzIGFnbzoNCj4gPiANCj4gPiBrdm06IHg4NjogRml4IHNldmVyYWwgU1BURSBtYXNrIGNhbGN1
bGF0aW9uIGVycm9ycyBjYXVzZWQgYnkgTUtUTUUNCj4gPiANCj4gPiBBZnRlciByZXZpZXdpbmcg
d2l0aCBTZWFuIENocmlzdG9waGVyc29uIGl0J3MgYmV0dGVyIHRvIHNwbGl0IHRoaXMgb3V0LA0K
PiA+IHNpbmNlIHRoZSBsb2dpYyBpbiB0aGlzIHBhdGNoIGlzIGluZGVwZW5kZW50LiBBbmQgbWF5
YmUgdGhpcyBwYXRjaCBzaG91bGQNCj4gPiBhbHNvIGJlIGludG8gc3RhYmxlLg0KPiA+IA0KPiA+
IC0tLQ0KPiA+ICBhcmNoL3g4Ni9rdm0vbW11LmMgfCAxOCArKysrKysrKysrKysrLS0tLS0NCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4g
DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUu
Yw0KPiA+IGluZGV4IGIwODk5ZjE3NWRiOS4uMWIyMzgwZTAwNjBmIDEwMDY0NA0KPiA+IC0tLSBh
L2FyY2gveDg2L2t2bS9tbXUuYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUuYw0KPiA+IEBA
IC01MTEsMTYgKzUxMSwyNCBAQCBzdGF0aWMgdm9pZCBrdm1fbW11X3Jlc2V0X2FsbF9wdGVfbWFz
a3Modm9pZCkNCj4gPiAgCSAqIElmIHRoZSBDUFUgaGFzIDQ2IG9yIGxlc3MgcGh5c2ljYWwgYWRk
cmVzcyBiaXRzLCB0aGVuIHNldCBhbg0KPiA+ICAJICogYXBwcm9wcmlhdGUgbWFzayB0byBndWFy
ZCBhZ2FpbnN0IEwxVEYgYXR0YWNrcy4gT3RoZXJ3aXNlLCBpdCBpcw0KPiA+ICAJICogYXNzdW1l
ZCB0aGF0IHRoZSBDUFUgaXMgbm90IHZ1bG5lcmFibGUgdG8gTDFURi4NCj4gPiArCSAqDQo+ID4g
KwkgKiBTb21lIEludGVsIENQVXMgYWRkcmVzcyB0aGUgTDEgY2FjaGUgdXNpbmcgbW9yZSBQQSBi
aXRzIHRoYW4gYXJlDQo+ID4gKwkgKiByZXBvcnRlZCBieSBDUFVJRC4gVXNlIHRoZSBQQSB3aWR0
aCBvZiB0aGUgTDEgY2FjaGUgd2hlbiBwb3NzaWJsZQ0KPiA+ICsJICogdG8gYWNoaWV2ZSBtb3Jl
IGVmZmVjdGl2ZSBtaXRpZ2F0aW9uLCBlLmcuIGlmIHN5c3RlbSBSQU0gb3ZlcmxhcHMNCj4gPiAr
CSAqIHRoZSBtb3N0IHNpZ25pZmljYW50IGJpdHMgb2YgbGVnYWwgcGh5c2ljYWwgYWRkcmVzcyBz
cGFjZS4NCj4gPiAgCSAqLw0KPiA+IC0JbG93X3BoeXNfYml0cyA9IGJvb3RfY3B1X2RhdGEueDg2
X3BoeXNfYml0czsNCj4gPiAtCWlmIChib290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHMgPA0KPiA+
ICsJc2hhZG93X25vbnByZXNlbnRfb3JfcnN2ZF9tYXNrID0gMDsNCj4gPiArCWxvd19waHlzX2Jp
dHMgPSBib290X2NwdV9kYXRhLng4Nl9jYWNoZV9iaXRzOw0KPiA+ICsJaWYgKGJvb3RfY3B1X2Rh
dGEueDg2X2NhY2hlX2JpdHMgPA0KPiA+ICAJICAgIDUyIC0gc2hhZG93X25vbnByZXNlbnRfb3Jf
cnN2ZF9tYXNrX2xlbikgew0KPiA+ICAJCXNoYWRvd19ub25wcmVzZW50X29yX3JzdmRfbWFzayA9
DQo+ID4gLQkJCXJzdmRfYml0cyhib290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHMgLQ0KPiA+ICsJ
CQlyc3ZkX2JpdHMoYm9vdF9jcHVfZGF0YS54ODZfY2FjaGVfYml0cyAtDQo+ID4gIAkJCQkgIHNo
YWRvd19ub25wcmVzZW50X29yX3JzdmRfbWFza19sZW4sDQo+ID4gLQkJCQkgIGJvb3RfY3B1X2Rh
dGEueDg2X3BoeXNfYml0cyAtIDEpOw0KPiA+ICsJCQkJICBib290X2NwdV9kYXRhLng4Nl9jYWNo
ZV9iaXRzIC0gMSk7DQo+ID4gIAkJbG93X3BoeXNfYml0cyAtPSBzaGFkb3dfbm9ucHJlc2VudF9v
cl9yc3ZkX21hc2tfbGVuOw0KPiA+IC0JfQ0KPiA+ICsJfSBlbHNlDQo+ID4gKwkJV0FSTl9PTl9P
TkNFKGJvb3RfY3B1X2hhc19idWcoWDg2X0JVR19MMVRGKSk7DQo+ID4gKw0KPiA+ICAJc2hhZG93
X25vbnByZXNlbnRfb3JfcnN2ZF9sb3dlcl9nZm5fbWFzayA9DQo+ID4gIAkJR0VOTUFTS19VTEwo
bG93X3BoeXNfYml0cyAtIDEsIFBBR0VfU0hJRlQpOw0KPiA+ICB9DQo+ID4gDQo+IA0KPiBRdWV1
ZWQsIHRoYW5rcy4NCg0KSGkgUGFvbG8sDQoNClRoYW5rcyBmb3IgdGFraW5nIHRoZSBwYXRjaC4g
SSBhbSBub3QgcXVpdGUgc3VyZSBidXQgbWF5YmUgdGhpcyBwYXRjaCBzaG91bGQgYWxzbyBnbyBp
bnRvIHN0YWJsZT8NCg0KU2VhbiwgZG8geW91IGhhdmUgY29tbWVudHM/DQoNClRoYW5rcywNCi1L
YWkNCj4gDQo+IFBhb2xv
