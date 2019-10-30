Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D190DE941B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfJ3A1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 20:27:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:57787 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfJ3A1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 20:27:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 17:27:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="401334116"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2019 17:27:40 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.185]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.115]) with mapi id 14.03.0439.000;
 Tue, 29 Oct 2019 17:27:39 -0700
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
Subject: Re: [RFC PATCH 00/13] XOM for KVM guest userspace
Thread-Topic: [RFC PATCH 00/13] XOM for KVM guest userspace
Thread-Index: AQHVejL3BY31w2dp/kGOlEfaBbHp/ady5Y2AgAANGQA=
Date:   Wed, 30 Oct 2019 00:27:39 +0000
Message-ID: <61e4e48b7986d889eeee80e6374834064049443c.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <201910291639.3C2631C@keescook>
In-Reply-To: <201910291639.3C2631C@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D90DE4474DAEC3418242F465E382D5AD@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTI5IGF0IDE2OjQwIC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IFRodSwgT2N0IDAzLCAyMDE5IGF0IDAyOjIzOjQ3UE0gLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdy
b3RlOg0KPiA+IGxhcmdlciBmb2xsb3cgb24gdG8gdGhpcyBlbmFibGVzIHNldHRpbmcgdGhlIGtl
cm5lbCB0ZXh0IGFzIFhPLCBidXQgdGhpcyBpcw0KPiA+IGp1c3QNCj4gDQo+IElzIHRoZSBrZXJu
ZWwgc2lkZSBzZXJpZXMgdmlzaWJsZSBzb21ld2hlcmUgcHVibGljIHlldD8NCj4gDQpUaGUgUE9D
IGZyb20gbXkgUGx1bWJlcidzIHRhbGsgaXMgdXAgaGVyZToNCmh0dHBzOi8vZ2l0aHViLmNvbS9y
ZWRnZWNvbWJlL2xpbnV4L2NvbW1pdHMvZXhlY19vbmx5DQoNCkl0IGRvZXNuJ3Qgd29yayB3aXRo
IHRoaXMgS1ZNIHNlcmllcyB0aG91Z2ggYXMgSSBtYWRlIGNoYW5nZXMgb24gdGhlIEtWTSBzaWRl
LiBJDQpkb24ndCBjb25zaWRlciBpdCByZWFkeSBmb3IgcG9zdGluZyBvbiB0aGUgbGlzdCB5ZXQu
IEx1Y2tpbHkgdGhvdWdoLCBQZXRlcloncw0Kc3dpdGNoaW5nIG9mIGZ0cmFjZSB0byB0ZXh0X3Bv
a2UoKSwgYW5kIHlvdXIgZXhjZXB0aW9uIHRhYmxlIHBhdGNoc2V0IHdpbGwgbWFrZQ0KaXQgZWFz
aWVyIHdoZW4gdGhlIHRpbWUgY29tZXMuDQoNClJpZ2h0IG5vdyBJIGFtIHJlLWRvaW5nIHRoZSBL
Vk0gcGllY2VzIHRvIGdldCByaWQgb2YgdGhlIG1lbXNsb3QgZHVwbGljYXRpb24uIEkNCmFtIGVu
ZGluZyB1cCBoYXZpbmcgdG8gdG91Y2ggYSBsb3QgbW9yZSBLVk0gbW11IGNvZGUsIGFuZCBpdCdz
IHRha2VuIHNvbWUgdGltZQ0KdG8gd29yayB0aHJvdWdoLiBUaGVuIEkgd2FudGVkIGdldCBzb21l
IG1vcmUgcGVyZm9ybWFuY2UgbnVtYmVycyBiZWZvcmUgZHJvcHBpbmcNCnRoZSBSRkMgdGFnLiBT
byBpdCBtYXkgc3RpbGwgYmUgYSBiaXQgYmVmb3JlIEkgY2FuIHBpY2sgdXAgdGhlIGtlcm5lbCB0
ZXh0IHBpZWNlDQphZ2Fpbi4NCg==
