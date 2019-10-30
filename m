Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D60BEA516
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 22:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfJ3VCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 17:02:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:12375 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbfJ3VCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 17:02:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 14:02:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,248,1569308400"; 
   d="scan'208";a="203312286"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga003.jf.intel.com with ESMTP; 30 Oct 2019 14:02:04 -0700
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 30 Oct 2019 14:02:04 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.185]) by
 ORSMSX113.amr.corp.intel.com ([169.254.9.28]) with mapi id 14.03.0439.000;
 Wed, 30 Oct 2019 14:02:03 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Thread-Topic: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Thread-Index: AQHVejL7mBDeeBJOYUiqz0B6Xhz7/Kdy452AgAAFHYCAAPxSAIAAZnyA
Date:   Wed, 30 Oct 2019 21:02:02 +0000
Message-ID: <217403c0f9790c1142b51231d5b4ccfd6d83cf61.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-10-rick.p.edgecombe@intel.com>
         <201910291633.927254B10@keescook>
         <40cb4ea3b351c25074cf47ae92a189eec12161fb.camel@intel.com>
         <20191030145520.GA14391@linux.intel.com>
In-Reply-To: <20191030145520.GA14391@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <68AFE186A011404BBA6BFA697DF6A0BD@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTMwIGF0IDA3OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE9jdCAyOSwgMjAxOSBhdCAwNDo1MjowOFBNIC0wNzAwLCBFZGdlY29t
YmUsIFJpY2sgUCB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMTktMTAtMjkgYXQgMTY6MzMgLTA3MDAs
IEtlZXMgQ29vayB3cm90ZToNCj4gPiA+IE9uIFRodSwgT2N0IDAzLCAyMDE5IGF0IDAyOjIzOjU2
UE0gLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+ID4gPiBBZGQgYSBuZXcgQ1BVSUQg
bGVhZiB0byBob2xkIHRoZSBjb250ZW50cyBvZiBDUFVJRCAweDQwMDAwMDMwIEVBWCB0bw0KPiA+
ID4gPiBkZXRlY3QgS1ZNIGRlZmluZWQgZ2VuZXJpYyBWTU0gZmVhdHVyZXMuDQo+ID4gPiA+IA0K
PiA+ID4gPiBUaGUgbGVhZiB3YXMgcHJvcG9zZWQgdG8gYWxsb3cgS1ZNIHRvIGNvbW11bmljYXRl
IGZlYXR1cmVzIHRoYXQgYXJlDQo+ID4gPiA+IGRlZmluZWQgYnkgS1ZNLCBidXQgYXZhaWxhYmxl
IGZvciBhbnkgVk1NIHRvIGltcGxlbWVudC4NCj4gDQo+IFRoaXMgZG9lc24ndCBuZWNlc3Nhcmls
eSB3b3JrIHRoZSB3YXkgeW91IGludGVuZCwgS1ZNJ3MgYmFzZSBDUFVJRCBpc24ndA0KPiBndWFy
YW50ZWVkIHRvIGJlIDB4NDAwMDAwMDAuICBFLmcuIEtWTSBzdXBwb3J0cyBhZHZlcnRpc2luZyBp
dHNlbGYgYXMNCj4gSHlwZXJWICphbmQqIEtWTSwgaW4gd2hpY2ggY2FzZSBLVk0ncyBDUFVJRCBi
YXNlIHdpbGwgYmUgMHg0MDAwMDEwMC4NCj4gDQo+IEkgdGhpbmsgeW91J3JlIGJldHRlciBvZmYg
anVzdCBtYWtpbmcgdGhpcyBhIHN0YW5kYXJkIEtWTSBDUFVJRCBmZWF0dXJlLg0KPiBJZiBhIGRp
ZmZlcmVudCBoeXBlcnZpc29yIHdhbnRzIHRvIHJldXNlIGd1ZXN0IHN1cHBvcnQgYXMgaXMsIGl0
IGNhbg0KPiBhZHZlcnRpc2UgS1ZNIHN1cHBvcnQgYXQgYSBsb3dlciBwcmlvcml0eS4NCj4gDQpP
aywgSSdtIGZpbmUgZ29pbmcgd2l0aCB0aGUgc2ltcGxlciBLVk0gQ1BVSUQgYml0LiBJdCdzIG5v
dCBsaWtlIHBlci1WTU0gQ1BVSUQNCmxlYWYgbWVhbmluZ3MgYXJlIGEgbmV3IHNjZW5hcmlvIHdp
dGggdGhpcy4NCg0KPiBOb3RlLCBxdWVyeWluZyBndWVzdCBDUFVJRCBpc24ndCBzdHJhaWdodGZv
cndhcmQgaW4gZWl0aGVyIGNhc2UuICBCdXQsDQo+IEtWTSBkb2Vzbid0IHN1cHBvcnQgZGlzYWJs
aW5nIGl0cyBvdGhlciBDUFVJRC1iYXNlIHBhcmF2aXJ0IGZlYXR1cmVzLCBlLmcuDQo+IEtWTSBl
bXVsYXRlcyB0aGUga3ZtX2Nsb2NrIE1TUnMgcmVnYXJkbGVzcyBvZiB3aGF0IHVzZXJzcGFjZSBh
ZHZlcnRpc2VzIHRvDQo+IHRoZSBndWVzdC4gIERlcGVuZGluZyBvbiB3aGF0IGNoYW5nZXMgYXJl
IHJlcXVpcmVkIGluIEtWTSdzIE1NVSwgdGhpcyBtYXkNCj4gYWxzbyBuZWVkIHRvIGJlIGEgS1ZN
LXdpZGUgZmVhdHVyZSwgaS5lLiBjb250cm9sbGVkIHZpYSBhIG1vZHVsZSBwYXJhbS4NCj4gPiA+
ID4gQWRkIGNwdV9mZWF0dXJlX2VuYWJsZWQoKSBzdXBwb3J0IGZvciBmZWF0dXJlcyBpbiB0aGlz
IGxlYWYgKEtWTSBYTyksDQo+ID4gPiA+IGFuZA0KPiA+ID4gPiBhIHBndGFibGVfa3ZteG9fZW5h
YmxlZCgpIGhlbHBlciBzaW1pbGFyIHRvIHBndGFibGVfbDVfZW5hYmxlZCgpIHNvIHRoYXQNCj4g
PiA+ID4gcGd0YWJsZV9rdm14b19lbmFibGVkKCkgY2FuIGJlIHVzZWQgaW4gZWFybHkgY29kZSB0
aGF0IGluY2x1ZGVzDQo+ID4gPiA+IGFyY2gveDg2L2luY2x1ZGUvYXNtL3NwYXJzZW1lbS5oLg0K
PiA+ID4gPiANCj4gPiA+ID4gTGFzdGx5LCBpbiBoZWFkNjQuYyBkZXRlY3QgYW5kIHRoaXMgZmVh
dHVyZSBhbmQgcGVyZm9ybSBuZWNlc3NhcnkNCj4gPiA+ID4gYWRqdXN0bWVudHMgdG8gcGh5c2lj
YWxfbWFzay4NCj4gPiA+IA0KPiA+ID4gQ2FuIHRoaXMgYmUgZXhwb3NlZCB0byAvcHJvYy9jcHVp
bmZvIHNvIGEgZ3Vlc3QgdXNlcnNwYWNlIGNhbiBkZXRlcm1pbmUNCj4gPiA+IGlmIHRoaXMgZmVh
dHVyZSBpcyBlbmFibGVkPw0KPiA+ID4gDQo+ID4gPiAtS2Vlcw0KPiA+IA0KPiA+IElzIHRoZXJl
IGEgZ29vZCBwbGFjZSB0byBleHBvc2UgdGhlIGluZm9ybWF0aW9uIHRoYXQgdGhlIFBST1RfRVhF
QyBhbmQNCj4gPiAhUFJPVF9SRUFEIGNvbWJvIGNyZWF0ZXMgZXhlY3V0ZS1vbmx5IG1lbW9yeT8g
VGhpcyB3YXkgYXBwcyBjYW4gY2hlY2sgb25lDQo+ID4gcGxhY2UNCj4gPiBmb3IgdGhlIHN1cHBv
cnQgYW5kIG5vdCB3b3JyeSBhYm91dCB0aGUgaW1wbGVtZW50YXRpb24gd2hldGhlciBpdCdzIHRo
aXMsDQo+ID4geDg2DQo+ID4gcGtleXMsIGFybSBvciBvdGhlci4NCj4gDQo+IEkgZG9uJ3QgdGhp
bmsgc28/ICBBc3N1bWluZyB0aGVyZSdzIG5vIGNvbW1vbiBtZXRob2QsIGl0IGNhbiBiZSBkaXNw
bGF5ZWQNCj4gaW4gL3Byb2MvY3B1aW5mbyBieSBhZGRpbmcgYSBzeW50aGV0aWMgYml0LCBlLmcu
IGluIExpbnV4LWRlZmluZWQgd29yZCA4DQo+ICh2aXJ0dWFsaXphdGlvbikgaW5zdGVhZCBvZiBh
IGRlZGljYXRlZCB3b3JkLiAgVGhlIGJpdCBjYW4gdGhlbiBiZQ0KPiBzZXQgaWYgdGhlIGZlYXR1
cmVzIGV4aXN0cyBhbmQgaXMgZW5hYmxlZCAoYnkgdGhlIGd1ZXN0KS4NCj4gDQo+IEknZCBhbHNv
IG5hbWUgdGhlIGZlYXR1cmUgRVhFQ19PTkxZLiAgWE8gaXMgdW5uZWNlc3NhcmlseSB0ZXJzZSBJ
TU8sIGFuZA0KPiBpbmNsdWRpbmcgIktWTSIgaW4gdGhlIG5hbWUgbWF5IGJlIG1pc2NvbnN0cnVl
ZCBhcyBhIGhvc3QgS1ZNIGZlYXR1cmUgYW5kDQo+IHdpbGwgYmUgZmxhdCBvdXQgd3JvbmcgaWYg
aGFyZHdhcmUgZXZlciBzdXBwb3J0cyBYTyBuYXRpdmVseS4NCg0KT2ssIGlmIHRoZXJlIGlzIG5v
IGdlbmVyaWMgd2F5IEkgZ3Vlc3MgSSdsbCBkbyB0aGlzLg0KDQoNCg==
