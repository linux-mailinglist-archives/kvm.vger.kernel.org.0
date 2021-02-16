Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D541331D1CC
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 21:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBPU71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 15:59:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:12505 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhBPU70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 15:59:26 -0500
IronPort-SDR: AY7IHa8T+bO2ykwuAs1iFALJt6O/33Qkr+qqBXBE8CRdnOIXiJ8QtFqoGmoPLWTYqRyvr+aPIP
 8FO8T+y4j/wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="162149798"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="162149798"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 12:58:46 -0800
IronPort-SDR: IS7aWvtMSc2NAPEYrlFifN4vzGtGoPZjM0aeO0ZAvurJ6c7Wpe/EcjO/0tYMnPxEmGwVUpAa72
 VQ8xvyMTOXCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="439087487"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 16 Feb 2021 12:58:44 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 12:58:41 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Feb 2021 12:58:40 -0800
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15]) by
 ORSMSX602.amr.corp.intel.com ([10.22.229.15]) with mapi id 15.01.2106.002;
 Tue, 16 Feb 2021 12:58:40 -0800
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: RE: [RFC PATCH v5 00/26] KVM SGX virtualization support
Thread-Topic: [RFC PATCH v5 00/26] KVM SGX virtualization support
Thread-Index: AQHXAgp9y9UV1Fh2mEW8A1hOjmtPbKpbqrKA//+d7SA=
Date:   Tue, 16 Feb 2021 20:58:40 +0000
Message-ID: <0ef46b0e121a429aa8250bf1c2e8e716@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
 <0e4e044c-020e-51a3-1f27-123c81f22c33@intel.com>
In-Reply-To: <0e4e044c-020e-51a3-1f27-123c81f22c33@intel.com>
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

PiBPbiAyLzEzLzIxIDU6MjggQU0sIEthaSBIdWFuZyB3cm90ZToNCj4gPiAgYXJjaC94ODYva3Zt
L3ZteC9zZ3guYyAgICAgICAgICAgICAgICAgICAgICAgIHwgNDY2ICsrKysrKysrKysrKysrKysr
Kw0KPiA+ICBhcmNoL3g4Ni9rdm0vdm14L3NneC5oICAgICAgICAgICAgICAgICAgICAgICAgfCAg
MzQgKysNCj4gDQo+IENoYW5nZXMgdG8gdGhlc2UgZmlsZXMgd29uJ3QgaGl0IHRoZSBTR1ggTUFJ
TlRBSU5FUlMgZW50cnkgaWYgeW91IHJ1bg0KPiBnZXRfbWFpbnRhaW5lci5wbC4gIFRoYXQgbWVh
bnMgSmFya2tvIChhbmQgbWUsIGFuZCB0aGUgU0dYIG1haWxpbmcgbGlzdCkNCj4gcHJvYmFibHkg
d29uJ3QgZ2V0IGNjJ2Qgb24gY2hhbmdlcyBoZXJlLg0KPiANCj4gSXMgdGhhdCBhIGJ1ZyBvciBh
IGZlYXR1cmU/IDopDQoNClRoZSB0d28gZmlsZXMgb25seSBjb250YWlucyBzdGFmZiB0byB2aXJ0
dWFsaXplIFNHWCwgZm9yIGluc3RhbmNlLCBpbml0aWFsaXppbmcgdmlydHVhbCBTR1hfTEVQVUJL
RVlIQVNIIE1TUnMsIGhvdyB0byB0cmFwIGFuZCBydW4gRU5DTFNbRUNSRUFURS9FSU5JVF0sIGV0
Yy4NCg0KU2VhbiwgUGFvbG8sDQoNCldoYXQncyB5b3VyIGNvbW1lbnRzPw0K
