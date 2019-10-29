Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF92E93F2
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 00:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfJ2XwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 19:52:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:7979 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfJ2XwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 19:52:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 16:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="374722086"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 29 Oct 2019 16:52:09 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 29 Oct 2019 16:52:09 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.185]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.32]) with mapi id 14.03.0439.000;
 Tue, 29 Oct 2019 16:52:09 -0700
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
Subject: Re: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Thread-Topic: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Thread-Index: AQHVejL7mBDeeBJOYUiqz0B6Xhz7/Kdy452AgAAFHYA=
Date:   Tue, 29 Oct 2019 23:52:08 +0000
Message-ID: <40cb4ea3b351c25074cf47ae92a189eec12161fb.camel@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
         <20191003212400.31130-10-rick.p.edgecombe@intel.com>
         <201910291633.927254B10@keescook>
In-Reply-To: <201910291633.927254B10@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.54.75.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1C2AA5FB5F4D74399AC021AA1C2826D@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTI5IGF0IDE2OjMzIC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IFRodSwgT2N0IDAzLCAyMDE5IGF0IDAyOjIzOjU2UE0gLTA3MDAsIFJpY2sgRWRnZWNvbWJlIHdy
b3RlOg0KPiA+IEFkZCBhIG5ldyBDUFVJRCBsZWFmIHRvIGhvbGQgdGhlIGNvbnRlbnRzIG9mIENQ
VUlEIDB4NDAwMDAwMzAgRUFYIHRvDQo+ID4gZGV0ZWN0IEtWTSBkZWZpbmVkIGdlbmVyaWMgVk1N
IGZlYXR1cmVzLg0KPiA+IA0KPiA+IFRoZSBsZWFmIHdhcyBwcm9wb3NlZCB0byBhbGxvdyBLVk0g
dG8gY29tbXVuaWNhdGUgZmVhdHVyZXMgdGhhdCBhcmUNCj4gPiBkZWZpbmVkIGJ5IEtWTSwgYnV0
IGF2YWlsYWJsZSBmb3IgYW55IFZNTSB0byBpbXBsZW1lbnQuDQo+ID4gDQo+ID4gQWRkIGNwdV9m
ZWF0dXJlX2VuYWJsZWQoKSBzdXBwb3J0IGZvciBmZWF0dXJlcyBpbiB0aGlzIGxlYWYgKEtWTSBY
TyksIGFuZA0KPiA+IGEgcGd0YWJsZV9rdm14b19lbmFibGVkKCkgaGVscGVyIHNpbWlsYXIgdG8g
cGd0YWJsZV9sNV9lbmFibGVkKCkgc28gdGhhdA0KPiA+IHBndGFibGVfa3ZteG9fZW5hYmxlZCgp
IGNhbiBiZSB1c2VkIGluIGVhcmx5IGNvZGUgdGhhdCBpbmNsdWRlcw0KPiA+IGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL3NwYXJzZW1lbS5oLg0KPiA+IA0KPiA+IExhc3RseSwgaW4gaGVhZDY0LmMgZGV0
ZWN0IGFuZCB0aGlzIGZlYXR1cmUgYW5kIHBlcmZvcm0gbmVjZXNzYXJ5DQo+ID4gYWRqdXN0bWVu
dHMgdG8gcGh5c2ljYWxfbWFzay4NCj4gDQo+IENhbiB0aGlzIGJlIGV4cG9zZWQgdG8gL3Byb2Mv
Y3B1aW5mbyBzbyBhIGd1ZXN0IHVzZXJzcGFjZSBjYW4gZGV0ZXJtaW5lDQo+IGlmIHRoaXMgZmVh
dHVyZSBpcyBlbmFibGVkPw0KPiANCj4gLUtlZXMNCg0KSXMgdGhlcmUgYSBnb29kIHBsYWNlIHRv
IGV4cG9zZSB0aGUgaW5mb3JtYXRpb24gdGhhdCB0aGUgUFJPVF9FWEVDIGFuZA0KIVBST1RfUkVB
RCBjb21ibyBjcmVhdGVzIGV4ZWN1dGUtb25seSBtZW1vcnk/IFRoaXMgd2F5IGFwcHMgY2FuIGNo
ZWNrIG9uZSBwbGFjZQ0KZm9yIHRoZSBzdXBwb3J0IGFuZCBub3Qgd29ycnkgYWJvdXQgdGhlIGlt
cGxlbWVudGF0aW9uIHdoZXRoZXIgaXQncyB0aGlzLCB4ODYNCnBrZXlzLCBhcm0gb3Igb3RoZXIu
DQo=
