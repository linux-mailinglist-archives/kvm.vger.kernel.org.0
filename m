Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251FBE93F8
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 01:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfJ3ABV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 20:01:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:27850 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfJ3ABU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 20:01:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 17:01:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="399967932"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga005.fm.intel.com with ESMTP; 29 Oct 2019 17:01:19 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 17:01:18 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.185]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.61]) with mapi id 14.03.0439.000;
 Tue, 29 Oct 2019 17:01:18 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "keescook@chromium.org" <keescook@chromium.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Dock, Deneen T" <deneen.t.dock@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kristen@linux.intel.com" <kristen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 13/13] x86/Kconfig: Add Kconfig for KVM based XO
Thread-Topic: [RFC PATCH 13/13] x86/Kconfig: Add Kconfig for KVM based XO
Thread-Index: AQHVejL9bEbssnEvHkaqj3ZlTh7j36dy5EKAgAAHCIA=
Date:   Wed, 30 Oct 2019 00:01:18 +0000
Message-ID: <d645473f01c445a70bc1f2472217f1ae426b7020.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-14-rick.p.edgecombe@intel.com>
         <201910291634.7993D32374@keescook>
In-Reply-To: <201910291634.7993D32374@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD1FDB260C50C14AA22F570A0252BD64@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTI5IGF0IDE2OjM2IC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IFRodSwgT2N0IDAzLCAyMDE5IGF0IDAyOjI0OjAwUE0gLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdy
b3RlOg0KPiA+IEFkZCBDT05GSUdfS1ZNX1hPIGZvciBzdXBwb3J0aW5nIEtWTSBiYXNlZCBleGVj
dXRlIG9ubHkgbWVtb3J5Lg0KPiANCj4gSSB3b3VsZCBleHBlY3QgdGhpcyBjb25maWcgdG8gYmUg
YWRkZWQgZWFybGllciBpbiB0aGUgc2VyaWVzIHNvIHRoYXQgdGhlDQo+IGNvZGUgYmVpbmcgYWRk
ZWQgdGhhdCBkZXBlbmRzIG9uIGl0IGNhbiBiZSBpbmNyZW1lbnRhbGx5IGJ1aWxkIHRlc3RlZC4u
Lg0KPiANCj4gKEFsc28sIGlmIHRoaXMgaXMgZGVmYXVsdD15LCB3aHkgaGF2ZSBhIEtjb25maWcg
Zm9yIGl0IGF0IGFsbD8gR3Vlc3RzDQo+IG5lZWQgdG8ga25vdyB0byB1c2UgdGhpcyBhbHJlYWR5
LCB5ZXM/KQ0KPiANCj4gLUtlZXMNCkhtbSwgZ29vZCBwb2ludC4gT25lIHJlYXNvbiBjb3VsZCBi
ZSB0aGF0IHRoaXMgcmVxdWlyZXMgU1BBUlNFTUVNX1ZNRU1NQVAgZHVlIHRvDQpzb21lIHByZS1w
cm9jZXNzb3IgdHJpY2tzIHRoYXQgbmVlZCBhIGNvbXBpbGUgdGltZSBrbm93biBtYXggcGh5c2lj
YWwgYWRkcmVzcw0Kc2l6ZS4gU28gbWF5YmUgc29tZW9uZSBjb3VsZCB3YW50IEtWTV9HVUVTVCBh
bmQgIVNQQVJTRU1FTV9WTUVNTUFQLiBJJ20gbm90DQpzdXJlLg0KDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+
IC0tLQ0KPiA+ICBhcmNoL3g4Ni9LY29uZmlnIHwgMTMgKysrKysrKysrKysrKw0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9LY29uZmlnIGIvYXJjaC94ODYvS2NvbmZpZw0KPiA+IGluZGV4IDIyMjg1NWNjMDE1OC4u
M2EzYWYyYTQ1NmU4IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L0tjb25maWcNCj4gPiArKysg
Yi9hcmNoL3g4Ni9LY29uZmlnDQo+ID4gQEAgLTgwMiw2ICs4MDIsMTkgQEAgY29uZmlnIEtWTV9H
VUVTVA0KPiA+ICAJICB1bmRlcmx5aW5nIGRldmljZSBtb2RlbCwgdGhlIGhvc3QgcHJvdmlkZXMg
dGhlIGd1ZXN0IHdpdGgNCj4gPiAgCSAgdGltaW5nIGluZnJhc3RydWN0dXJlIHN1Y2ggYXMgdGlt
ZSBvZiBkYXksIGFuZCBzeXN0ZW0gdGltZQ0KPiA+ICANCj4gPiArY29uZmlnIEtWTV9YTw0KPiA+
ICsJYm9vbCAiU3VwcG9ydCBmb3IgS1ZNIGJhc2VkIGV4ZWN1dGUgb25seSB2aXJ0dWFsIG1lbW9y
eSBwZXJtaXNzaW9ucyINCj4gPiArCXNlbGVjdCBEWU5BTUlDX1BIWVNJQ0FMX01BU0sNCj4gPiAr
CXNlbGVjdCBTUEFSU0VNRU1fVk1FTU1BUA0KPiA+ICsJZGVwZW5kcyBvbiBLVk1fR1VFU1QgJiYg
WDg2XzY0DQo+ID4gKwlkZWZhdWx0IHkNCj4gPiArCWhlbHANCj4gPiArCSAgVGhpcyBvcHRpb24g
ZW5hYmxlcyBzdXBwb3J0IGZvciBleGVjdXRlIG9ubHkgbWVtb3J5IGZvciBLVk0gZ3Vlc3RzLiBJ
Zg0KPiA+ICsJICBzdXBwb3J0IGZyb20gdGhlIHVuZGVybHlpbmcgVk1NIGlzIG5vdCBkZXRlY3Rl
ZCBhdCBib290LCB0aGlzDQo+ID4gKwkgIGNhcGFiaWxpdHkgd2lsbCBhdXRvbWF0aWNhbGx5IGRp
c2FibGUuDQo+ID4gKw0KPiA+ICsJICBJZiB5b3UgYXJlIHVuc3VyZSBob3cgdG8gYW5zd2VyIHRo
aXMgcXVlc3Rpb24sIGFuc3dlciBZLg0KPiA+ICsNCj4gPiAgY29uZmlnIFBWSA0KPiA+ICAJYm9v
bCAiU3VwcG9ydCBmb3IgcnVubmluZyBQVkggZ3Vlc3RzIg0KPiA+ICAJLS0taGVscC0tLQ0KPiA+
IC0tIA0KPiA+IDIuMTcuMQ0KPiA+IA0KPiANCj4gDQo=
