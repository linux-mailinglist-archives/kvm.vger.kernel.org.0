Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F3ED69A7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbfJNSpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 14:45:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:8684 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730804AbfJNSpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 14:45:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 11:45:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="225162739"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga002.fm.intel.com with ESMTP; 14 Oct 2019 11:45:01 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 14 Oct 2019 11:45:00 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.185]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.36]) with mapi id 14.03.0439.000;
 Mon, 14 Oct 2019 11:45:00 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 01/13] kvm: Enable MTRR to work with GFNs with perm
 bits
Thread-Topic: [RFC PATCH 01/13] kvm: Enable MTRR to work with GFNs with perm
 bits
Thread-Index: AQHVejL3uoCiqaF6pUaanOPZUzUKB6daN42AgADIXoA=
Date:   Mon, 14 Oct 2019 18:44:59 +0000
Message-ID: <02ebf82ab08e3e77e7f743b45feb0962a570ee41.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-2-rick.p.edgecombe@intel.com>
         <20191014064753.xv365y6oowmh6ho7@linux.intel.com>
In-Reply-To: <20191014064753.xv365y6oowmh6ho7@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A96575C472D10A4089010B79AC046112@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDE5LTEwLTE0IGF0IDE0OjQ3ICswODAwLCBZdSBaaGFuZyB3cm90ZToNCj4gT24g
VGh1LCBPY3QgMDMsIDIwMTkgYXQgMDI6MjM6NDhQTSAtMDcwMCwgUmljayBFZGdlY29tYmUgd3Jv
dGU6DQo+ID4gTWFzayBnZm4gYnkgbWF4cGh5YWRkciBpbiBrdm1fbXRycl9nZXRfZ3Vlc3RfbWVt
b3J5X3R5cGUgc28gdGhhdCB0aGUNCj4gPiBndWVzdHMgdmlldyBvZiBnZm4gaXMgdXNlZCB3aGVu
IGhpZ2ggYml0cyBvZiB0aGUgcGh5c2ljYWwgbWVtb3J5IGFyZQ0KPiA+IHVzZWQgYXMgZXh0cmEg
cGVybWlzc2lvbnMgYml0cy4gVGhpcyBzdXBwb3J0cyB0aGUgS1ZNIFhPIGZlYXR1cmUuDQo+ID4g
DQo+ID4gVE9ETzogU2luY2UgTVRSUiBpcyBlbXVsYXRlZCB1c2luZyBFUFQgcGVybWlzc2lvbnMs
IHRoZSBYTyB2ZXJzaW9uIG9mDQo+ID4gdGhlIGdwYSByYW5nZSB3aWxsIG5vdCBpbmhlcnJpdCB0
aGUgTVRSUiB0eXBlIHdpdGggdGhpcyBpbXBsZW1lbnRhdGlvbi4NCj4gPiBUaGVyZSBzaG91bGRu
J3QgYmUgYW55IGxlZ2FjeSB1c2Ugb2YgS1ZNIFhPLCBidXQgaHlwb3RoZXRpY2FsbHkgaXQgY291
bGQNCj4gPiBpbnRlcmZlcmUgd2l0aCB0aGUgdW5jYWNoZWFibGUgTVRSUiB0eXBlLg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVs
LmNvbT4NCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYva3ZtL210cnIuYyB8IDggKysrKysrKysNCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rdm0vbXRyci5jIGIvYXJjaC94ODYva3ZtL210cnIuYw0KPiA+IGluZGV4IDI1
Y2UzZWRkMTg3Mi4uZGEzOGYzYjgzZTUxIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS9t
dHJyLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+ID4gQEAgLTYyMSw2ICs2MjEs
MTQgQEAgdTgga3ZtX210cnJfZ2V0X2d1ZXN0X21lbW9yeV90eXBlKHN0cnVjdCBrdm1fdmNwdQ0K
PiA+ICp2Y3B1LCBnZm5fdCBnZm4pDQo+ID4gIAljb25zdCBpbnQgd3Rfd2JfbWFzayA9ICgxIDw8
IE1UUlJfVFlQRV9XUkJBQ0spDQo+ID4gIAkJCSAgICAgICB8ICgxIDw8IE1UUlJfVFlQRV9XUlRI
Uk9VR0gpOw0KPiA+ICANCj4gPiArCS8qDQo+ID4gKwkgKiBIYW5kbGUgc2l0dWF0aW9ucyB3aGVy
ZSBnZm4gYml0cyBhcmUgdXNlZCBhcyBwZXJtaXNzaW9ucyBiaXRzIGJ5DQo+ID4gKwkgKiBtYXNr
aW5nIEtWTXMgdmlldyBvZiB0aGUgZ2ZuIHdpdGggdGhlIGd1ZXN0cyBwaHlzaWNhbCBhZGRyZXNz
IGJpdHMNCj4gPiArCSAqIGluIG9yZGVyIHRvIG1hdGNoIHRoZSBndWVzdHMgdmlldyBvZiBwaHlz
aWNhbCBhZGRyZXNzLiBGb3Igbm9ybWFsDQo+ID4gKwkgKiBzaXR1YXRpb25zIHRoaXMgd2lsbCBo
YXZlIG5vIGVmZmVjdC4NCj4gPiArCSAqLw0KPiA+ICsJZ2ZuICY9ICgxVUxMIDw8IChjcHVpZF9t
YXhwaHlhZGRyKHZjcHUpIC0gUEFHRV9TSElGVCkpOw0KPiA+ICsNCj4gDQo+IFdvbid0IHRoaXMg
YnJlYWsgdGhlIE1UUlIgY2FsY3VsYXRpb24gZm9yIG5vcm1hbCBnZm5zPw0KPiBBcmUgeW91IHN1
Z2dlc3RpbmcgdXNlIHRoZSBzYW1lIE1UUlIgdmFsdWUgZm9yIHRoZSBYTyByYW5nZSBhcyB0aGUg
bm9ybWFsDQo+IG9uZSdzPw0KPiBJZiBzbywgbWF5IGJlIHdlIHNob3VsZCB1c2U6DQo+IA0KPiAJ
aWYgKGd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9LVk1fWE8pKQ0KPiAJCWdmbiAm
PSB+KDFVTEwgPDwgKGNwdWlkX21heHBoeWFkZHIodmNwdSkgLSBQQUdFX1NISUZUKSk7DQo+IA0K
WWVzIHlvdSdyZSByaWdodCB0aGlzIGlzIGJyb2tlbiwgYnV0IHplcm9pbmcgYSBiaXQgYmV5b25k
IHRoZSBtYXggcGh5c2ljYWwNCmFkZHJlc3MgYWRkcmVzcyBzaG91bGQgYmUgb2sgaGVyZSBJIHRo
aW5rLCBzbyB5b3Ugc2hvdWxkbid0IG5lZWQgdGhlIGZlYXR1cmUNCmNoZWNrLg0KDQpJbiBhbnkg
Y2FzZSwgdGhpcyBsb2dpYyB3aWxsIGdvIGF3YXkgYW55d2F5IGFmdGVyIHRoZSBzdWdnZXN0aW9u
cyB0byBtYXNrIHRoZQ0KR1BBIHNvb24gYWZ0ZXIgdGhlIGV4aXQuIFRoZW4gbW9zdCBvZiBLVk0g
Y2FuIGp1c3Qgb3BlcmF0ZSBvbiB0aGUgZ3Vlc3QgdmlldyBvZg0KdGhlIEdQQSBhcyBub3JtYWwu
DQoNCkRlc2lnbiB3aXNlLCBJIHRoaW5rIE1UUlIgc2hvdWxkIGFmZmVjdCB0aGUgWE8gR1BBJ3Mg
YXMgd2VsbCBiZWNhdXNlIGlmIHdlIGFyZQ0KZ29pbmcgdG8gcHJldGVuZCB0aGUgWE8gYml0IGlz
IG5vdCBhIFBGTiBiaXQsIHRoYXQgd291bGQgYmUgZXhwZWN0ZWQuIEkgYW0gbm90DQpzdXJlIGlm
IGl0IHdvdWxkIGFjdHVhbGx5IGJyZWFrIGFueXRoaW5nIHRob3VnaCB1bmxlc3Mgc29tZW9uZSBk
aWQgdW5jYWNoZWFibGUNClhPLCBzbyB0aGF0IGNvdWxkIG1heWJlIGFsc28ganVzdCBiZSBkZWNs
YXJlZCBpbGxlZ2FsLg0KDQo+ID4gIAlzdGFydCA9IGdmbl90b19ncGEoZ2ZuKTsNCj4gPiAgCWVu
ZCA9IHN0YXJ0ICsgUEFHRV9TSVpFOw0KPiA+ICANCj4gPiAtLSANCj4gPiAyLjE3LjENCj4gPiAN
Cj4gDQo+IEIuUi4NCj4gWXUNCg==
