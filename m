Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73131C985
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 12:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhBPLQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 06:16:34 -0500
Received: from mga14.intel.com ([192.55.52.115]:11247 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhBPLQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 06:16:31 -0500
IronPort-SDR: OXEf40TxlM/NJhDx9/bBChETAijR0yUP2XiZFb9E2bOxTCzC/DYn9etnmHNsCNTmLMwgdYaCGD
 b6FfOD/sXn+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="182079232"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="182079232"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 03:15:36 -0800
IronPort-SDR: OHNR5e1JOcrH21t0+6p1clrEVmDONMaJDkqEZ9zsve3jqh5GyrI17ZRuRdC4zeqVFXg+MIfYWK
 F/LPJAdq2qRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="377524270"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Feb 2021 03:15:36 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 03:15:35 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 03:15:35 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 03:15:35 -0800
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
Thread-Index: AQHXAgqNtwlxthmplU6cFSX1Hb3mCqpalcMAgAACzaCAAId3AP//ga0A
Date:   Tue, 16 Feb 2021 11:15:35 +0000
Message-ID: <a792bf6271da4fddb537085845cf868f@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org> <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic>
In-Reply-To: <20210216103218.GB10592@zn.tnic>
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

PiANCj4gT24gVHVlLCBGZWIgMTYsIDIwMjEgYXQgMTA6MzA6MDNBTSArMDAwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiBCZWNhdXNlIHRob3NlIGNvbnRlbnRzIGFyZSAqYXJjaGl0ZWN0dXJhbCou
IFRoZXkgYXJlIGRlZmluZWQgaW4gU0RNLg0KPiA+DQo+ID4gQW5kIHBhdGNoIDEzICh4ODYvc2d4
OiBBZGQgaGVscGVycyB0byBleHBvc2UgRUNSRUFURSBhbmQgRUlOSVQgdG8gS1ZNKQ0KPiA+IHdp
bGwgaW50cm9kdWNlIGFyY2gveDg2L2luY2x1ZGUvYXNtL3NneC5oLCB3aGVyZSBub24tYXJjaGl0
ZWN0dXJhbA0KPiA+IGZ1bmN0aW9ucyB3aWxsIGJlIGRlY2xhcmVkLg0KPiANCj4gV2hvIGNhcmVz
IGFib3V0IHRoZSBTRE0/DQoNClNvcnJ5IEkgYW0gbm90IHN1cmUgSSB1bmRlcnN0YW5kIHlvdXIg
cXVlc3Rpb24uIENvdWxkIHlvdSBlbGFib3JhdGU/DQoNCklNSE8gaXQncyBiZXR0ZXIgdG8gcHV0
IGFyY2hpdGVjdHVyYWwgc3RhZmYgKHN1Y2ggYXMgZGF0YSBzdHJ1Y3R1cmVzIGRlZmluZWQgaW4g
U0RNIGFuZCB1c2VkIGJ5IGhhcmR3YXJlKSBpbnRvIG9uZSBoZWFkZXIsIGFuZCBvdGhlciBub24t
YXJjaGl0ZWN0dXJhbCBzdGFmZiBpbnRvIGFub3RoZXIgaGVhZGVyLCBzbyB0aGF0IHRoZSB1c2Vy
IGNhbiBpbmNsdWRlIHRoZSBvbmUgdGhhdCBpcyBhY3R1YWxseSByZXF1aXJlZCwgYnV0IGRvZXNu
J3QgaGF2ZSB0byBpbmNsdWRlIG9uZSBiaWcgaGVhZGVyIHdoaWNoIGluY2x1ZGVzIGFsbCBTR1gg
cmVsYXRlZCBkYXRhIHN0cnVjdHVyZXMgYW5kIGZ1bmN0aW9ucy4NCg0K
