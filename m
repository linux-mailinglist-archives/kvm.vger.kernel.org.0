Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858BBCC365
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 21:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbfJDTLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 15:11:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:15007 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbfJDTLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 15:11:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 12:11:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="276138765"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga001.jf.intel.com with ESMTP; 04 Oct 2019 12:11:17 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.161]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.122]) with mapi id 14.03.0439.000;
 Fri, 4 Oct 2019 12:11:17 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>
Subject: Re: [RFC PATCH 05/13] kvm: Add #PF injection for KVM XO
Thread-Topic: [RFC PATCH 05/13] kvm: Add #PF injection for KVM XO
Thread-Index: AQHVejL5QXoQps+l20GC0zWkx4Pul6dKj5AAgADAX4A=
Date:   Fri, 4 Oct 2019 19:11:16 +0000
Message-ID: <99d2bf928d1971e7cacfcfa711e82aeac5186632.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-6-rick.p.edgecombe@intel.com>
         <08e46327-7d98-5c63-58ba-e9a171790c25@redhat.com>
In-Reply-To: <08e46327-7d98-5c63-58ba-e9a171790c25@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF0982DF326E524EADB2242D32673B73@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTA0IGF0IDA5OjQyICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAwMy8xMC8xOSAyMzoyMywgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gKwlpZiAoIXZj
cHUtPmFyY2guZ3ZhX2F2YWlsYWJsZSkNCj4gPiArCQlyZXR1cm4gMDsNCj4gDQo+IFBsZWFzZSBy
ZXR1cm4gUkVUX1BGXyogY29uc3RhbnRzLCBSRVRfUEZfRU1VTEFURSBoZXJlLg0KDQpPay4NCg0K
PiA+ICsJaWYgKGVycm9yX2NvZGUgJiBQRkVSUl9XUklURV9NQVNLKQ0KPiA+ICsJCWZhdWx0X2Vy
cm9yX2NvZGUgfD0gWDg2X1BGX1dSSVRFOw0KPiA+ICsNCj4gPiArCWZhdWx0LnZlY3RvciA9IFBG
X1ZFQ1RPUjsNCj4gPiArCWZhdWx0LmVycm9yX2NvZGVfdmFsaWQgPSB0cnVlOw0KPiA+ICsJZmF1
bHQuZXJyb3JfY29kZSA9IGZhdWx0X2Vycm9yX2NvZGU7DQo+ID4gKwlmYXVsdC5uZXN0ZWRfcGFn
ZV9mYXVsdCA9IGZhbHNlOw0KPiA+ICsJZmF1bHQuYWRkcmVzcyA9IHZjcHUtPmFyY2guZ3ZhX3Zh
bDsNCj4gPiArCWZhdWx0LmFzeW5jX3BhZ2VfZmF1bHQgPSB0cnVlOw0KPiANCj4gTm90IGFuIGFz
eW5jIHBhZ2UgZmF1bHQuDQoNClJpZ2h0Lg0KDQo+ID4gKwlrdm1faW5qZWN0X3BhZ2VfZmF1bHQo
dmNwdSwgJmZhdWx0KTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMTsNCj4gDQo+IEhlcmUgeW91IHdv
dWxkIHJldHVybiBSRVRfUEZfUkVUUlkgLSB5b3UndmUgaW5qZWN0ZWQgdGhlIHBhZ2UgZmF1bHQg
YW5kDQo+IGFsbCB0aGF0J3MgbGVmdCB0byBkbyBpcyByZWVudGVyIGV4ZWN1dGlvbiBvZiB0aGUg
dkNQVS4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICsJaWYgKHVubGlrZWx5KHZjcHUtPmFyY2gueG9f
ZmF1bHQpKSB7DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBJZiBub3QgZW5vdWdoIGluZm9ybWF0aW9u
IHRvIGluamVjdCB0aGUgZmF1bHQsDQo+ID4gKwkJICogZW11bGF0ZSB0byBmaWd1cmUgaXQgb3V0
IGFuZCBlbXVsYXRlIHRoZSBQRi4NCj4gPiArCQkgKi8NCj4gPiArCQlpZiAoIXRyeV9pbmplY3Rf
ZXhlY19vbmx5X3BmKHZjcHUsIGVycm9yX2NvZGUpKQ0KPiA+ICsJCQlyZXR1cm4gUkVUX1BGX0VN
VUxBVEU7DQo+ID4gKw0KPiA+ICsJCXJldHVybiAxOw0KPiA+ICsJfQ0KPiANCj4gUmV0dXJuaW5n
IDEgaXMgd3JvbmcsIGl0J3MgYWxzbyBSRVRfUEZfRU1VTEFURS4gIElmIHlvdSBjaGFuZ2UNCj4g
dHJ5X2luamVjdF9leGVjX29ubHlfcGYgcmV0dXJuIHZhbHVlcyB0byBSRVRfUEZfKiwgeW91IGNh
biBzaW1wbHkgcmV0dXJuDQo+IHRoZSB2YWx1ZSBvZiB0cnlfaW5qZWN0X2V4ZWNfb25seV9wZih2
Y3B1LCBlcnJvcl9jb2RlKS4NCg0KT2ggcmlnaHQhIEkgbXVzdCBoYXZlIGJyb2tlbiB0aGlzIGF0
IHNvbWUgcG9pbnQuIFRoYW5rcy4gDQoNCj4gVGhhdCBzYWlkLCBJIHdvbmRlciBpZiBpdCdzIGJl
dHRlciB0byBqdXN0IGhhbmRsZSB0aGlzIGluDQo+IGhhbmRsZV9lcHRfdmlvbGF0aW9uLiAgQmFz
aWNhbGx5LCBpZiBiaXRzIDU6MyBvZiB0aGUgZXhpdCBxdWFsaWZpY2F0aW9uDQo+IGFyZSAxMDAg
eW91IGNhbiBieXBhc3MgdGhlIHdob2xlIG1tdS5jIHBhZ2UgZmF1bHQgaGFuZGxpbmcgYW5kIGp1
c3QNCj4gaW5qZWN0IGFuIGV4ZWMtb25seSBwYWdlIGZhdWx0Lg0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gUGFvbG8NCg0KSG1tLCB0aGF0IGNvdWxkIGJlIGNsZWFuZXIuIEknbGwgc2VlIGhvdyBpdCBm
aXRzIHRvZ2V0aGVyIHdoZW4gSSBmaXggdGhlIG5lc3RlZA0KY2FzZSwgc2luY2Ugc29tZSBvZiB0
aGF0IGxvZ2ljIGxvb2tzIHRvIGJlIGluIG1tdS5jLg0KDQpUaGFua3MsDQoNClJpY2sNCg==
