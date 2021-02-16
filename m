Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F431CA44
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 12:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhBPL5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 06:57:39 -0500
Received: from mga18.intel.com ([134.134.136.126]:50548 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhBPL5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 06:57:25 -0500
IronPort-SDR: bc/phsjlxRIO7mHOnSrIPokb8sz+myfwpoAALOY/i2evNpFuhngwGVQzPGXtm5Ah8+bc0h6/sf
 W94Y/56C3X3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="170527266"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="170527266"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 03:56:41 -0800
IronPort-SDR: 3Fd3atm6Q5PB6/Zz/EwQKid+oaWGsVb7sjmHQNTFnXMz72aqJMPOasLEptzygCRehiH6b6gu5v
 xvkl8eZuWSOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="418065709"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 16 Feb 2021 03:56:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 03:56:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 03:56:40 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 03:56:39 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Jarkko Sakkinen <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Thread-Topic: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Thread-Index: AQHXAgqNtwlxthmplU6cFSX1Hb3mCqpalcMAgAACzaCAAId3AP//ga0AgACTtoD//3rw4A==
Date:   Tue, 16 Feb 2021 11:56:39 +0000
Message-ID: <5ed9fee6292f4d779003aff3dddf3ae0@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org> <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic> <a792bf6271da4fddb537085845cf868f@intel.com>
 <20210216114851.GD10592@zn.tnic>
In-Reply-To: <20210216114851.GD10592@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gVHVlLCBGZWIgMTYsIDIwMjEgYXQgMTE6MTU6MzVBTSArMDAwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiBTb3JyeSBJIGFtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCB5b3VyIHF1ZXN0
aW9uLiBDb3VsZCB5b3UgZWxhYm9yYXRlPw0KPiA+DQo+ID4gSU1ITyBpdCdzIGJldHRlciB0byBw
dXQgYXJjaGl0ZWN0dXJhbCBzdGFmZiAoc3VjaCBhcyBkYXRhIHN0cnVjdHVyZXMNCj4gPiBkZWZp
bmVkIGluIFNETSBhbmQgdXNlZCBieSBoYXJkd2FyZSkgaW50byBvbmUgaGVhZGVyLCBhbmQgb3Ro
ZXINCj4gPiBub24tYXJjaGl0ZWN0dXJhbCBzdGFmZiBpbnRvIGFub3RoZXIgaGVhZGVyLCBzbyB0
aGF0IHRoZSB1c2VyIGNhbg0KPiA+IGluY2x1ZGUgdGhlIG9uZSB0aGF0IGlzIGFjdHVhbGx5IHJl
cXVpcmVkLCBidXQgZG9lc24ndCBoYXZlIHRvIGluY2x1ZGUNCj4gPiBvbmUgYmlnIGhlYWRlciB3
aGljaCBpbmNsdWRlcyBhbGwgU0dYIHJlbGF0ZWQgZGF0YSBzdHJ1Y3R1cmVzIGFuZA0KPiA+IGZ1
bmN0aW9ucy4NCj4gDQo+IEFuZCBpbmNsdWRpbmcgb25lIGJpZyAtIChub3Qgc3VyZSBhYm91dCAi
YmlnIiAtIHdlIGhhdmUgYSBsb3QgYmlnZ2VyKSAtIGhlYWRlciBpcw0KPiBhbiBhY3R1YWwgcHJv
YmxlbSBiZWNhdXNlPw0KPiANCj4gV2hhdCBJJ20gdHJ5aW5nIHRvIHBvaW50IHlvdSBhdCBpcywg
dG8gbm90IGdpdmUgc29tZSBhcnRpZmljaWFsIHJlYXNvbnMgd2h5IHRoZQ0KPiBoZWFkZXJzIHNo
b3VsZCBiZSBzZXBhcmF0ZSAtIGFydGlmaWNpYWwgYXMgdGhlIFNETSBzYXlzIGl0IGlzIGFyY2hp
dGVjdHVyYWwgYW5kIHNvDQo+IG9uIC0gYnV0IGdpdmUgYSByZWFzb24gZnJvbSBzb2Z0d2FyZSBk
ZXNpZ24gcGVyc3BlY3RpdmUgd2h5IHRoZSBzZXBhcmF0aW9uIGlzDQo+IG5lZWRlZDogYmV0dGVy
IGJ1aWxkIHRpbWVzLCBsZXNzIHN5bWJvbHMgZXhwb3NlZCB0byBtb2R1bGVzLCBibGFibGEgYW5k
IHNvIG9uLg0KPiANCj4gSWYgeW91IGRvbid0IGhhdmUgc3VjaCByZWFzb25zLCB0aGVuIGl0IGFs
bCBpcyBqdXN0IHVubmVjZXNzYXJ5IGFuZCBub3QgbmVlZGVkDQo+IGNodXJuLiBBbmQgaW4gdGhh
dCBjYXNlLCBrZWVwaW5nIGl0IHNpbXBsZSBpcyB0aGUgcHJvcGVyIGFwcHJvYWNoLg0KPiANCj4g
VGhvc2UgaGVhZGVycyBjYW4gYWx3YXlzIGJlIHNwbGl0IGxhdGVyLCB3aGVuIHJlYWxseSBuZWVk
ZWQuDQo+IA0KPiBIVEguDQoNClRoYW5rcyBmb3IgZmVlZGJhY2shIEknbGwgdGFrZSBhIGRlZXBl
ciBsb29rIGF0IHRoZSBjb2RlIGFuZCBnaXZlIGZlZWRiYWNrICh0b28gbGF0ZSBmb3IgbWUgdG9k
YXkpLg0KDQo+IA0KPiAtLQ0KPiBSZWdhcmRzL0dydXNzLA0KPiAgICAgQm9yaXMuDQo+IA0KPiBo
dHRwczovL3Blb3BsZS5rZXJuZWwub3JnL3RnbHgvbm90ZXMtYWJvdXQtbmV0aXF1ZXR0ZQ0K
